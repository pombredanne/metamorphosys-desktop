﻿/*
Copyright (C) 2013-2015 MetaMorph Software, Inc

Permission is hereby granted, free of charge, to any person obtaining a
copy of this data, including any software or models in source or binary
form, as well as any drawings, specifications, and documentation
(collectively "the Data"), to deal in the Data without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Data, and to
permit persons to whom the Data is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Data.

THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using META;

using Tonka = ISIS.GME.Dsml.CyPhyML.Interfaces;
using TonkaClasses = ISIS.GME.Dsml.CyPhyML.Classes;

namespace CyPhy2Schematic.Schematic
{
    class SpiceVisitor : Visitor
    {
        private int netCount = 0;
        private Dictionary<Port, string> PortNetMap;
        private Dictionary<Component, Spice.Node> ComponentNodeMap;
        private Dictionary<Object, Spice.SignalBase> ObjectSiginfoMap;

        private string[] Grounds = new string[] { "gnd", "Gnd", "GND", "ground", "Ground" };
        private string[] SigIntegrityTraces;

        public Spice.Circuit circuit_obj { get; set; }
        public Spice.SignalContainer siginfo_obj { get; set; }

        public CodeGenerator.Mode mode { get; set; }

        public SpiceVisitor()
        {
            PortNetMap = new Dictionary<Port, string>();
            ComponentNodeMap = new Dictionary<Component, Spice.Node>();
            ObjectSiginfoMap = new Dictionary<object, Spice.SignalBase>();
            netCount = 0;
        }

        private Tuple<char, string> GetSpiceType(Component obj)
        {
            var spiceObj = (obj.Impl is Tonka.TestComponent) ?
                (obj.Impl as Tonka.TestComponent).Children.SPICEModelCollection.FirstOrDefault() :
                (obj.Impl as Tonka.Component).Children.SPICEModelCollection.FirstOrDefault();
            string[] spiceType = (spiceObj != null) ? spiceObj.Attributes.Class.Split(new char[] { ':', ' ', '.' }) : null;

            char baseType = (spiceType != null && spiceType.Count() > 0 && spiceType[0].Length > 0) ? spiceType[0][0] : (char)0;
            string classType = (spiceType != null && spiceType.Count() > 1) ? spiceType[1] : "";

            var tuple = new Tuple<char, string>(baseType, classType);

            return tuple;
        }

        private List<Component> CollectGroundNodes(ComponentAssembly obj)
        {
            var gnds = obj.ComponentInstances.Where(t =>
                Grounds.Any(GetSpiceType(t).Item2.Contains)
                ).ToList();
            var cgnds = obj.ComponentAssemblyInstances.SelectMany(ca => CollectGroundNodes(ca)).ToList();
            return gnds.Union(cgnds).ToList();
        }

        private List<Component> CollectGroundNodes(TestBench obj)
        {
            var gnds = obj.TestComponents.Where(t =>
                Grounds.Any(GetSpiceType(t).Item2.Contains)
                ).ToList();
            var cgnds = obj.ComponentAssemblies.SelectMany(ca => CollectGroundNodes(ca)).ToList();
            return gnds.Union(cgnds).ToList();
        }

        private void GenerateTraceSubckt(LayoutJson.Signal trace)
        {
            // this is where the smarts of what type of trace subcircuit to generate will reside
            // reference hspice98 - chapter21, pp 21-2: Selecting Wire Models

            // choices for wire models:
            // 1. no model
            // 2. lumped models with RLC - simple R, shunt cap C, series inductor and resistor RL, series resistor and shunt cap RC
            // 3. ideal - lossless transmission line
            // 4. lossy transmission line

            // decision based on : 
            // 1. source properties: rise time - trise, source resistance - Rsource
            // 2. connector properties: characteristic impedance - Z0, time delay - TD (function of length/frequency)
            //                  OR    : equiv resistance - R, equiv inductance - L, equiv capacitance - C
 
            // decision tree: Figure 21-1, Wire Model Selection Chart (wire_select.jpg)
            // a) trise > 5TD (low frequency) --- use lumped model with RLC (criteria for R / RL / RC in wire_select.jpg)
            // b) trise < 5TD (high frequence) --- use lossy or lossless transmission line
            StringWriter subckt = new StringWriter();
            subckt.WriteLine(".subckt Trace_{0} 1 2", trace.name);
            subckt.WriteLine("* Simple Transmission Line Model ");
            subckt.WriteLine("TL 1 0 2 0 Z0=50 TD=10ns");
            subckt.WriteLine(".ends Trace_{0}", trace.name);
            circuit_obj.subcircuits.Add(string.Format("Trace_{0}", trace.name), subckt.ToString());
        }

        public override void visit(TestBench obj)
        {
            if (obj.SolverParameters.ContainsKey("SpiceAnalysis"))
            {
                circuit_obj.analysis = obj.SolverParameters["SpiceAnalysis"];
            }
            var tracesParam = obj.Parameters.Where(p => p.Name.Equals("Traces")).FirstOrDefault();
            if (tracesParam != null)
                SigIntegrityTraces = tracesParam.Value.Split(new char[] { ' ', ',' });

            // process all ground nets first before they get assigned another number
            var gnds = CollectGroundNodes(obj);
            var gports = gnds.SelectMany(g => g.Ports).ToList();
            foreach (var gp in gports)
            {
                visit(gp, "0");
            }
        }

        public override void visit(ComponentAssembly obj)
        {
            CodeGenerator.Logger.WriteDebug(
                    "SpiceVisitor::visit({0})",
                    obj.Name);

            // create a signal container for this assembly
            var siginfo_obj = new Spice.SignalContainer()
            {
                name = obj.Name,
                gmeid = obj.Impl.ID
            };
            ObjectSiginfoMap.Add(obj, siginfo_obj);
            var siginfo_parent = this.siginfo_obj;
            if (obj.Parent != null && ObjectSiginfoMap.ContainsKey(obj.Parent))
            {
                siginfo_parent = ObjectSiginfoMap[obj.Parent] as Spice.SignalContainer;
            }
            siginfo_parent.signals.Add(siginfo_obj);
        }

        public override void visit(Component obj)
        {
            CodeGenerator.Logger.WriteDebug(
                    "SpiceVisitor::visit({0})",
                    obj.Name);

            // create a signal container for this component
            var siginfo_obj = new Spice.SignalContainer()
            {
                name = obj.Name,
                gmeid = obj.Impl.ID
            };
            ObjectSiginfoMap.Add(obj, siginfo_obj);
            var siginfo_parent = this.siginfo_obj;
            if (obj.Parent != null && ObjectSiginfoMap.ContainsKey(obj.Parent))
            {
                siginfo_parent = ObjectSiginfoMap[obj.Parent] as Spice.SignalContainer;
            }
            siginfo_parent.signals.Add(siginfo_obj);

            var nodes = circuit_obj.nodes;
            var spiceObj = obj.Impl.Children.SPICEModelCollection.FirstOrDefault();
            if (spiceObj == null) // no spice model in this component, skip from generating 
            {
                return;
            }

            var spiceType = GetSpiceType(obj);

            if (Grounds.Any(spiceType.Item2.Contains))  // is a ground node skip it
            {
                return;
            }

            var node = new Spice.Node();
            node.name = obj.Name;
            node.type = spiceType.Item1;
            node.classType = spiceType.Item2;

            // error checking 
            if (node.type == (char)0)
            {
                CodeGenerator.Logger.WriteWarning("Missing Spice Type for component {0}", obj.Name);
            }
            if (node.type == 'X' && node.classType == "")
            {
                CodeGenerator.Logger.WriteWarning("Missing Subcircuit Type for component {0}, should be X.<subckt-type>", obj.Name);
            }

            if (node.classType != "" && !circuit_obj.subcircuits.ContainsKey(node.classType))
            {
                circuit_obj.subcircuits.Add(node.classType, obj.SpiceLib);
            }

            foreach (var par in spiceObj.Children.SPICEModelParameterCollection)
            {
                if (node.parameters.ContainsKey(par.Name))
                {
                    CodeGenerator.Logger.WriteError("Duplicate Parameter: {0}: in Component <a href=\"mga:{2}\">{1}</a>",
                        par.Name,
                        obj.Name,
                        obj.Impl.ID);
                }
                else
                {
                    node.parameters.Add(par.Name, par.Attributes.Value);
                }
            }

            nodes.Add(node);
            ComponentNodeMap[obj] = node;
        }

        public override void visit(Port obj)
        {
            CodeGenerator.Logger.WriteDebug(
                    "SpiceVisitor::visit({0}, dest connections: {1})",
                    obj.Name, obj.DstConnections.Count);

            if (!ComponentNodeMap.ContainsKey(obj.Parent)) // parent is a ground node
            {
                return;
            }

            var parentNode = ComponentNodeMap[obj.Parent];  // parent node
            var siginfo_parent = this.siginfo_obj;
            if (ObjectSiginfoMap.ContainsKey(obj.Parent))
            {
                siginfo_parent = ObjectSiginfoMap[obj.Parent] as Spice.SignalContainer;
            }

            int index = 0;
            try
            {
                index = obj.Impl.Attributes.SPICEPortNumber;
                if (index >= 0 && parentNode.nets.ContainsKey(index))
                {
                    CodeGenerator.Logger.WriteError("Duplicate SPICE Port Number: {0}: for Port <a href=\"mga:{2}\">{1}</a>",
                        index, obj.Name, obj.Impl.ID);
                    return;
                }
            }
            catch (System.FormatException ex)
            {
                index = -1;     // missing index
                CodeGenerator.Logger.WriteWarning("Invalid SPICE Port Number: {0}: for Port: <a href=\"mga:{2}\">{1}</a>",
                                                  obj.Impl.Attributes.SPICEPortNumber,
                                                  obj.Name, obj.Impl.ID);
            }

            if (PortNetMap.ContainsKey(obj))// port already mapped to a net object - no need to visit further
            {
                if (index >= 0) parentNode.nets.Add(index, PortNetMap[obj]);
                // spice signal info
                var siginfo_obj = new Spice.Signal()
                {
                    name = obj.Name,
                    gmeid = obj.Impl.ID,
                    spicePort = obj.Impl.Attributes.SPICEPortNumber,
                    net = PortNetMap[obj]
                };
                siginfo_parent.signals.Add(siginfo_obj);

                return;
            }

            // create a new net, 
            string net_obj = string.Format("{0}", ++netCount);
            if (!parentNode.nets.ContainsKey(index))
            {
                if (index >= 0) parentNode.nets.Add(index, net_obj);
                // spice signal info
                var siginfo_obj = new Spice.Signal()
                {
                    name = obj.Name,
                    gmeid = obj.Impl.ID,
                    spicePort = obj.Impl.Attributes.SPICEPortNumber,
                    net = net_obj
                };
                siginfo_parent.signals.Add(siginfo_obj);
            }
            else
            {
                CodeGenerator.Logger.WriteWarning("Invalid SpiceOrder attribute for schematic port: <a href=\"mga:{0}\">{1}</a>",
                                                  obj.Impl.ID,
                                                  obj.Name);
            }

            // if we are in the signal integrity mode and the port has an associated parsed trace
            if (mode == CodeGenerator.Mode.SPICE_SI && 
                CodeGenerator.signalIntegrityLayout.portTraceMap.ContainsKey(obj))
            {
                var trace = CodeGenerator.signalIntegrityLayout.portTraceMap[obj];
                if (SigIntegrityTraces.Contains(trace.name))
                {
                    CodeGenerator.Logger.WriteInfo("Generating Trace Subcircuit for {0} on Port {1}.{2}", trace.name, obj.Parent.Name, obj.Name);
                    // insert a subckt to model a trace
                    var traceNode = new Spice.Node();
                    traceNode.name = trace.name;
                    traceNode.type = 'X';
                    traceNode.classType = string.Format("Trace_{0}", trace.name);
                    traceNode.nets.Add(0, net_obj);
                    // create a new net to replace the original net and carry that wire further
                    net_obj = string.Format("{0}", ++netCount);
                    traceNode.nets.Add(1, net_obj);
                    circuit_obj.nodes.Add(traceNode);
                    // generate the subckt
                    GenerateTraceSubckt(trace);
                }
            }
            else if (CodeGenerator.verbose)
                CodeGenerator.Logger.WriteWarning("Port {0} has no Trace", obj.Impl.Path); 



            // assign to all connected ports - some nets may not have any connection
            visit(obj, net_obj);
        }

        private void visit(Port obj, string net_obj)
        {
            if (PortNetMap.ContainsKey(obj))
            {
                CodeGenerator.Logger.WriteDebug("Port {0}, already visited with net {1}, now {2}", obj.Name, PortNetMap[obj], net_obj);
                return;
            }
            PortNetMap[obj] = net_obj;  // add to map

            var allPorts =
                (from conn in obj.DstConnections select conn.DstPort).Union
                (from conn in obj.SrcConnections select conn.SrcPort);

            foreach (var port in allPorts) // visit sources
            {
                if (!PortNetMap.ContainsKey(port))
                    this.visit(port, net_obj);
            }
        }

    }
}