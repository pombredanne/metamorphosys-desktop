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

=======================
This version of the META tools is a fork of an original version produced
by Vanderbilt University's Institute for Software Integrated Systems (ISIS).
Their license statement:

Copyright (C) 2011-2014 Vanderbilt University

Developed with the sponsorship of the Defense Advanced Research Projects
Agency (DARPA) and delivered to the U.S. Government with Unlimited Rights
as defined in DFARS 252.227-7013.

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
using System.IO;
using System.Linq;
using System.Reflection;
using avm;
using CyPhy2ComponentModel;
using GME.CSharp;
using GME.MGA;
using GME.MGA.Meta;
// using domain specific interfaces
using CyPhyML = ISIS.GME.Dsml.CyPhyML.Interfaces;
using CyPhyMLClasses = ISIS.GME.Dsml.CyPhyML.Classes;

namespace AVM2CyPhyML {

    using System.Text.RegularExpressions;
    using TypePair = KeyValuePair<Type, Type>;

	public class TypePairCompare : IComparer<TypePair> {

		public static bool isPairSubclassOf(TypePair typePair1, TypePair typePair2) {
			bool f1 = typePair2.Key.UnderlyingSystemType.IsAssignableFrom(typePair2.Key.UnderlyingSystemType);
			bool f2 = typePair2.Value.UnderlyingSystemType.IsAssignableFrom(typePair2.Value.UnderlyingSystemType);
			return typePair2.Key.UnderlyingSystemType.IsAssignableFrom(typePair1.Key.UnderlyingSystemType) && typePair2.Value.UnderlyingSystemType.IsAssignableFrom(typePair1.Value.UnderlyingSystemType);
		}

		public static string getTypeName( Type type ) {
			return type.Namespace + "." + type.Name;
		}

		public static int compareTypeNames(Type type1, Type type2) {
			return getTypeName(type1.UnderlyingSystemType).CompareTo(getTypeName(type2.UnderlyingSystemType));
		}

		public int Compare(TypePair typePair1, TypePair typePair2) {
			int keyCompare = compareTypeNames(typePair1.Key, typePair2.Key);
			if ( keyCompare != 0 ) return keyCompare;

			return compareTypeNames(typePair1.Value, typePair2.Value);
		}
	}

    public abstract class AVM2CyPhyMLBuilder
    {
        public AVM2CyPhyMLBuilder(CyPhyML.RootFolder rootFolder, object messageConsoleParameter = null)
        {
            _cyPhyMLRootFolder = rootFolder;
            messageConsole = messageConsoleParameter;
        }

        protected IMgaProject project { get { return _cyPhyMLRootFolder.Impl.Project; } }
        protected Dictionary<String, CyPhyML.unit> _unitSymbolCyPhyMLUnitMap = new Dictionary<string, CyPhyML.unit>();

        protected CyPhyML.RootFolder _cyPhyMLRootFolder;
        protected List<CyPhyML.Units> _cyPhyMLUnitsFolders;
        protected CyPhyML.Ports _cyPhyMLPorts;

        /// <summary>
        /// Tracks whether any incoming members have layout data.
        /// If not, we'll run a layout algorithm at the end.
        /// </summary>
        protected Boolean aMemberHasLayoutData = false;

        protected Dictionary<object, Object> _avmCyPhyMLObjectMap = new Dictionary<object, object>();
        protected Dictionary<string, avm.PortMapTarget> _avmPortIDMap = new Dictionary<string, avm.PortMapTarget>();
        protected HashSet<avm.PortMapTarget> _avmPortSet = new HashSet<avm.PortMapTarget>();
        protected Dictionary<string, avm.Resource> _avmResourceIDMap = new Dictionary<string, avm.Resource>();
        protected Dictionary<string, KeyValuePair<avm.ValueNode, object>> _avmValueNodeIDMap = new Dictionary<string, KeyValuePair<ValueNode, object>>();
        protected HashSet<KeyValuePair<avm.ValueNode, object>> _avmValueNodeSet = new HashSet<KeyValuePair<ValueNode, object>>();

		private object _messageConsole = null;

        protected readonly Regex cadResourceRegex = new Regex("^(.*)(\\.prt|\\.asm)\\.([0-9]*)$", RegexOptions.IgnoreCase);

        protected Dictionary<String, CreateMethodProxyBase> _cyPhyMLNameCreateMethodMap = new Dictionary<String, CreateMethodProxyBase>() {
			{ typeof(avm.cad.Axis).ToString(),                         CreateMethodProxy<CyPhyMLClasses.Axis>.get_singleton() },
			{ typeof(avm.cad.CoordinateSystem).ToString(),             CreateMethodProxy<CyPhyMLClasses.CoordinateSystem>.get_singleton() },
			{ typeof(avm.cad.Plane).ToString(),                        CreateMethodProxy<CyPhyMLClasses.Surface>.get_singleton() },
			{ typeof(avm.cad.Point).ToString(),                        CreateMethodProxy<CyPhyMLClasses.Point>.get_singleton() },
			{ typeof(avm.AbstractPort).ToString(),                     CreateMethodProxy<CyPhyMLClasses.AbstractPort>.get_singleton() },
			{ typeof(avm.modelica.Connector).ToString(),               CreateMethodProxy<CyPhyMLClasses.ModelicaConnector>.get_singleton() },
			{ typeof(avm.SecurityClassification).ToString(),           CreateMethodProxy<CyPhyMLClasses.SecurityClassification>.get_singleton() },
			{ typeof(avm.Proprietary).ToString(),                      CreateMethodProxy<CyPhyMLClasses.Proprietary>.get_singleton() },
			{ typeof(avm.ITAR).ToString(),                             CreateMethodProxy<CyPhyMLClasses.ITAR>.get_singleton() },
			{ typeof(avm.schematic.Pin).ToString(),                    CreateMethodProxy<CyPhyMLClasses.SchematicModelPort>.get_singleton() },
			{ typeof(avm.systemc.SystemCPort).ToString(),              CreateMethodProxy<CyPhyMLClasses.SystemCPort>.get_singleton() },
            { typeof(avm.rf.RFPort).ToString(),                        CreateMethodProxy<CyPhyMLClasses.RFPort>.get_singleton() },
            { typeof(avm.DoDDistributionStatement).ToString(),         CreateMethodProxy<CyPhyMLClasses.DoDDistributionStatement>.get_singleton() } 


			//{ typeof( CyPhyMLClasses.Axis ).Name,                      CreateMethodProxy<CyPhyMLClasses.Axis>.get_singleton() },
			//{ typeof( CyPhyMLClasses.Surface ).Name,                   CreateMethodProxy<CyPhyMLClasses.Surface>.get_singleton() },
			//{ typeof( CyPhyMLClasses.Point ).Name,                     CreateMethodProxy<CyPhyMLClasses.Point>.get_singleton() },
			//{ typeof( CyPhyMLClasses.CoordinateSystem ).Name,          CreateMethodProxy<CyPhyMLClasses.CoordinateSystem>.get_singleton() },
			//{ typeof( CyPhyMLClasses.AxisGeometry ).Name,              CreateMethodProxy<CyPhyMLClasses.AxisGeometry>.get_singleton() },
			//{ typeof( CyPhyMLClasses.SurfaceGeometry ).Name,           CreateMethodProxy<CyPhyMLClasses.SurfaceGeometry>.get_singleton() },
			//{ typeof( CyPhyMLClasses.PointGeometry ).Name,             CreateMethodProxy<CyPhyMLClasses.PointGeometry>.get_singleton() },
			//{ typeof( CyPhyMLClasses.CoordinateSystemGeometry ).Name,  CreateMethodProxy<CyPhyMLClasses.CoordinateSystemGeometry>.get_singleton() },
			//{ typeof( CyPhyMLClasses.ElectricalPin ).Name,             CreateMethodProxy<CyPhyMLClasses.ElectricalPin>.get_singleton() },
			//{ typeof( CyPhyMLClasses.RotationalFlange ).Name,          CreateMethodProxy<CyPhyMLClasses.RotationalFlange>.get_singleton() },
			//{ typeof( CyPhyMLClasses.FluidPort ).Name,                 CreateMethodProxy<CyPhyMLClasses.FluidPort>.get_singleton() },
			//{ typeof( CyPhyMLClasses.MultibodyFrame ).Name,            CreateMethodProxy<CyPhyMLClasses.MultibodyFrame>.get_singleton() },
			//{ typeof( CyPhyMLClasses.HeatPort ).Name,                  CreateMethodProxy<CyPhyMLClasses.HeatPort>.get_singleton() },
			//{ typeof( CyPhyMLClasses.TranslationalFlange ).Name,       CreateMethodProxy<CyPhyMLClasses.TranslationalFlange>.get_singleton() },
			//{ typeof( CyPhyMLClasses.FlowPort ).Name,                  CreateMethodProxy<CyPhyMLClasses.FlowPort>.get_singleton() },
			//{ typeof( CyPhyMLClasses.AggregatePort ).Name,             CreateMethodProxy<CyPhyMLClasses.AggregatePort>.get_singleton() },
			//{ typeof( CyPhyMLClasses.RealInput ).Name,                 CreateMethodProxy<CyPhyMLClasses.RealInput>.get_singleton() },
			//{ typeof( CyPhyMLClasses.IntegerInput ).Name,              CreateMethodProxy<CyPhyMLClasses.IntegerInput>.get_singleton() },
			//{ typeof( CyPhyMLClasses.BooleanInput ).Name,              CreateMethodProxy<CyPhyMLClasses.BooleanInput>.get_singleton() },
			//{ typeof( CyPhyMLClasses.RealOutput ).Name,                CreateMethodProxy<CyPhyMLClasses.RealOutput>.get_singleton() },
			//{ typeof( CyPhyMLClasses.IntegerOutput ).Name,             CreateMethodProxy<CyPhyMLClasses.IntegerOutput>.get_singleton() },
			//{ typeof( CyPhyMLClasses.BooleanOutput ).Name,             CreateMethodProxy<CyPhyMLClasses.BooleanOutput>.get_singleton() },
			//{ typeof( CyPhyMLClasses.BusPort ).Name,                   CreateMethodProxy<CyPhyMLClasses.BusPort>.get_singleton() },
			//{ typeof( CyPhyMLClasses.ManufacturingModel ).Name,        CreateMethodProxy<CyPhyMLClasses.ManufacturingModel>.get_singleton() },
			//{ typeof(CyPhyMLClasses.ManufacturingModelParameter ).Name,CreateMethodProxy<CyPhyMLClasses.ManufacturingModelParameter>.get_singleton() }
		};

        protected SortedDictionary<TypePair, ConnectProxy> _cyPhyMLConnectionMap = new SortedDictionary<TypePair, ConnectProxy>( new TypePairCompare() );
        protected Dictionary<string, CyPhyML.Port> _portNameTypeMap = new Dictionary<string, CyPhyML.Port>();

        protected Dictionary<avm.DataTypeEnum, CyPhyMLClasses.Property.AttributesClass.DataType_enum> _dataTypePropertyEnumMap = new Dictionary<DataTypeEnum,CyPhyMLClasses.Property.AttributesClass.DataType_enum>() {
            { avm.DataTypeEnum.Boolean, CyPhyMLClasses.Property.AttributesClass.DataType_enum.Boolean },
            { avm.DataTypeEnum.Integer, CyPhyMLClasses.Property.AttributesClass.DataType_enum.Integer },
            { avm.DataTypeEnum.Real,    CyPhyMLClasses.Property.AttributesClass.DataType_enum.Float },
            { avm.DataTypeEnum.String,  CyPhyMLClasses.Property.AttributesClass.DataType_enum.String }
        };

        protected Dictionary<avm.DataTypeEnum, CyPhyMLClasses.Parameter.AttributesClass.DataType_enum> _dataTypeParameterEnumMap = new Dictionary<DataTypeEnum, CyPhyMLClasses.Parameter.AttributesClass.DataType_enum>() {
            { avm.DataTypeEnum.Boolean, CyPhyMLClasses.Parameter.AttributesClass.DataType_enum.Boolean },
            { avm.DataTypeEnum.Integer, CyPhyMLClasses.Parameter.AttributesClass.DataType_enum.Integer },
            { avm.DataTypeEnum.Real,    CyPhyMLClasses.Parameter.AttributesClass.DataType_enum.Float },
            { avm.DataTypeEnum.String,  CyPhyMLClasses.Parameter.AttributesClass.DataType_enum.String }
        };

        private static Dictionary<avm.SimpleFormulaOperation, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum> sfOperatorMap
            = new Dictionary<avm.SimpleFormulaOperation, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum>()
            {
                {avm.SimpleFormulaOperation.Addition, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum.Addition},
                {avm.SimpleFormulaOperation.ArithmeticMean, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum.ArithmeticMean},
                {avm.SimpleFormulaOperation.GeometricMean, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum.GeometricMean},
                {avm.SimpleFormulaOperation.Maximum, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum.Maximum},
                {avm.SimpleFormulaOperation.Minimum, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum.Minimum},
                {avm.SimpleFormulaOperation.Multiplication, CyPhyMLClasses.SimpleFormula.AttributesClass.Method_enum.Multiplication}
            };

        #region SystemC Enum Maps
        private Dictionary<avm.systemc.SystemCDataTypeEnum, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum> d_SystemCPort_DataType
            = new Dictionary<avm.systemc.SystemCDataTypeEnum, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum>()
		{
			{ avm.systemc.SystemCDataTypeEnum.@bool, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum.@bool },
			{ avm.systemc.SystemCDataTypeEnum.sc_bit, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum.sc_bit },
			{ avm.systemc.SystemCDataTypeEnum.sc_int, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum.sc_int },
			{ avm.systemc.SystemCDataTypeEnum.sc_logic, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum.sc_logic },
			{ avm.systemc.SystemCDataTypeEnum.sc_uint, CyPhyMLClasses.SystemCPort.AttributesClass.DataType_enum.sc_uint }
		};

        private Dictionary<avm.systemc.DirectionalityEnum, CyPhyMLClasses.SystemCPort.AttributesClass.Directionality_enum> d_SystemCPort_Directionality
            = new Dictionary<avm.systemc.DirectionalityEnum, CyPhyMLClasses.SystemCPort.AttributesClass.Directionality_enum>()
		{
			{ avm.systemc.DirectionalityEnum.@in, CyPhyMLClasses.SystemCPort.AttributesClass.Directionality_enum.@in },
			{ avm.systemc.DirectionalityEnum.inout, CyPhyMLClasses.SystemCPort.AttributesClass.Directionality_enum.inout },
			{ avm.systemc.DirectionalityEnum.not_applicable, CyPhyMLClasses.SystemCPort.AttributesClass.Directionality_enum.not_applicable },
			{ avm.systemc.DirectionalityEnum.@out, CyPhyMLClasses.SystemCPort.AttributesClass.Directionality_enum.@out }
		};

        private Dictionary<avm.systemc.FunctionEnum, CyPhyMLClasses.SystemCPort.AttributesClass.Function_enum> d_SystemCPort_Function
            = new Dictionary<avm.systemc.FunctionEnum, CyPhyMLClasses.SystemCPort.AttributesClass.Function_enum>()
		{
			{ avm.systemc.FunctionEnum.clock, CyPhyMLClasses.SystemCPort.AttributesClass.Function_enum.clock },
			{ avm.systemc.FunctionEnum.normal, CyPhyMLClasses.SystemCPort.AttributesClass.Function_enum.normal },
			{ avm.systemc.FunctionEnum.reset_async, CyPhyMLClasses.SystemCPort.AttributesClass.Function_enum.reset_async },
			{ avm.systemc.FunctionEnum.reset_sync, CyPhyMLClasses.SystemCPort.AttributesClass.Function_enum.reset_sync }
		};
        #endregion


		public enum MessageType { OUT, ERROR, WARNING, INFO };

		public object messageConsole {
			get {
				return _messageConsole;
			}
			set {
				_messageConsole = value;
			}
		}

		public void writeMessage( string message, MessageType messageType = MessageType.OUT ) {

			if ( messageConsole == null ) return;


			if ( messageConsole is GMEConsole ) {
				GMEConsole gmeConsole = messageConsole as GMEConsole;
				TextWriter textWriter = null;
				switch( messageType ) {
					case MessageType.INFO:
						textWriter = gmeConsole.Info;
						break;
					case MessageType.WARNING:
						textWriter = gmeConsole.Warning;
						break;
					case MessageType.ERROR:
						textWriter = gmeConsole.Error;
						break;
					default:
					case MessageType.OUT:
						textWriter = gmeConsole.Out;
						break;
				}
				textWriter.WriteLine( message );
			} 
			else if ( messageConsole is Console ) {
				TextWriter textWriter = null;
				switch( messageType ) {
					case MessageType.INFO:
					case MessageType.WARNING:
					case MessageType.ERROR:
						textWriter = Console.Error;
						break;
					default:
					case MessageType.OUT:
						textWriter = Console.Out;
						break;
				}
				textWriter.WriteLine( message );
			}
			else if (messageConsole is CyPhyGUIs.GMELogger)
			{
				var logger = messageConsole as CyPhyGUIs.GMELogger;
				switch (messageType)
				{
					case MessageType.WARNING:
						logger.WriteWarning(message);
						break;
					case MessageType.ERROR:
						logger.WriteError(message);
						break;
					case MessageType.INFO:
					case MessageType.OUT:
					default:
						logger.WriteInfo(message);
						break;
				}
			}
		}

        public static bool SetLayoutData(object avmObj, IMgaObject cyphyObj)
        {
            if (cyphyObj is IMgaFCO)
            {
                var cyphyFCO = cyphyObj as IMgaFCO;
                if (cyphyFCO.ParentModel == null)
                {
                    return false;
                }
                var objWrapper = new LayoutDataWrapper(avmObj);

                if (objWrapper.hasLayoutData)
                {
                    // Look for all aspects, and set our layout data.
                    foreach (IMgaPart part in cyphyFCO.Parts)
                    {
                        part.SetGmeAttrs(null,
                            System.Convert.ToInt32(Math.Min(objWrapper.xpos, (UInt32)Int32.MaxValue)),
                            System.Convert.ToInt32(Math.Min(objWrapper.ypos, (UInt32)Int32.MaxValue)));

                    }
                    return true;
                }
            }
            return false;
        }

        protected void registerPort(avm.PortMapTarget avmPort) {
            _avmPortSet.Add(avmPort);
            if (avmPort.ID != null)
            {
                try
                {
                    _avmPortIDMap.Add(avmPort.ID, avmPort);
                }
                catch (System.ArgumentException)
                {
                    throw new ApplicationException(String.Format("Error in component model: duplicate ID '{0}'", avmPort.ID));
                }
            }
        }

        protected void registerValueNode( avm.ValueNode avmValueNode, object owner ) {
            var keyValuePair = new KeyValuePair<ValueNode, object>(avmValueNode, owner);
            if (false == _avmValueNodeSet.Contains(keyValuePair))
                _avmValueNodeSet.Add(keyValuePair);

            if (String.IsNullOrWhiteSpace(avmValueNode.ID) == false
                && false == _avmValueNodeIDMap.ContainsKey(avmValueNode.ID))
            {
                _avmValueNodeIDMap.Add(avmValueNode.ID, keyValuePair);            
            }
        }


		private class CreateMethodProxyAux<Class> where Class : class {

			private MethodInfo _createMethodInfo;
			private Object _roleStrDefaultValue;

			public CreateMethodProxyAux( Type parentClass ) {

				Type classType = typeof( Class );

				MethodInfo[] methodInfoArray = classType.GetMethods( BindingFlags.Static | BindingFlags.Public );

				bool termLoop = false;
				foreach( MethodInfo methodInfo in methodInfoArray ) {
					if( methodInfo.Name == "Create" ) {
						ParameterInfo[] parameterInfoArray = methodInfo.GetParameters();
						foreach( ParameterInfo parameterInfo in parameterInfoArray ) {
							if( parameterInfo.ParameterType.Equals( parentClass ) ) {
								_createMethodInfo = methodInfo;
								termLoop = true;
								break;
							}
						}
						if( termLoop ) break;
					}
				}

				foreach( ParameterInfo parameterInfo in _createMethodInfo.GetParameters() ) {
					if( parameterInfo.Name == "roleStr" ) {
						_roleStrDefaultValue = parameterInfo.DefaultValue;
						break;
					}
				}

			}

			public void call<BaseClass, ParentClass>( ParentClass parent, out BaseClass baseClassObject ) where BaseClass : class {
				baseClassObject = _createMethodInfo.Invoke( null, new object[] { parent, _roleStrDefaultValue } ) as BaseClass;
			}
		}

        protected interface CreateMethodProxyBase {
			void call<BaseClass, ParentClass>( ParentClass parent, out BaseClass baseClassObject ) where BaseClass : class;
			Type getClass();
        }

        protected class CreateMethodProxy<Class> : CreateMethodProxyBase where Class : class {

			private Dictionary< string, CreateMethodProxyAux< Class > > _parentClassCMPADictionary = new Dictionary< string, CreateMethodProxyAux< Class > >();

			protected CreateMethodProxy() { }

			private static CreateMethodProxy<Class> _singleton = new CreateMethodProxy<Class>();

			public static CreateMethodProxy<Class> get_singleton() {
				return _singleton;
			}

			public Type getClass() {
				return typeof( Class );
			}

			private CreateMethodProxyAux<Class> getCreateMethodProxyAux( Type parentClassType ) {
				string parentClassName = parentClassType.Name;
				if( _parentClassCMPADictionary.ContainsKey( parentClassName ) ) {
					return _parentClassCMPADictionary[ parentClassName ];
				}

				CreateMethodProxyAux<Class> createMethodProxyAux = new CreateMethodProxyAux<Class>( parentClassType );
				_parentClassCMPADictionary.Add( parentClassType.Name, createMethodProxyAux );
				return createMethodProxyAux;
			}

			public void call<BaseClass, ParentClass>( ParentClass parent, out BaseClass baseClassObject ) where BaseClass : class {
				getCreateMethodProxyAux( typeof( ParentClass ) ).call( parent, out baseClassObject );
			}
			
        }

        protected class ConnectProxy {
			private MethodInfo _connectMethodInfo;
			private object[] _argArray;

			public ConnectProxy(MethodInfo connectMethodInfo, object[] argArray) {
				_connectMethodInfo = connectMethodInfo;
				_argArray = argArray;

			}

			public object connect(Object srcObject, Object dstObject) {
				_argArray[0] = srcObject;
				_argArray[1] = dstObject;
				return _connectMethodInfo.Invoke(null, _argArray);
			}

			public Type declaringType {
				get { return _connectMethodInfo.DeclaringType; }
			}
        }
		public void setUnitMap(Dictionary<String, CyPhyML.unit> unitSymbolCyPhyMLUnitMap)
		{
			_unitSymbolCyPhyMLUnitMap = unitSymbolCyPhyMLUnitMap;
		}
		public Dictionary<String, CyPhyML.unit> getUnitMap()
		{
			return _unitSymbolCyPhyMLUnitMap;
		}

		private void getCyPhyMLUnits( CyPhyML.RootFolder rootFolder ) 
        {
			foreach( CyPhyML.TypeSpecifications typeSpecifications in rootFolder.Children.TypeSpecificationsCollection ) 
            {
				foreach( CyPhyML.Units units in typeSpecifications.Children.UnitsCollection ) 
                {
					_cyPhyMLUnitsFolders.Add(units);
                }
            }
        }

        protected PropertyInfo getPropertyInfo(Type type, string propertyName)
        {
            return type.GetProperty(propertyName);
        }

        protected PropertyInfo getPropertyInfo(object object_var, string propertyName)
        {
            return getPropertyInfo(object_var.GetType(), propertyName);
        }

        protected Type getInterfaceType(Type type)
        {
            string typeName = type.UnderlyingSystemType.AssemblyQualifiedName.Replace(".Classes.", ".Interfaces.");
            return Type.GetType(typeName);
        }

        protected Type getInterfaceType(object object_var)
        {
            return getInterfaceType(object_var.GetType());
        }


        protected void getCyPhyMLUnits() {
            _cyPhyMLUnitsFolders = new List<CyPhyML.Units>();

            // Collect all of the Root Folders in the project.
            // They will be sorted, with the QUDT lib in front, followed by all other libs, then the user's Root Folder.
            var cyPhyMLRootFolderList = new List<CyPhyML.RootFolder>();
            cyPhyMLRootFolderList.AddRange(_cyPhyMLRootFolder.LibraryCollection
                                                             .OrderByDescending(lc => lc.Name.Equals("UnitLibrary QUDT")));                                                
            cyPhyMLRootFolderList.Add(_cyPhyMLRootFolder);

            // Now, for each Root Folder that we gathered, go through and find all units, and add them to our master index.
            if( cyPhyMLRootFolderList.Count > 0 )
            {
                cyPhyMLRootFolderList.ForEach(lrf => getCyPhyMLUnits( lrf ));
            }
        }

        private static bool isUnitless( CyPhyML.unit cyPhyMLUnit ) {

            if( cyPhyMLUnit is CyPhyML.si_unit ) {
                CyPhyML.si_unit si_unit_var = cyPhyMLUnit as CyPhyML.si_unit;
                return
                    si_unit_var.Attributes.amount_of_substance_exponent == 0 &&
                    si_unit_var.Attributes.electric_current_exponent == 0 &&
                    si_unit_var.Attributes.length_exponent == 0 &&
                    si_unit_var.Attributes.luminous_intensity_exponent == 0 &&
                    si_unit_var.Attributes.mass_exponent == 0 &&
                    si_unit_var.Attributes.thermodynamic_temperature_exponent == 0 &&
                    si_unit_var.Attributes.time_exponent == 0;
            }

            if( cyPhyMLUnit is CyPhyML.derived_unit ) {
                CyPhyML.derived_unit derived_unit_var = cyPhyMLUnit as CyPhyML.derived_unit;
                List< CyPhyML.derived_unit_element > derived_unit_elementList = derived_unit_var.Children.derived_unit_elementCollection.ToList< CyPhyML.derived_unit_element >();
                return derived_unit_elementList.Count == 1 ? isUnitless( derived_unit_elementList.ElementAt( 0 ).Referred.named_unit ) : false;
            }

            CyPhyML.conversion_based_unit cyPhyMLconversion_based_unit = cyPhyMLUnit as CyPhyML.conversion_based_unit;
            List<CyPhyML.reference_unit> reference_unitList = cyPhyMLconversion_based_unit.Children.reference_unitCollection.ToList<CyPhyML.reference_unit>();
            if( reference_unitList.Count() == 0 ) return false;

            CyPhyML.reference_unit cyPhyMLreference_unit = reference_unitList.ElementAt( 0 );
            return reference_unitList.Count == 1 ? isUnitless( cyPhyMLreference_unit.Referred.unit ) : false;
        }

        protected void getCyPhyMLNamedUnits( bool resetUnitLibrary = false ) {
            if( false == _cyPhyMLUnitsFolders.Any() ) return;
			
            // If the caller has passed in this map already
            if (resetUnitLibrary) _unitSymbolCyPhyMLUnitMap.Clear();
            if (_unitSymbolCyPhyMLUnitMap.Count > 0) return;

            foreach( CyPhyML.unit cyPhyMLUnit in _cyPhyMLUnitsFolders.SelectMany(uf => uf.Children.unitCollection) ) {
                // Angle-type measures are an exception to this rule.
                /*
				if (cyPhyMLUnit.Attributes.Abbreviation != "rad" &&
					cyPhyMLUnit.Attributes.Abbreviation != "deg" &&
					isUnitless(cyPhyMLUnit))
				{
					continue;
				}*/

                if( !_unitSymbolCyPhyMLUnitMap.ContainsKey( cyPhyMLUnit.Attributes.Abbreviation ) ) {
                    _unitSymbolCyPhyMLUnitMap.Add( cyPhyMLUnit.Attributes.Abbreviation, cyPhyMLUnit );
                }
                if (  !_unitSymbolCyPhyMLUnitMap.ContainsKey( cyPhyMLUnit.Attributes.Symbol )  ) {
                    _unitSymbolCyPhyMLUnitMap.Add( cyPhyMLUnit.Attributes.Symbol, cyPhyMLUnit );
                }
                if (  !_unitSymbolCyPhyMLUnitMap.ContainsKey( cyPhyMLUnit.Attributes.FullName )  ) {
                    _unitSymbolCyPhyMLUnitMap.Add( cyPhyMLUnit.Attributes.FullName, cyPhyMLUnit );
                }
            }
        }


		private void getCyPhyMLPorts(CyPhyML.RootFolder rootFolder) {
			foreach (CyPhyML.Connectors cyPhyMLConnectors in rootFolder.Children.ConnectorsCollection) {
				foreach (CyPhyML.Ports ports in cyPhyMLConnectors.Children.PortsCollection) {
					_cyPhyMLPorts = ports;
					break;
				}
				if (_cyPhyMLPorts != null) break;
			}
		}

        protected void getCyPhyMLPorts() {
            _cyPhyMLPorts = null;

            List<CyPhyML.RootFolder> cyPhyMLRootFolderList = _cyPhyMLRootFolder.LibraryCollection.ToList<CyPhyML.RootFolder>();
            if (cyPhyMLRootFolderList.Count > 0) {
                foreach (CyPhyML.RootFolder libraryRootFolder in _cyPhyMLRootFolder.LibraryCollection) {
                    getCyPhyMLPorts(libraryRootFolder);
                    if (_cyPhyMLPorts != null) break;
                }
            }

            if (_cyPhyMLPorts == null) {
                getCyPhyMLPorts(_cyPhyMLRootFolder);
            }
        }

		private void getCyPhyMLModelPorts( CyPhyML.Ports cyPhyMLPorts ) {

			if (cyPhyMLPorts.Children.PortCollection.Count() != 0) {
				foreach( CyPhyML.Port cyPhyMLPort in cyPhyMLPorts.Children.PortCollection ) {
					PropertyInfo attributesPropertyInfo = getPropertyInfo( getInterfaceType(cyPhyMLPort), "Attributes");
					PropertyInfo classPropertyInfo = attributesPropertyInfo != null ? attributesPropertyInfo.PropertyType.GetProperty("Class") : null;

					string key = cyPhyMLPort.Name;

					if (classPropertyInfo != null) {
						object bar = classPropertyInfo.GetValue(attributesPropertyInfo.GetValue(cyPhyMLPort, null), null);
						key = classPropertyInfo.GetValue(attributesPropertyInfo.GetValue(cyPhyMLPort, null), null) as string;
					}
					_portNameTypeMap.Add(key, cyPhyMLPort);
				}
			}

			foreach (CyPhyML.Ports cyPhyMLChildPorts in cyPhyMLPorts.Children.PortsCollection) {
				getCyPhyMLModelPorts(cyPhyMLChildPorts);
			}
		}

        protected void getCyPhyMLModelPorts(bool resetPorts = false) {
            if (_cyPhyMLPorts == null) return;

            // If the caller has passed in this map already
            if (resetPorts) _portNameTypeMap.Clear();
            if (_portNameTypeMap.Count > 0) return;

            getCyPhyMLModelPorts(_cyPhyMLPorts );
        }

        protected void process<T>( T parent, avm.Property avmProperty, string compoundPropertyPath = "" ) {

			if (avmProperty is avm.CompoundProperty) {
				avm.CompoundProperty avmCompoundProperty = avmProperty as avm.CompoundProperty;
                
				if (string.IsNullOrEmpty(compoundPropertyPath))
					compoundPropertyPath = avmProperty.Name;
				else
					compoundPropertyPath = String.Format("{0}__{1}", compoundPropertyPath, avmProperty.Name);


				foreach (CompoundProperty childAVMProperty in avmCompoundProperty.CompoundProperty1) {
					process(parent, childAVMProperty, compoundPropertyPath);
				}
				foreach (PrimitiveProperty childAVMProperty in avmCompoundProperty.PrimitiveProperty) {
					process(parent, childAVMProperty, compoundPropertyPath);
				}
				return;
			}


			avm.PrimitiveProperty avmPrimitiveProperty = avmProperty as avm.PrimitiveProperty;
			avm.Value avmValue = avmPrimitiveProperty.Value;

			registerValueNode(avmValue, avmPrimitiveProperty);
			

			CyPhyML.unit cyPhyMLUnit = null;
			if (!String.IsNullOrWhiteSpace(avmValue.Unit))
			{
				if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmValue.Unit)) {
					cyPhyMLUnit = _unitSymbolCyPhyMLUnitMap[avmValue.Unit];
				} else {
					writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmValue.Unit), MessageType.WARNING);
				}
			}

			avm.ValueExpressionType avmValueExpressionType = avmValue.ValueExpression;
			if (avmValueExpressionType is avm.ParametricValue) {
				var avmParametricValue = avmValueExpressionType as avm.ParametricValue;

				CyPhyML.Parameter cyPhyMLParameter = null;
				CreateMethodProxy<CyPhyMLClasses.Parameter>.get_singleton().call(parent, out cyPhyMLParameter);
                
				_avmCyPhyMLObjectMap.Add(avmProperty, cyPhyMLParameter);

				cyPhyMLParameter.Name = (string.IsNullOrEmpty(compoundPropertyPath))?avmPrimitiveProperty.Name:String.Format("{0}__{1}",compoundPropertyPath,avmPrimitiveProperty.Name);

				cyPhyMLParameter.Attributes.ID = avmValue.ID;
				cyPhyMLParameter.Attributes.DataType = _dataTypeParameterEnumMap[avmValue.DataType];
				cyPhyMLParameter.Attributes.Dimension = avmValue.Dimensions;
				cyPhyMLParameter.Referred.unit = cyPhyMLUnit;


				// Set Default value (required)
				var def = avmParametricValue.Default;
				if (def is avm.FixedValue)
				{
					var def_FV = def as avm.FixedValue;
					cyPhyMLParameter.Attributes.DefaultValue = def_FV.Value;
				}


				// Set min and max, and default either end to inf if not provided
				var min = avmParametricValue.Minimum;
				var max = avmParametricValue.Maximum;
                bool rangeSet = false;
                string sMin = "-inf";
                string sMax = "inf";
                if (min is avm.FixedValue)
                {
                    var min_FV = min as avm.FixedValue;
                    if (!String.IsNullOrWhiteSpace(min_FV.Value))
                    {
                        sMin = min_FV.Value;
                        rangeSet = true;
                    }
                }
                if (max is avm.FixedValue)
                {
                    var max_FV = max as avm.FixedValue;
                    if (!String.IsNullOrWhiteSpace(max_FV.Value))
                    {
                        sMax = max_FV.Value;
                        rangeSet = true;
                    }
                }
                //-inf..inf
                if (rangeSet)
                {
                    cyPhyMLParameter.Attributes.Range = String.Format("{0}..{1}", sMin, sMax);
                }

                // If no AssignedValue is provided, use the DefaultValue
                if (avmParametricValue.AssignedValue is avm.FixedValue)
                {
                    var av_FV = avmParametricValue.AssignedValue as avm.FixedValue;
                    cyPhyMLParameter.Attributes.Value = av_FV.Value;
                }
                else
                {
                    cyPhyMLParameter.Attributes.Value = cyPhyMLParameter.Attributes.DefaultValue;
                }
                //registerValueNode(avmParametricValue
            } else {

                CyPhyML.Property cyPhyMLProperty = null;
                CreateMethodProxy<CyPhyMLClasses.Property>.get_singleton().call(parent, out cyPhyMLProperty);
                
                _avmCyPhyMLObjectMap.Add(avmProperty, cyPhyMLProperty);

                cyPhyMLProperty.Name = (string.IsNullOrEmpty(compoundPropertyPath)) ? avmPrimitiveProperty.Name : String.Format("{0}__{1}", compoundPropertyPath, avmPrimitiveProperty.Name);

                cyPhyMLProperty.Attributes.ID = avmValue.ID;
                cyPhyMLProperty.Attributes.DataType = _dataTypePropertyEnumMap[avmValue.DataType];
                //            cyPhyMLProperty.Attributes.Dimension = avmValue.DimensionType.ToString();
                cyPhyMLProperty.Attributes.Dimension = avmValue.Dimensions;
                if (avmProperty.OnDataSheetSpecified)
                    cyPhyMLProperty.Attributes.IsProminent = avmProperty.OnDataSheet;

                cyPhyMLProperty.Referred.unit = cyPhyMLUnit;
            }

        }

        protected void process(SimpleFormula avmSimpleFormula, CyPhyML.SimpleFormula cyphySimpleFormula)
        {
            cyphySimpleFormula.Attributes.Method = sfOperatorMap[avmSimpleFormula.Operation];
            cyphySimpleFormula.Attributes.ID = avmSimpleFormula.ID;
            cyphySimpleFormula.Name = avmSimpleFormula.Name;
            registerValueNode(avmSimpleFormula, avmSimpleFormula);

            _avmCyPhyMLObjectMap.Add(avmSimpleFormula, cyphySimpleFormula);
        }

        protected void buildCyPhyMLNameConnectionMap() {

            if (_cyPhyMLConnectionMap.Count > 0) return;

            foreach (MgaMetaFCO connection in project.RootMeta.RootFolder.DefinedFCOs.Cast<GME.MGA.Meta.MgaMetaFCO>().Where(x => x.ObjType == GME.MGA.Meta.objtype_enum.OBJTYPE_CONNECTION).ToList()) {
				
                // Special exception for non-nominal connection
                if (connection.Name == "SurfaceReverseMap")
                    continue;

                string[] separators = new string[1] { "::" };
                string[] connectionNameComponents = connection.Name.Split( separators, StringSplitOptions.None );

                string assemblyQualifiedName =
                    "ISIS.GME.Dsml.CyPhyML." 
                    + String.Join( ".", connectionNameComponents, 0, connectionNameComponents.Length - 1 ) 
                    + ( connectionNameComponents.Length == 1 ? "" : "." ) 
                    + "Classes." 
                    + connectionNameComponents[ connectionNameComponents.Length - 1 ];

                //Type classType = Type.GetType( assemblyQualifiedName );
                Type classType =
                    typeof(ISIS.GME.Dsml.CyPhyML.Classes.Component).Assembly.GetType(assemblyQualifiedName);
				
                if (classType == null) {
                    //Console.Out.WriteLine("WARNING: Unable to acquire class \"" + assemblyQualifiedName + "\"");
                    continue;
                }

                MethodInfo[] methodInfoArray = classType.GetMethods(BindingFlags.Static | BindingFlags.Public);
                List< MethodInfo > connectMethodInfoArray = new List< MethodInfo >();

                foreach (MethodInfo methodInfo in methodInfoArray) {
                    if (methodInfo.Name != "Connect") continue;
					
                    ParameterInfo[] parameterInfoArray = methodInfo.GetParameters();
                    if ( parameterInfoArray.Count() >= 5 && !parameterInfoArray[4].ParameterType.IsAssignableFrom( typeof( CyPhyML.Component ) ) ) continue;

                    connectMethodInfoArray.Add(methodInfo);
                }

                foreach (MethodInfo methodInfo in connectMethodInfoArray) {

                    MethodInfo connectMethodInfo = methodInfo;
                    object[] argArray = new Object[connectMethodInfo.GetParameters().Count()];
                    Type[] typeArray = new Type[2];

                    foreach (ParameterInfo parameterInfo in connectMethodInfo.GetParameters()) {
                        if (parameterInfo.IsOptional) argArray[parameterInfo.Position] = parameterInfo.DefaultValue;
                        else typeArray[parameterInfo.Position] = parameterInfo.ParameterType;
                    }

                    if (connectMethodInfoArray.Count > 1 && typeArray[0].Equals(typeArray[1])) continue;

                    TypePair typePair = new TypePair(typeArray[0], typeArray[1]);
                    if (_cyPhyMLConnectionMap.ContainsKey(typePair) ) {
                        if (!_cyPhyMLConnectionMap[typePair].declaringType.Equals(classType)) {
                            //Console.Out.WriteLine("WARNING:  More than one connection type for types \"" + TypePairCompare.getTypeName(typePair.Key) + "\" and \"" + TypePairCompare.getTypeName(typePair.Value) + "\"");
                            //Console.Out.WriteLine("\t\"" + TypePairCompare.getTypeName(_cyPhyMLConnectionMap[typePair].declaringType) + "\" connection type being used rather than \"" + TypePairCompare.getTypeName(classType) + "\" connection type.");
                        }
                    } else {
                        _cyPhyMLConnectionMap.Add(typePair, new ConnectProxy(connectMethodInfo, argArray));
                    }
                }
            }
        }

        private static Dictionary<string, Func<IMgaObject, ISIS.GME.Common.Interfaces.Base>> dsmlCasts = new Dictionary<string, Func<IMgaObject, ISIS.GME.Common.Interfaces.Base>>()
        {
            {typeof(CyPhyMLClasses.ValueFlow).Name, CyPhyMLClasses.ValueFlow.Cast},
            {typeof(CyPhyMLClasses.ModelicaParameterPortMap).Name, CyPhyMLClasses.ModelicaParameterPortMap.Cast},
            {typeof(CyPhyMLClasses.ConnectorComposition).Name, CyPhyMLClasses.ConnectorComposition.Cast},
            {typeof(CyPhyMLClasses.CADMetricPortMap).Name, CyPhyMLClasses.CADMetricPortMap.Cast},
            {typeof(CyPhyMLClasses.CADParameterPortMap).Name, CyPhyMLClasses.CADParameterPortMap.Cast},
            {typeof(CyPhyMLClasses.ManufacturingParameterPortMap).Name, CyPhyMLClasses.ManufacturingParameterPortMap.Cast},
            {typeof(CyPhyMLClasses.PortComposition).Name, CyPhyMLClasses.PortComposition.Cast},
            {typeof(CyPhyMLClasses.SystemCParameterPortMap).Name, CyPhyMLClasses.SystemCParameterPortMap.Cast},
            {typeof(CyPhyMLClasses.SPICEModelParameterMap).Name, CyPhyMLClasses.SPICEModelParameterMap.Cast},
            {typeof(CyPhyMLClasses.EDAModelParameterMap).Name, CyPhyMLClasses.EDAModelParameterMap.Cast},
            // TODO more kinds
        };

        private Dictionary<avm.modelica.RedeclareTypeEnum, CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum> _modelicaRedeclareTypeEnumMap =
            new Dictionary<avm.modelica.RedeclareTypeEnum, CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum>() {
                { avm.modelica.RedeclareTypeEnum.Block,     CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Block },
                { avm.modelica.RedeclareTypeEnum.Class,     CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Class },
                { avm.modelica.RedeclareTypeEnum.Connector, CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Connector },
                { avm.modelica.RedeclareTypeEnum.Function,  CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Function },
                { avm.modelica.RedeclareTypeEnum.Model,     CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Model },
                { avm.modelica.RedeclareTypeEnum.Package,   CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Package },
                { avm.modelica.RedeclareTypeEnum.Record,    CyPhyMLClasses.ModelicaRedeclare.AttributesClass.ModelicaRedeclareType_enum.Record }
            };

        protected object makeConnection(object cyPhyMLObjectSrc, object cyPhyMLObjectDst, string kind=null, bool createAsPortConnection=false) {
            if (kind != null)
            {
                IMgaFCO src = GetFCOObject(cyPhyMLObjectSrc);
                IMgaReference srcReference = GetFCOObjectReference(cyPhyMLObjectSrc);
                IMgaFCO dst = GetFCOObject(cyPhyMLObjectDst);
                IMgaReference dstReference = GetFCOObjectReference(cyPhyMLObjectDst);

                IMgaModel srcparent = (srcReference != null ? srcReference : src).ParentModel;
                IMgaModel dstparent = (dstReference != null ? dstReference : dst).ParentModel;
                IMgaModel parent = srcparent;
                if (srcparent != dstparent) // src or dst is a port
                {
                    if (srcparent == dstparent.ParentModel)
                    {
                        parent = srcparent;
                    }
                    else if (srcparent.ParentModel == dstparent.ParentModel)
                    {
                        parent = dstparent.ParentModel;
                    }
                    else if (dstparent == srcparent.ParentModel)
                    {
                        parent = dstparent;
                    }
                }
                else if (createAsPortConnection)
                {
                    parent = srcparent.ParentModel;
                }
                
                var role = (MgaMetaRole)((MgaMetaModel)parent.Meta).RoleByName[kind];
                var conn = parent.CreateSimpleConnDisp(role, (MgaFCO)src, (MgaFCO)dst, (MgaFCO)srcReference, (MgaFCO)dstReference);

                return dsmlCasts[kind](conn);
            }

			string cyPhyMLObjectSrcTypeName = cyPhyMLObjectSrc.GetType().UnderlyingSystemType.AssemblyQualifiedName.Replace(".Classes.", ".Interfaces.");
			string cyPhyMLObjectDstTypeName = cyPhyMLObjectDst.GetType().UnderlyingSystemType.AssemblyQualifiedName.Replace(".Classes.", ".Interfaces.");

			Type cyPhyMLObjectSrcType = Type.GetType(cyPhyMLObjectSrcTypeName);
			Type cyPhyMLObjectDstType = Type.GetType(cyPhyMLObjectDstTypeName);


			if (_cyPhyMLConnectionMap.Count == 0) buildCyPhyMLNameConnectionMap();
			TypePair typePair = new TypePair(cyPhyMLObjectSrcType, cyPhyMLObjectDstType);
			TypePair reverseTypePair = new TypePair(cyPhyMLObjectDstType, cyPhyMLObjectSrcType);


			object connection = null;
			if (_cyPhyMLConnectionMap.ContainsKey(typePair)) {

				ConnectProxy connectProxy = _cyPhyMLConnectionMap[typePair];
				connection = connectProxy.connect(cyPhyMLObjectSrc, cyPhyMLObjectDst);

			} else if (_cyPhyMLConnectionMap.ContainsKey(reverseTypePair)) {

				ConnectProxy connectProxy = _cyPhyMLConnectionMap[reverseTypePair];

				object temp = cyPhyMLObjectSrc;
				cyPhyMLObjectSrc = cyPhyMLObjectDst;
				cyPhyMLObjectDst = temp;

				connection = connectProxy.connect(cyPhyMLObjectSrc, cyPhyMLObjectDst);

			} else {
				TypePair baseTypePair = new TypePair(typeof(object), typeof(object));
				TypePair reverseBaseTypePair = new TypePair(typeof(object), typeof(object));
				foreach (TypePair compareTypePair in _cyPhyMLConnectionMap.Keys) {
					if (TypePairCompare.isPairSubclassOf(typePair, compareTypePair) && TypePairCompare.isPairSubclassOf(compareTypePair, baseTypePair)) baseTypePair = compareTypePair;
					if (TypePairCompare.isPairSubclassOf(reverseTypePair, compareTypePair) && TypePairCompare.isPairSubclassOf(compareTypePair, reverseBaseTypePair)) reverseBaseTypePair = compareTypePair;
				}

				if (baseTypePair.Key == typeof(object)) {
					if (reverseBaseTypePair.Key == typeof(object)) {
						String sOutput = String.Format("WARNING: cannot create specific connection from \"{0}\" to \"{1}\".", //  CREATING GENERIC ASSOCIATION INSTEAD.",
						    TypePairCompare.getTypeName(cyPhyMLObjectSrc.GetType()), TypePairCompare.getTypeName(cyPhyMLObjectDst.GetType()));
						writeMessage(sOutput, MessageType.WARNING);
                                        } else {
						ConnectProxy connectProxy = _cyPhyMLConnectionMap[reverseTypePair] = _cyPhyMLConnectionMap[reverseBaseTypePair];
						connection = connectProxy.connect(cyPhyMLObjectDst, cyPhyMLObjectSrc);
					}
				} else {
					ConnectProxy connectProxy = _cyPhyMLConnectionMap[typePair] = _cyPhyMLConnectionMap[baseTypePair];
					connection = connectProxy.connect(cyPhyMLObjectSrc, cyPhyMLObjectDst);
					if (reverseBaseTypePair.Key != typeof(object)) {
						_cyPhyMLConnectionMap[reverseTypePair] = _cyPhyMLConnectionMap[reverseBaseTypePair];
					}

				}
			}

			return connection;
		}

        private static IMgaFCO GetFCOObject(object cyPhyMLObjectSrc)
        {
            IMgaFCO source;
            if (cyPhyMLObjectSrc is ISIS.GME.Common.Interfaces.FCO)
            {
                source = (IMgaFCO)((ISIS.GME.Common.Interfaces.FCO)cyPhyMLObjectSrc).Impl;
            }
            else
            {
                source = (IMgaFCO)((KeyValuePair<ISIS.GME.Common.Interfaces.Reference, ISIS.GME.Common.Interfaces.FCO>)cyPhyMLObjectSrc).Value.Impl;
            }

            return source;
        }
        private static IMgaReference GetFCOObjectReference(object cyPhyMLObjectSrc)
        {
            IMgaReference source_rp;
            if (cyPhyMLObjectSrc is ISIS.GME.Common.Interfaces.FCO)
            {
                source_rp = null;
            }
            else
            {
                source_rp = (IMgaReference)((KeyValuePair<ISIS.GME.Common.Interfaces.Reference, ISIS.GME.Common.Interfaces.FCO>)cyPhyMLObjectSrc).Key.Impl;
            }

            return source_rp;
        }

        protected void processValues() {

			foreach (var avmSimpleFormulaWithOwner in _avmValueNodeSet.Where(t => t.Key is avm.SimpleFormula))
			{
				var avmSimpleFormula = avmSimpleFormulaWithOwner.Key as avm.SimpleFormula;
				var cyPhyMLSimpleFormula = _avmCyPhyMLObjectMap[avmSimpleFormula];

				foreach (var operandID in avmSimpleFormula.Operand)
				{
					// Look up other AVM Value & its AVM Owner by ID.
					KeyValuePair<avm.ValueNode, object> avmSourceValueNodeWithOwner;
					if (_avmValueNodeIDMap.TryGetValue(operandID, out avmSourceValueNodeWithOwner))
					{
						var avmSourceValueNodeOwner = avmSourceValueNodeWithOwner.Value;

						// Find the CyPhy object corresponding with that AVM Value's Owner
						object cyPhyMLSourceObject;
						if (_avmCyPhyMLObjectMap.TryGetValue(avmSourceValueNodeOwner, out cyPhyMLSourceObject))
						{
                            makeConnection(cyPhyMLSourceObject, cyPhyMLSimpleFormula, typeof(CyPhyML.ValueFlow).Name);
						}
					}
				}
			}

			foreach (var avmComplexFormulaWithOwner in _avmValueNodeSet.Where(t => t.Key is avm.ComplexFormula))
			{
				var avmComplexFormula = avmComplexFormulaWithOwner.Key as avm.ComplexFormula;
				var cyPhyMLCustomFormula = _avmCyPhyMLObjectMap[avmComplexFormula];

				foreach (var operand in avmComplexFormula.Operand)
				{
					// Get the source operand & its owner by ID
					KeyValuePair<avm.ValueNode, object> avmSourceValueNodeWithOwner;
					if (_avmValueNodeIDMap.TryGetValue(operand.ValueSource, out avmSourceValueNodeWithOwner))
					{
						var avmSourceValueNodeOwner = avmSourceValueNodeWithOwner.Value;

						// Find the CyPhy object corresponding with that AVM Value's Ownder
						object cyPhyMLSourceObject;
						if (_avmCyPhyMLObjectMap.TryGetValue(avmSourceValueNodeOwner, out cyPhyMLSourceObject))
						{
                            CyPhyML.ValueFlow valueFlow = makeConnection(cyPhyMLSourceObject, cyPhyMLCustomFormula, typeof(CyPhyML.ValueFlow).Name) as CyPhyML.ValueFlow;

							var cyPhyMLSourceObject_ValueFlowTarget = cyPhyMLSourceObject as CyPhyML.ValueFlowTarget;
                            if (cyPhyMLSourceObject_ValueFlowTarget == null)
                            {
                                cyPhyMLSourceObject_ValueFlowTarget = ((KeyValuePair<ISIS.GME.Common.Interfaces.Reference, ISIS.GME.Common.Interfaces.FCO>)cyPhyMLSourceObject).Value as CyPhyML.ValueFlowTarget;
                            }
							if (cyPhyMLSourceObject is CyPhyML.ValueFormula)
							{
								// Set symbol
								valueFlow.Attributes.FormulaVariableName = operand.Symbol;
							}
							else if (operand.Symbol == cyPhyMLSourceObject_ValueFlowTarget.Name)
							{
								// The source object has the same name as the symbol.
								// No need to set an override here.
							}
							else
							{
								// Override symbol
								valueFlow.Attributes.FormulaVariableName = operand.Symbol;
							}
						}
					}
					
				}
			}

			foreach (var avmValueNodeWithOwner in _avmValueNodeSet.Where(t => t.Key is avm.Value))
			{
				var avmValue = avmValueNodeWithOwner.Key as avm.Value;
				object avmValueOwner = avmValueNodeWithOwner.Value;
				avm.ValueExpressionType avmValueExpression = avmValue.ValueExpression;

				if (avmValueExpression is avm.FixedValue)
				{
					object cyPhyMLParentObject = null;
					if (!_avmCyPhyMLObjectMap.TryGetValue(avmValueOwner, out cyPhyMLParentObject)) continue;

					string objectTypeName = cyPhyMLParentObject.GetType().UnderlyingSystemType.AssemblyQualifiedName.Replace(".Classes.", ".Interfaces.");
					Type objectType = Type.GetType(objectTypeName);

					PropertyInfo attributesPropertyInfo = getPropertyInfo(objectType, "Attributes");
					if (attributesPropertyInfo == null)
					{
						String sOutput = String.Format("WARNING: could not assign avm.FixedValue to cyPhyMLObject of type {0}", objectType.FullName);
						writeMessage(sOutput, MessageType.WARNING);
						continue;
					}
						
					PropertyInfo assignToProperty = getPropertyInfo(attributesPropertyInfo.PropertyType, "Value");
					if (assignToProperty == null)
					{
						String sOutput = String.Format("WARNING: could not assign avm.FixedValue to cyPhyMLObject of type {0}", objectType.FullName);
						writeMessage(sOutput, MessageType.WARNING);
						continue;
					}

					assignToProperty.SetValue(attributesPropertyInfo.GetValue(cyPhyMLParentObject, null), (avmValueExpression as avm.FixedValue).Value, null);
					continue;
				}
				else if (avmValueExpression is avm.ParametricValue)
				{
					var avmPV = avmValueExpression as avm.ParametricValue;

					object cyPhyMLParentObject = null;
					if (!_avmCyPhyMLObjectMap.TryGetValue(avmValueOwner, out cyPhyMLParentObject)) continue;

					// Get underlying CyPhy Interface class for the object that was created in CyPhy
					string objectTypeName = cyPhyMLParentObject.GetType().UnderlyingSystemType.AssemblyQualifiedName.Replace(".Classes.", ".Interfaces.");
					Type objectType = Type.GetType(objectTypeName);

					// Get this thing's attributes. If we can't, show an error and break.
					PropertyInfo attributesPropertyInfo = getPropertyInfo(objectType, "Attributes");
					if (attributesPropertyInfo == null)
					{
						String sOutput = String.Format("WARNING: could not assign avm.ParametricValue to cyPhyMLObject of type {0}", objectType.FullName);
						writeMessage(sOutput, MessageType.WARNING);
						continue;
					}

					/// First, get these two key properties. Then we'll figure out what to do based on what we get.
					PropertyInfo cyPhyAssignedValueAttribute = getPropertyInfo(attributesPropertyInfo.PropertyType, "Value");
					if (cyPhyAssignedValueAttribute == null)
					{
						String sOutput = String.Format("WARNING: could not assign AssignedValue of avm.ParametricValue to cyPhyMLObject of type {0}", objectType.FullName);
						writeMessage(sOutput, MessageType.WARNING);
						continue;
					}
					PropertyInfo cyphyDefaultValueAttribute = getPropertyInfo(attributesPropertyInfo.PropertyType, "DefaultValue");
					if (cyphyDefaultValueAttribute == null)
					{
						String sOutput = String.Format("WARNING: could not assign DefaultValue of avm.ParametricValue to cyPhyMLObject of type {0}", objectType.FullName);
						writeMessage(sOutput, MessageType.WARNING);
						continue;
					}

					///// If incoming model has AssignedValue, use it. /////
					if (avmPV.AssignedValue != null)
					{
						var av = avmPV.AssignedValue;
						if (av is avm.FixedValue)
						{
							var avFV = av as avm.FixedValue;
							cyPhyAssignedValueAttribute.SetValue(attributesPropertyInfo.GetValue(cyPhyMLParentObject, null), avFV.Value, null);
						}
                        else if (av is avm.DerivedValue)
                        {
                            KeyValuePair<ValueNode, object> avmOtherValueWithOwner;
                            if (_avmValueNodeIDMap.TryGetValue(((avm.DerivedValue)av).ValueSource, out avmOtherValueWithOwner))
                            {
                                object avmOtherValueOwner = avmOtherValueWithOwner.Value;

                                object cyPhyMLObjectSrc = null;
                                if (!_avmCyPhyMLObjectMap.TryGetValue(avmOtherValueOwner, out cyPhyMLObjectSrc))
                                    continue;

                                object cyPhyMLObjectDst = null;
                                var hasValueParent = _avmCyPhyMLObjectMap.TryGetValue(avmValueOwner, out cyPhyMLObjectDst);

                                makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.ValueFlow).Name);
					}
                        }
                    }

					///// If incoming model has DefaultValue, use it. /////
					if (avmPV.Default != null)
					{
						if (avmPV.Default is avm.FixedValue)
						{
							var avmDefaultVal = (avmPV.Default as avm.FixedValue).Value;
							cyphyDefaultValueAttribute.SetValue(attributesPropertyInfo.GetValue(cyPhyMLParentObject, null), avmDefaultVal, null);

							// If AssignedValue was null, let's use the default here
							if (avmPV.AssignedValue == null)
							{
								cyPhyAssignedValueAttribute.SetValue(attributesPropertyInfo.GetValue(cyPhyMLParentObject, null), avmDefaultVal, null);
							}
						}
						else
						{
							String sOutput = String.Format("WARNING: could not assign DefaultValue (using non-FixedValue) of avm.ParametricValue to cyPhyMLObject of type {0}", objectType.FullName);
							writeMessage(sOutput, MessageType.WARNING);
							continue;
						}
					}
				}
				else if (avmValueExpression is avm.DerivedValue)
				{
					string otherValueID = (avmValueExpression as avm.DerivedValue).ValueSource;

					object cyPhyMLObjectDst = null;
					var hasValueParent = _avmCyPhyMLObjectMap.TryGetValue(avmValueOwner, out cyPhyMLObjectDst);

                    if (hasValueParent && !(cyPhyMLObjectDst is KeyValuePair<ISIS.GME.Common.Interfaces.Reference, ISIS.GME.Common.Interfaces.FCO>))
					{
						var attributesPropertyInfo = getPropertyInfo(getInterfaceType(cyPhyMLObjectDst), "Attributes");
						var idProperty = getPropertyInfo(attributesPropertyInfo.PropertyType, "ID");
						var unitsProperty = getPropertyInfo(attributesPropertyInfo.PropertyType, "Unit");
						if (idProperty != null)
						{
							var attr = attributesPropertyInfo.GetValue(cyPhyMLObjectDst, null);
							idProperty.SetValue(attr, avmValue.ID, null);
						}
						if (unitsProperty != null)
						{
							var attr = attributesPropertyInfo.GetValue(cyPhyMLObjectDst, null);
							unitsProperty.SetValue(attr, avmValue.Unit, null);
						}
					}

					if (_avmValueNodeIDMap.ContainsKey(otherValueID) && hasValueParent)
					{
						var avmOtherValueWithOwner = _avmValueNodeIDMap[otherValueID];
						object avmOtherValueOwner = avmOtherValueWithOwner.Value;

						object cyPhyMLObjectSrc = null;
						if (!_avmCyPhyMLObjectMap.TryGetValue(avmOtherValueOwner, out cyPhyMLObjectSrc)) continue;

                        if (cyPhyMLObjectDst is CyPhyML.ModelicaParameter)
                        {
                            // CyPhyML.ModelicaParameter.SrcConnections.ModelicaParameterPortMapCollection
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.ModelicaParameterPortMap).Name);
                        }
                        else if (cyPhyMLObjectSrc is CyPhyML.CADMetric)
                        {
                            // CyPhyML.CADMetric.DstConnections.CADMetricPortMapCollection
                            CyPhyML.CADMetric x;
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.CADMetricPortMap).Name);
                        }
                        else if (cyPhyMLObjectDst is CyPhyML.CADParameter)
                        {
                            // CyPhyML.CADParameter.SrcConnections.CADParameterPortMapCollection
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.CADParameterPortMap).Name);
                        }
                        // else if (cyPhyMLObjectSrc is CyPhyML.ManufacturingModelMetric) TODO???
                        //{
                        //    CyPhyML.ManufacturingModelMetric x; x.DstConnections.
                        //}
                        else if (cyPhyMLObjectDst is CyPhyML.ManufacturingModelParameter)
                        {
                            // CyPhyML.ManufacturingModelParameter x; x.SrcConnections.ManufacturingParameterPortMapCollection
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.ManufacturingParameterPortMap).Name);
                        }
                        else if (cyPhyMLObjectDst is CyPhyML.SystemCParameter)
                        {
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.SystemCParameterPortMap).Name);
                        }
                        else if (cyPhyMLObjectDst is CyPhyML.EDAModelParameter)
                        {
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.EDAModelParameterMap).Name);
                        }
                        else if (cyPhyMLObjectDst is CyPhyML.SPICEModelParameter)
                        {
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.SPICEModelParameterMap).Name);
                        }
                        else
                        {
                            makeConnection(cyPhyMLObjectSrc, cyPhyMLObjectDst, typeof(CyPhyML.ValueFlow).Name);
                        }

						bool haveValue = false;
						object value = null;
						PropertyInfo cyPhyMLObjectSrcAttributesPropertyInfo = getPropertyInfo(getInterfaceType(cyPhyMLObjectSrc), "Attributes");
						if (cyPhyMLObjectSrcAttributesPropertyInfo != null)
						{
							PropertyInfo cyPhyMLObjectSrcValuePropertyInfo = getPropertyInfo(cyPhyMLObjectSrcAttributesPropertyInfo.PropertyType, "Value");
							if (cyPhyMLObjectSrcValuePropertyInfo != null)
							{
								haveValue = true;
								value = (string)cyPhyMLObjectSrcValuePropertyInfo.GetValue(cyPhyMLObjectSrcAttributesPropertyInfo.GetValue(cyPhyMLObjectSrc, null), null);
							}
						}

						if (haveValue)
						{
							PropertyInfo cyPhyMLObjectDstAttributesPropertyInfo = getPropertyInfo(getInterfaceType(cyPhyMLObjectDst), "Attributes");
							if (cyPhyMLObjectDstAttributesPropertyInfo != null)
							{
								PropertyInfo cyPhyMLObjectDstValuePropertyInfo = getPropertyInfo(cyPhyMLObjectDstAttributesPropertyInfo.PropertyType, "Value");
								if (cyPhyMLObjectDstValuePropertyInfo != null)
								{
									cyPhyMLObjectDstValuePropertyInfo.SetValue(cyPhyMLObjectDstAttributesPropertyInfo.GetValue(cyPhyMLObjectDst, null), value, null);
								}
							}
						}
					}
					continue;
				}
			}
		}

        protected void processComplexFormula(ComplexFormula avmComplexFormula, CyPhyML.CustomFormula cyphyCustomFormula)
        {
            cyphyCustomFormula.Name = avmComplexFormula.Name;
            cyphyCustomFormula.Attributes.ID = avmComplexFormula.ID;
            cyphyCustomFormula.Attributes.Expression = avmComplexFormula.Expression;
            registerValueNode(avmComplexFormula, avmComplexFormula);

            _avmCyPhyMLObjectMap.Add(avmComplexFormula, cyphyCustomFormula);
        }

        protected void init(bool resetUnitLibrary = false) {
            getCyPhyMLUnits();
            getCyPhyMLNamedUnits( resetUnitLibrary );

            getCyPhyMLPorts();
            getCyPhyMLModelPorts();
        }

        protected void DoLayout()
        {
            // If a member had layout information, lay everything out.
            // If not, fall back and use an auto-layout method.
            foreach (var kvp in _avmCyPhyMLObjectMap)
            {
                var avmObj = kvp.Key;
                var cyphyObj = kvp.Value;

                //var propInfo = getPropertyInfo(cyphyObj, "Impl");
                if (cyphyObj is ISIS.GME.Common.Interfaces.Base)
                {
                    var cyphyImpl = ((ISIS.GME.Common.Interfaces.Base)cyphyObj).Impl;

                    this.aMemberHasLayoutData = SetLayoutData(avmObj, cyphyImpl) || aMemberHasLayoutData;
                }
            }
        }

        protected void process<T>(T parent, avm.Port avmPort, List<avm.ConnectorFeature> connectorFeatures = null) {
            string avmPortTypeName = avmPort.GetType().ToString();
            if (!_cyPhyMLNameCreateMethodMap.ContainsKey(avmPortTypeName)) {
                writeMessage("WARNING:  No way to create CyPhyML object from \"" + avmPortTypeName + "\" avm port.", MessageType.WARNING);
                return;
            }

			CyPhyML.DomainModelPort cyPhyMLDomainModelPort = null;

			PropertyInfo avmClassPropertyInfo = getPropertyInfo(avmPort,"Class");
			string avmClass = "";

			if (avmClassPropertyInfo != null) {
				PropertyInfo implPropertyInfo = getPropertyInfo(parent,"Impl");
				object parentImpl = implPropertyInfo.GetValue( parent, null );

				avmClass = avmClassPropertyInfo.GetValue(avmPort, null) as string;
				// META-1984 don't create instances, just create a copy
				MgaFCO portInstance = getPortCopyFromLibrary(parentImpl as IMgaModel, avmClass);

				if (portInstance != null) {
					cyPhyMLDomainModelPort = CyPhyMLClasses.DomainModelPort.Cast(portInstance);
				}
			}

			if ( cyPhyMLDomainModelPort == null ) {
				_cyPhyMLNameCreateMethodMap[avmPortTypeName].call(parent, out cyPhyMLDomainModelPort);
			}

			if (avmClassPropertyInfo != null ) {
				PropertyInfo cyPhyMLAttributesPropertyInfo = getPropertyInfo(getInterfaceType(cyPhyMLDomainModelPort), "Attributes");
				if (cyPhyMLAttributesPropertyInfo != null) {
					PropertyInfo cyPhyMLClassPropertyInfo = cyPhyMLAttributesPropertyInfo.PropertyType.GetProperty("Class");
					if (cyPhyMLClassPropertyInfo != null) {
						cyPhyMLClassPropertyInfo.SetValue(cyPhyMLAttributesPropertyInfo.GetValue(cyPhyMLDomainModelPort, null), avmClass, null);
					}
				}
			}

            if (connectorFeatures != null)
            {
                foreach (var connectorFeature in connectorFeatures.OfType<avm.cad.GuideDatum>())
                {
                    if (avmPort.ID == connectorFeature.Datum)
                    {
                        ((MgaFCO)cyPhyMLDomainModelPort.Impl).set_BoolAttrByName("IsGuide", true);
                        break;
                    }
                }
            }
			if (avmPort is avm.modelica.Connector)
			{
				var avmModelicaConnector = avmPort as avm.modelica.Connector;                
				var cyphyModelicaConnector = CyPhyMLClasses.ModelicaConnector.Cast(cyPhyMLDomainModelPort.Impl);
				foreach (var avmModelicaRedeclare in avmModelicaConnector.Redeclare)
				{
					// See if this Redeclare already exists. If not, create one.
					CyPhyML.ModelicaRedeclare cyPhyMLModelicaRedeclare = cyphyModelicaConnector.Children
																		.ModelicaRedeclareCollection
																		.FirstOrDefault(n => n.Name == avmModelicaRedeclare.Locator);
					if (cyPhyMLModelicaRedeclare == null)
						cyPhyMLModelicaRedeclare = CyPhyMLClasses.ModelicaRedeclare.Create(cyphyModelicaConnector);

					populateModelicaRedeclare(avmModelicaRedeclare, cyPhyMLModelicaRedeclare);
				}
				foreach (var avmModelicaParameter in avmModelicaConnector.Parameter)
				{
					// See if this Parameter already exists. If not, create one.
					CyPhyML.ModelicaParameter cyPhyMLModelicaParameter = cyphyModelicaConnector.Children
																		   .ModelicaParameterCollection
																		   .FirstOrDefault(n => n.Name == avmModelicaParameter.Locator);
					if (cyPhyMLModelicaParameter == null)
						cyPhyMLModelicaParameter = CyPhyMLClasses.ModelicaParameter.Create(cyphyModelicaConnector);

					_avmCyPhyMLObjectMap.Add(avmModelicaParameter, cyPhyMLModelicaParameter);
					registerValueNode(avmModelicaParameter.Value, avmModelicaParameter);
					cyPhyMLModelicaParameter.Name = avmModelicaParameter.Locator;
				}
			}
			else if (avmPort is avm.schematic.Pin)
			{
				var avmPin = avmPort as avm.schematic.Pin;
				var cyPhyMLPin = cyPhyMLDomainModelPort as CyPhyML.SchematicModelPort;

				cyPhyMLPin.Attributes.Definition = avmPin.Definition;
                cyPhyMLPin.Attributes.EDAGate = avmPin.EDAGate;
                cyPhyMLPin.Attributes.EDASymbolLocationX = avmPin.EDASymbolLocationX;
                cyPhyMLPin.Attributes.EDASymbolLocationY = avmPin.EDASymbolLocationY;
                cyPhyMLPin.Attributes.EDASymbolRotation = avmPin.EDASymbolRotation;
                cyPhyMLPin.Attributes.SPICEPortNumber = (avmPin.SPICEPortNumberSpecified)
                                                        ? System.Convert.ToInt32(avmPin.SPICEPortNumber)
                                                        : 0;
			}
			else if (avmPort is avm.systemc.SystemCPort)
			{
				var avmSystemCPort = avmPort as avm.systemc.SystemCPort;
				var cyPhyMLPort = cyPhyMLDomainModelPort as CyPhyML.SystemCPort;

				if (avmSystemCPort.DataTypeSpecified)
					cyPhyMLPort.Attributes.DataType = d_SystemCPort_DataType[avmSystemCPort.DataType];
				if (avmSystemCPort.DataTypeDimensionSpecified)
					cyPhyMLPort.Attributes.DataTypeDimension = avmSystemCPort.DataTypeDimension;
				cyPhyMLPort.Attributes.Definition = avmSystemCPort.Definition;
				if (avmSystemCPort.DirectionalitySpecified)
					cyPhyMLPort.Attributes.Directionality = d_SystemCPort_Directionality[avmSystemCPort.Directionality];
				if (avmSystemCPort.FunctionSpecified)
					cyPhyMLPort.Attributes.Function = d_SystemCPort_Function[avmSystemCPort.Function];
			}
            else if (avmPort is avm.rf.RFPort)
            {
                var avmRFPort = avmPort as avm.rf.RFPort;
                var CyPhyMLPort = cyPhyMLDomainModelPort as CyPhyML.RFPort;
                                
                if (avmRFPort.NominalImpedanceSpecified)
                    CyPhyMLPort.Attributes.NominalImpedance = avmRFPort.NominalImpedance;
                if (avmRFPort.DirectionalitySpecified)
                    CyPhyMLPort.Attributes.Directionality = d_RFDirectionality[avmRFPort.Directionality];
            }

			_avmCyPhyMLObjectMap.Add(avmPort, cyPhyMLDomainModelPort);
			registerPort(avmPort);

			cyPhyMLDomainModelPort.Name = avmPort.Name;
			cyPhyMLDomainModelPort.Attributes.ID = avmPort.ID;
			cyPhyMLDomainModelPort.Attributes.Definition = avmPort.Definition;
			cyPhyMLDomainModelPort.Attributes.InstanceNotes = avmPort.Notes;
            // [ZL 2014-06-19] META-3356 use ALIGN as default
            if (cyPhyMLDomainModelPort is CyPhyML.Surface)
            {
                (cyPhyMLDomainModelPort as CyPhyML.Surface).Attributes.Alignment = CyPhyMLClasses.Surface.AttributesClass.Alignment_enum.ALIGN;
            }
		}

        private Dictionary<avm.rf.PortDirectionality, CyPhyMLClasses.RFPort.AttributesClass.Directionality_enum> d_RFDirectionality
            = new Dictionary<avm.rf.PortDirectionality, CyPhyMLClasses.RFPort.AttributesClass.Directionality_enum>()
            {
                {avm.rf.PortDirectionality.@in, CyPhyMLClasses.RFPort.AttributesClass.Directionality_enum.@in},
                {avm.rf.PortDirectionality.@out, CyPhyMLClasses.RFPort.AttributesClass.Directionality_enum.@out}
            };

        protected MgaFCO getPortCopyFromLibrary(IMgaModel parent, string className)
        {

            if (!_portNameTypeMap.ContainsKey(className)) return null;
            MgaFCO archetype = _portNameTypeMap[className].Impl as MgaFCO;
            MgaMetaRole role = (parent.Meta as MgaMetaModel).RoleByName[archetype.Meta.Name];
            if (role == null) return null;

            return parent.CopyFCODisp(archetype, role);
        }

        protected void populateModelicaRedeclare(avm.modelica.Redeclare avmModelicaRedeclare, CyPhyML.ModelicaRedeclare cyPhyMLModelicaRedeclare)
        {
            _avmCyPhyMLObjectMap.Add(avmModelicaRedeclare, cyPhyMLModelicaRedeclare);

            cyPhyMLModelicaRedeclare.Attributes.Notes = avmModelicaRedeclare.Notes;
            cyPhyMLModelicaRedeclare.Name = avmModelicaRedeclare.Locator;
            if (avmModelicaRedeclare.TypeSpecified)
            {
                cyPhyMLModelicaRedeclare.Attributes.ModelicaRedeclareType = _modelicaRedeclareTypeEnumMap[avmModelicaRedeclare.Type];
            }

            registerValueNode(avmModelicaRedeclare.Value, avmModelicaRedeclare);
        }

        protected Dictionary<string, avm.ConnectorCompositionTarget> _idConnectorMap = new Dictionary<string, ConnectorCompositionTarget>();

        protected void processConnector(Connector avmConnector, CyPhyML.Connector cyPhyMLConnector)
        {
            _avmCyPhyMLObjectMap.Add(avmConnector, cyPhyMLConnector);
            _idConnectorMap.Add(avmConnector.ID, avmConnector);

            cyPhyMLConnector.Name = avmConnector.Name;
            cyPhyMLConnector.Attributes.Definition = avmConnector.Definition;
            cyPhyMLConnector.Attributes.InstanceNotes = avmConnector.Notes;
            cyPhyMLConnector.Attributes.ID = avmConnector.ID;

            foreach (avm.Port avmPort in avmConnector.Role)
            {
                process(cyPhyMLConnector, avmPort, avmConnector.ConnectorFeature);
            }

            foreach (avm.Property avmProperty in avmConnector.Property)
            {
                process(cyPhyMLConnector, avmProperty);
            }

            foreach (var assemblyDetail in avmConnector.DefaultJoin)
            {
                JoinDataTransform.TransformJoinData(assemblyDetail, cyPhyMLConnector);
            }
        }

        protected void processPorts()
        {

            foreach (avm.PortMapTarget iteratorAVMPort in _avmPortSet)
            {

                avm.PortMapTarget avmPort = iteratorAVMPort; // avmPort CAN BE ASSIGNED TO

                object cyPhyMLObjectSrc = null;
                if (!_avmCyPhyMLObjectMap.TryGetValue(avmPort, out cyPhyMLObjectSrc))
                    continue;

                foreach (string iteratorAVMPortID in avmPort.PortMap)
                {
                    string otherAvmPortID = iteratorAVMPortID;

                    if (!_avmPortIDMap.ContainsKey(otherAvmPortID))
                        continue;

                    avm.PortMapTarget otherAVMPort = _avmPortIDMap[otherAvmPortID];

                    object cyPhyMLObjectDst = null;
                    if (!_avmCyPhyMLObjectMap.TryGetValue(otherAVMPort, out cyPhyMLObjectDst))
                        continue;

                    if (otherAVMPort.PortMap.Contains(avmPort.ID) && otherAVMPort.ID.CompareTo(avmPort.ID) < 0)
                        continue;

                    // special-case: do not attempt to create connections inside of a Connector
                    IMgaFCO src = GetFCOObject(cyPhyMLObjectSrc);
                    IMgaReference srcReference = GetFCOObjectReference(cyPhyMLObjectSrc);
                    IMgaFCO dst = GetFCOObject(cyPhyMLObjectDst);
                    IMgaReference dstReference = GetFCOObjectReference(cyPhyMLObjectDst);

                    bool createAsPortConnection = false;
                    if (srcReference == null && dstReference == null && src.ParentModel != null && dst.ParentModel != null &&
                        src.ParentModel == dst.ParentModel && src.ParentModel.Meta.Name == "Connector")
                    {
                        createAsPortConnection = true;
                    }

                    makeConnection(cyPhyMLObjectDst, cyPhyMLObjectSrc, typeof(CyPhyML.PortComposition).Name, createAsPortConnection: createAsPortConnection);
                }

                if (iteratorAVMPort is avm.cad.Plane)
                {
                    avm.cad.Plane plane = iteratorAVMPort as avm.cad.Plane;

                    foreach (string iteratorAVMPortID in plane.SurfaceReverseMap)
                    {
                        string avmPortID = iteratorAVMPortID;

                        avm.cad.Plane otherAVMPort = null;

                        if (!_avmPortIDMap.ContainsKey(avmPortID)) continue;

                        otherAVMPort = _avmPortIDMap[avmPortID] as avm.cad.Plane;

                        object cyPhyMLObjectDst = null;
                        if (!_avmCyPhyMLObjectMap.TryGetValue(otherAVMPort, out cyPhyMLObjectDst)) continue;

                        CyPhyMLClasses.SurfaceReverseMap.Connect(
                            cyPhyMLObjectDst as CyPhyML.Surface,// FIXME could be a refport in DesignImporter
                            cyPhyMLObjectSrc as CyPhyML.Surface);
                    }
                }
            }
        }

    }

    public class CyPhyMLComponentBuilder : AVM2CyPhyMLBuilder {

        private HashSet<avm.DomainModel> _avmDomainModelSet = new HashSet<avm.DomainModel>();

        private void process(avm.cyber.CyberModel avmCyberModel) {

            CyPhyML.CyberModel cyPhyMLCyberModel = CyPhyMLClasses.CyberModel.Create(_cyPhyMLComponent);

            _avmCyPhyMLObjectMap.Add(avmCyberModel, cyPhyMLCyberModel);

            cyPhyMLCyberModel.Name = avmCyberModel.Name;
            cyPhyMLCyberModel.Attributes.Author = avmCyberModel.Author;
            cyPhyMLCyberModel.Attributes.Notes = avmCyberModel.Notes;
            cyPhyMLCyberModel.Attributes.Class = avmCyberModel.Class;
            cyPhyMLCyberModel.Attributes.FilePathWithinResource = avmCyberModel.Locator;
            cyPhyMLCyberModel.Attributes.ModelType = d_CyberModelTypeMap[avmCyberModel.Type];

            foreach (avm.modelica.Connector avmModelicaConnector in avmCyberModel.Connector)
            {
                processModelicaConnector(cyPhyMLCyberModel, avmModelicaConnector);
            }

            foreach (avm.modelica.Parameter avmModelicaParameter in avmCyberModel.Parameter)
            {
                processModelicaParameter(cyPhyMLCyberModel, avmModelicaParameter);
            }
        }

        private void process( avm.modelica.ModelicaModel avmModelicaModel ) {

			CyPhyML.ModelicaModel cyPhyMLModelicaModel = CyPhyMLClasses.ModelicaModel.Create(_cyPhyMLComponent);

			_avmCyPhyMLObjectMap.Add(avmModelicaModel, cyPhyMLModelicaModel);

            cyPhyMLModelicaModel.Name = string.IsNullOrWhiteSpace(avmModelicaModel.Name) ? "ModelicaModel" : avmModelicaModel.Name;
			cyPhyMLModelicaModel.Attributes.Author = avmModelicaModel.Author;
			cyPhyMLModelicaModel.Attributes.Class = avmModelicaModel.Class;
			cyPhyMLModelicaModel.Attributes.Notes = avmModelicaModel.Notes;

			foreach (avm.modelica.Redeclare avmModelicaRedeclare in avmModelicaModel.Redeclare) {
				CyPhyML.ModelicaRedeclare cyPhyMLModelicaRedeclare = CyPhyMLClasses.ModelicaRedeclare.Create(cyPhyMLModelicaModel);

				populateModelicaRedeclare(avmModelicaRedeclare, cyPhyMLModelicaRedeclare);
			}

			foreach (avm.modelica.Connector avmModelicaConnector in avmModelicaModel.Connector)
			{
                processModelicaConnector(cyPhyMLModelicaModel, avmModelicaConnector);				
			}

			foreach (avm.modelica.Parameter avmModelicaParameter in avmModelicaModel.Parameter) {
                processModelicaParameter(cyPhyMLModelicaModel, avmModelicaParameter);
			}

			CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLModelicaModel);
		}

        private void processModelicaParameter(CyPhyML.ModelicaModel cyPhyMLModelicaModel, avm.modelica.Parameter avmModelicaParameter)
        {
            CyPhyML.ModelicaParameter cyPhyMLModelicaParameter = CyPhyMLClasses.ModelicaParameter.Create(cyPhyMLModelicaModel);

            _avmCyPhyMLObjectMap.Add(avmModelicaParameter, cyPhyMLModelicaParameter);

            registerValueNode(avmModelicaParameter.Value, avmModelicaParameter);

            cyPhyMLModelicaParameter.Name = avmModelicaParameter.Locator;
            if (avmModelicaParameter.Value != null)
            {
                cyPhyMLModelicaParameter.Attributes.ID = avmModelicaParameter.Value.ID;

                if (!String.IsNullOrWhiteSpace(avmModelicaParameter.Value.Unit))
                {
                    if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmModelicaParameter.Value.Unit))
                    {
                        cyPhyMLModelicaParameter.Referred.unit = _unitSymbolCyPhyMLUnitMap[avmModelicaParameter.Value.Unit];
                    }
                    else
                    {
                        writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmModelicaParameter.Value.Unit), MessageType.WARNING);
                    }
                }
            }
        }

        private Dictionary<avm.DoDDistributionStatementEnum, CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum> _dodDistStatementEnumMap = 
            new Dictionary<DoDDistributionStatementEnum, CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum>()
        {
            { avm.DoDDistributionStatementEnum.StatementA,      CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum.StatementA},
            { avm.DoDDistributionStatementEnum.StatementB,      CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum.StatementB},
            { avm.DoDDistributionStatementEnum.StatementC,      CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum.StatementC},
            { avm.DoDDistributionStatementEnum.StatementD,      CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum.StatementD},
            { avm.DoDDistributionStatementEnum.StatementE,      CyPhyMLClasses.DoDDistributionStatement.AttributesClass.DoDDistributionStatementEnum_enum.StatementE},
        };


        private bool avmCyPhyMLInteritance(string portType, Type ancestorClass) {
			if (!_cyPhyMLNameCreateMethodMap.ContainsKey(portType)) return false;
			Type cyPhyMLClass = _cyPhyMLNameCreateMethodMap[portType].getClass();
			Type cyPhyMLInterface = cyPhyMLClass.GetInterface(cyPhyMLClass.Name);
			return cyPhyMLInterface.GetInterfaces().Contains(ancestorClass);
		}

        public CyPhyMLComponentBuilder(CyPhyML.RootFolder rootFolder, bool resetUnitLibrary = false, object messageConsoleParameter = null)
		    : base(rootFolder, messageConsoleParameter: messageConsoleParameter)
		{
		    init(resetUnitLibrary);
		}

		public CyPhyMLComponentBuilder(CyPhyML.Components cyPhyMLComponentParent, bool resetUnitLibrary = false, object messageConsoleParameter = null)
            : base(CyPhyMLClasses.RootFolder.GetRootFolder(cyPhyMLComponentParent.Impl.Project), messageConsoleParameter: messageConsoleParameter)
        {
			_cyPhyMLComponent = CyPhyMLClasses.Component.Create( cyPhyMLComponentParent );
			init( resetUnitLibrary );
		}

		private CyPhyMLComponentBuilder(CyPhyML.ComponentAssembly cyPhyMLComponentParent, bool resetUnitLibrary = false, object messageConsoleParameter = null)
            : base(CyPhyMLClasses.RootFolder.GetRootFolder(cyPhyMLComponentParent.Impl.Project), messageConsoleParameter: messageConsoleParameter)
        {
			_cyPhyMLComponent = CyPhyMLClasses.Component.Create( cyPhyMLComponentParent );
			init(resetUnitLibrary);
		}

		private CyPhyML.Component getComponent() {
			return _cyPhyMLComponent;
		}

		private void SetComponentName( string componentName ) {
			_cyPhyMLComponent.Name = componentName;
		}

		private void SetComponentId(string avmId)
		{
			_cyPhyMLComponent.Attributes.AVMID = avmId;
		}

		private void setClassifications(List<string> categories) {
			foreach (string category in categories) {
				if (_cyPhyMLComponent.Attributes.Classifications != "")
					_cyPhyMLComponent.Attributes.Classifications += "\n";
				_cyPhyMLComponent.Attributes.Classifications += category;
			}
		}

        protected CyPhyML.Component _cyPhyMLComponent;
        private void process(avm.SimpleFormula avmSimpleFormula)
        {
            CyPhyML.SimpleFormula cyphySimpleFormula = CyPhyMLClasses.SimpleFormula.Create(_cyPhyMLComponent);
            process(avmSimpleFormula, cyphySimpleFormula);
        }

        private void process(avm.ComplexFormula avmComplexFormula)
        {
            CyPhyML.CustomFormula cyphyCustomFormula = CyPhyMLClasses.CustomFormula.Create(_cyPhyMLComponent);
            processComplexFormula(avmComplexFormula, cyphyCustomFormula);
        }

        private void process(avm.Property avmProperty) {
			process(_cyPhyMLComponent, avmProperty);
		}
		

        private void process( avm.Port avmPort) {
			process(_cyPhyMLComponent, avmPort);
		}

		private void process(avm.Resource avmResource) {

			CyPhyML.Resource cyPhyMLResource = CyPhyMLClasses.Resource.Create(_cyPhyMLComponent);

			_avmCyPhyMLObjectMap.Add(avmResource, cyPhyMLResource);
			_avmResourceIDMap.Add(avmResource.ID, avmResource);

			cyPhyMLResource.Name = avmResource.Name;
			cyPhyMLResource.Attributes.Path = avmResource.Path;
            // META-3490 special-case CAD files: CyPhy resource should not contain .1
            Match m = cadResourceRegex.Match(avmResource.Path);
            if (m.Success)
            {
                cyPhyMLResource.Attributes.Path = m.Groups[1].Value + m.Groups[2].Value;
            }

			cyPhyMLResource.Attributes.Hash = avmResource.Hash;
			cyPhyMLResource.Attributes.ID = avmResource.ID;
			cyPhyMLResource.Attributes.Notes = avmResource.Notes;

		}

		private void process(avm.Connector avmConnector)
		{
		    CyPhyML.Connector cyPhyMLConnector = CyPhyMLClasses.Connector.Create(_cyPhyMLComponent);

		    processConnector(avmConnector, cyPhyMLConnector);
		}

        private void process(avm.DistributionRestriction avmDistributionRestriction) {

			string avmDistributionRestrictionTypeName = avmDistributionRestriction.GetType().ToString();
			if (!_cyPhyMLNameCreateMethodMap.ContainsKey(avmDistributionRestrictionTypeName)) {
				writeMessage("WARNING:  No way to create CyPhyML object from \"" + avmDistributionRestrictionTypeName + "\" avm distribution restriction.", MessageType.WARNING);
				return;
			}

			CyPhyML.DistributionRestriction cyPhyMLDistributionRestriction = null;
			_cyPhyMLNameCreateMethodMap[avmDistributionRestrictionTypeName].call(_cyPhyMLComponent, out cyPhyMLDistributionRestriction);

			_avmCyPhyMLObjectMap.Add(avmDistributionRestriction, cyPhyMLDistributionRestriction);

			cyPhyMLDistributionRestriction.Attributes.Notes = avmDistributionRestriction.Notes;

			if (avmDistributionRestriction is avm.SecurityClassification) {
				(cyPhyMLDistributionRestriction as CyPhyML.SecurityClassification).Attributes.Level = (avmDistributionRestriction as avm.SecurityClassification).Level;
			} else if (avmDistributionRestriction is avm.Proprietary) {
				(cyPhyMLDistributionRestriction as CyPhyML.Proprietary).Attributes.Organization = (avmDistributionRestriction as avm.Proprietary).Organization;
			} else if (avmDistributionRestriction is avm.ITAR) 
            {
                // If there's an avm.ITAR tag in the input file, then it means the Component is ITAR.
                // We can use a constant here.
                (cyPhyMLDistributionRestriction as CyPhyML.ITAR).Attributes.RestrictionLevel = CyPhyMLClasses.ITAR.AttributesClass.RestrictionLevel_enum.ITAR;
                cyPhyMLDistributionRestriction.Name = "ITAR";
            }
            else if (avmDistributionRestriction is avm.DoDDistributionStatement)
            {
                var avmDistStatement = avmDistributionRestriction as avm.DoDDistributionStatement;
                var cyphyMLDistStatement = cyPhyMLDistributionRestriction as CyPhyML.DoDDistributionStatement;

                cyphyMLDistStatement.Attributes.DoDDistributionStatementEnum = _dodDistStatementEnumMap[avmDistStatement.Type];
                cyphyMLDistStatement.Attributes.Notes = avmDistStatement.Notes;

                cyPhyMLDistributionRestriction.Name = "DoDDistribution_" + cyphyMLDistStatement.Attributes.DoDDistributionStatementEnum.ToString();
            }
		}
		
		private MgaFCO getPortInstance(IMgaModel parent, string className) {

			if (!_portNameTypeMap.ContainsKey(className)) return null;
			MgaFCO archetype = _portNameTypeMap[className].Impl as MgaFCO;
			MgaMetaRole role = (parent.Meta as MgaMetaModel).RoleByName[archetype.Meta.Name];
			if (role == null) return null;
			
			return parent.DeriveChildObject(archetype, role, instance: true);
		}

        private Dictionary<avm.cyber.ModelType, CyPhyMLClasses.CyberModel.AttributesClass.ModelType_enum> d_CyberModelTypeMap = new Dictionary<avm.cyber.ModelType, CyPhyMLClasses.CyberModel.AttributesClass.ModelType_enum>()
        {
            { avm.cyber.ModelType.ESMoL, CyPhyMLClasses.CyberModel.AttributesClass.ModelType_enum.ESMoL },
            { avm.cyber.ModelType.SignalFlow, CyPhyMLClasses.CyberModel.AttributesClass.ModelType_enum.SignalFlow },
            { avm.cyber.ModelType.Simulink, CyPhyMLClasses.CyberModel.AttributesClass.ModelType_enum.Simulink }
        };

        public CyPhyML.CyberModel process(avm.cyber.CyberModel avmCyberModel, CyPhyML.Component parentComponent = null)
        {
            CyPhyML.CyberModel cyPhyMLCyberModel;
            if (parentComponent == null)
            {
                cyPhyMLCyberModel = CyPhyMLClasses.CyberModel.Create(_cyPhyMLComponent);
            }
            else
            {
                cyPhyMLCyberModel = CyPhyMLClasses.CyberModel.Create(parentComponent);
            }

            _avmCyPhyMLObjectMap.Add(avmCyberModel, cyPhyMLCyberModel);

            cyPhyMLCyberModel.Name = avmCyberModel.Name;
            cyPhyMLCyberModel.Attributes.Author = avmCyberModel.Author;
            cyPhyMLCyberModel.Attributes.Notes = avmCyberModel.Notes;
            cyPhyMLCyberModel.Attributes.Class = avmCyberModel.Class;
            cyPhyMLCyberModel.Attributes.FilePathWithinResource = avmCyberModel.Locator;
            cyPhyMLCyberModel.Attributes.ModelType = d_CyberModelTypeMap[avmCyberModel.Type];

            string fileResource = avmCyberModel.UsesResource;
            if (fileResource != null && fileResource != "")
            {
                avm.Resource res = null;
                _avmResourceIDMap.TryGetValue(fileResource, out res);
                if (res != null)
                {
                    cyPhyMLCyberModel.Attributes.FileRef = res.Path;
                }
            }
            else
            {
                writeMessage(String.Format("WARNING: No Cyber resource files found for: {0}", avmCyberModel.Name), MessageType.WARNING);
            }

            foreach (avm.modelica.Connector avmModelicaConnector in avmCyberModel.Connector)
            {
                processModelicaConnector(cyPhyMLCyberModel, avmModelicaConnector);
            }

            foreach (avm.modelica.Parameter avmModelicaParameter in avmCyberModel.Parameter)
            {
                processModelicaParameter(cyPhyMLCyberModel, avmModelicaParameter);
            }

            try
            {
                CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLCyberModel);
            }
            catch (Exception)
            {
            }

            return cyPhyMLCyberModel;
        }
	
		public CyPhyML.EDAModel process(avm.schematic.eda.EDAModel avmEdaModel, CyPhyML.Component parent = null)
		{
            if (parent == null)
                parent = _cyPhyMLComponent;
                        
            CyPhyML.EDAModel cyPhyMLEdaModel = CyPhyMLClasses.EDAModel.Create(parent);
			_avmCyPhyMLObjectMap.Add(avmEdaModel, cyPhyMLEdaModel);

            cyPhyMLEdaModel.Name = string.IsNullOrWhiteSpace(avmEdaModel.Name) ? "EDAModel" : avmEdaModel.Name;
			cyPhyMLEdaModel.Attributes.Author = avmEdaModel.Author;
			cyPhyMLEdaModel.Attributes.Device = avmEdaModel.Device;
			cyPhyMLEdaModel.Attributes.DeviceSet = avmEdaModel.DeviceSet;
			cyPhyMLEdaModel.Attributes.Library = avmEdaModel.Library;
			cyPhyMLEdaModel.Attributes.Notes = avmEdaModel.Notes;
			cyPhyMLEdaModel.Attributes.Package = avmEdaModel.Package;
            cyPhyMLEdaModel.Attributes.HasMultiLayerFootprint = avmEdaModel.HasMultiLayerFootprint;

			foreach (var avmParameter in avmEdaModel.Parameter)
			{
				var cyPhyMLParameter = CyPhyMLClasses.EDAModelParameter.Create(cyPhyMLEdaModel);
				_avmCyPhyMLObjectMap.Add(avmParameter, cyPhyMLParameter);
				registerValueNode(avmParameter.Value, avmParameter);

				cyPhyMLParameter.Name = avmParameter.Locator;
				if (avmParameter.Value != null)
				{
					if (!String.IsNullOrWhiteSpace(avmParameter.Value.Unit))
					{
						if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmParameter.Value.Unit))
						{
							cyPhyMLParameter.Referred.unit = _unitSymbolCyPhyMLUnitMap[avmParameter.Value.Unit];
						}
						else
						{
							writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmParameter.Value.Unit), MessageType.WARNING);
						}
					}
				}
			}

			foreach (var avmPin in avmEdaModel.Pin)
			{
				process<CyPhyML.EDAModel>(cyPhyMLEdaModel, avmPin);
			}

			CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLEdaModel);

            return cyPhyMLEdaModel;
		}

        public CyPhyML.SPICEModel process(avm.schematic.spice.SPICEModel avmSpiceModel, CyPhyML.Component parent = null)
        {
            if (parent == null)
                parent = _cyPhyMLComponent;

            CyPhyML.SPICEModel cyPhyMLSpiceModel = CyPhyMLClasses.SPICEModel.Create(parent);
            _avmCyPhyMLObjectMap.Add(avmSpiceModel, cyPhyMLSpiceModel);

            cyPhyMLSpiceModel.Name = string.IsNullOrWhiteSpace(avmSpiceModel.Name) ? "SPICEModel" : avmSpiceModel.Name;
            cyPhyMLSpiceModel.Attributes.Author = avmSpiceModel.Author;
            cyPhyMLSpiceModel.Attributes.Notes = avmSpiceModel.Notes;
            cyPhyMLSpiceModel.Attributes.Class = avmSpiceModel.Class;

            foreach (var avmParameter in avmSpiceModel.Parameter)
            {
                var cyPhyMLParameter = CyPhyMLClasses.SPICEModelParameter.Create(cyPhyMLSpiceModel);
                _avmCyPhyMLObjectMap.Add(avmParameter, cyPhyMLParameter);
                registerValueNode(avmParameter.Value, avmParameter);

                cyPhyMLParameter.Name = avmParameter.Locator;
                if (avmParameter.Value != null)
                {
                    if (!String.IsNullOrWhiteSpace(avmParameter.Value.Unit))
                    {
                        if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmParameter.Value.Unit))
                        {
                            cyPhyMLParameter.Referred.unit = _unitSymbolCyPhyMLUnitMap[avmParameter.Value.Unit];
                        }
                        else
                        {
                            writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmParameter.Value.Unit), MessageType.WARNING);
                        }
                    }
                }
            }

            foreach (var avmPin in avmSpiceModel.Pin)
            {
                process<CyPhyML.SPICEModel>(cyPhyMLSpiceModel, avmPin);
            }

            CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLSpiceModel);

            return cyPhyMLSpiceModel;
        }
        

		private void process(avm.systemc.SystemCModel avmSystemCModel)
		{
			CyPhyML.SystemCModel cyPhyMLSystemCModel = CyPhyMLClasses.SystemCModel.Create(_cyPhyMLComponent);
			_avmCyPhyMLObjectMap.Add(avmSystemCModel, cyPhyMLSystemCModel);

			cyPhyMLSystemCModel.Name = string.IsNullOrWhiteSpace(avmSystemCModel.Name) ? "SystemCModel" : avmSystemCModel.Name;
			cyPhyMLSystemCModel.Attributes.Author = avmSystemCModel.Author;
			cyPhyMLSystemCModel.Attributes.Notes = avmSystemCModel.Notes;
            cyPhyMLSystemCModel.Attributes.ModuleName = avmSystemCModel.ModuleName;

			foreach (var avmParameter in avmSystemCModel.Parameter)
			{
				var cyPhyMLParameter = CyPhyMLClasses.SystemCParameter.Create(cyPhyMLSystemCModel);
				_avmCyPhyMLObjectMap.Add(avmParameter, cyPhyMLParameter);
				registerValueNode(avmParameter.Value, avmParameter);

				cyPhyMLParameter.Name = avmParameter.ParamName;
				cyPhyMLParameter.Attributes.ParameterName = avmParameter.ParamName;
				if (avmParameter.ParamPositionSpecified)
					cyPhyMLParameter.Attributes.ParameterPosition = avmParameter.ParamPosition;
			}

			foreach (var avmPort in avmSystemCModel.SystemCPort)
			{
				process<CyPhyML.SystemCModel>(cyPhyMLSystemCModel, avmPort);
			}

			CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLSystemCModel);
		}

        private Dictionary<avm.rf.RotationEnum, CyPhyMLClasses.RFModel.AttributesClass.Rotation_enum> d_RFRotation
            = new Dictionary<avm.rf.RotationEnum, CyPhyMLClasses.RFModel.AttributesClass.Rotation_enum>()
            {
                { avm.rf.RotationEnum.r0, CyPhyMLClasses.RFModel.AttributesClass.Rotation_enum._0 },
                { avm.rf.RotationEnum.Item90, CyPhyMLClasses.RFModel.AttributesClass.Rotation_enum._90 },
                { avm.rf.RotationEnum.r180, CyPhyMLClasses.RFModel.AttributesClass.Rotation_enum._180 },
                { avm.rf.RotationEnum.r270, CyPhyMLClasses.RFModel.AttributesClass.Rotation_enum._270 }
            };

        private void process(avm.rf.RFModel avmRFModel)
        {
            CyPhyML.RFModel cyPhyMLRFModel = CyPhyMLClasses.RFModel.Create(_cyPhyMLComponent);
            _avmCyPhyMLObjectMap.Add(avmRFModel, cyPhyMLRFModel);

            cyPhyMLRFModel.Name = "RFModel";
            cyPhyMLRFModel.Attributes.Author = avmRFModel.Author;
            cyPhyMLRFModel.Attributes.Notes = avmRFModel.Notes;
            if (avmRFModel.XSpecified)
                cyPhyMLRFModel.Attributes.X = avmRFModel.X;
            if (avmRFModel.YSpecified)
                cyPhyMLRFModel.Attributes.Y = avmRFModel.Y;
            if (avmRFModel.RotationSpecified)
                cyPhyMLRFModel.Attributes.Rotation = d_RFRotation[avmRFModel.Rotation];
            
            foreach (var avmPort in avmRFModel.RFPort)
            {
                process<CyPhyML.RFModel>(cyPhyMLRFModel, avmPort);
            }

            CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLRFModel);
        }

        private void processModelicaConnector(CyPhyML.ModelicaModel cyPhyMLModelicaModel, avm.modelica.Connector avmModelicaConnector)
        {
            CyPhyML.ModelicaConnector cyPhyMLModelicaConnector = null;

            // First, try to see if we should create an instance from the port library.
            // If so, the function getPortInstance(...) will return a new instance of the port.

            // META-1984 don't instantiate, just create a copy
            MgaFCO portInstance = getPortCopyFromLibrary(cyPhyMLModelicaModel.Impl as IMgaModel, avmModelicaConnector.Class);

            bool isInstance = (portInstance != null);
            if (isInstance)
            {
                cyPhyMLModelicaConnector = CyPhyMLClasses.ModelicaConnector.Cast(portInstance);
            }
            // If not an instance, or the connector is missing (library version of port is wrong)
            if (isInstance == false || cyPhyMLModelicaConnector == null)
            {
                cyPhyMLModelicaConnector = CyPhyMLClasses.ModelicaConnector.Create(cyPhyMLModelicaModel);
            }

            _avmCyPhyMLObjectMap.Add(avmModelicaConnector, cyPhyMLModelicaConnector);

            registerPort(avmModelicaConnector);

            cyPhyMLModelicaConnector.Name = avmModelicaConnector.Name;
            cyPhyMLModelicaConnector.Attributes.Definition = avmModelicaConnector.Definition;
            cyPhyMLModelicaConnector.Attributes.ID = avmModelicaConnector.ID;
            cyPhyMLModelicaConnector.Attributes.InstanceNotes = avmModelicaConnector.Notes;
            cyPhyMLModelicaConnector.Attributes.Locator = avmModelicaConnector.Locator;
            cyPhyMLModelicaConnector.Attributes.Class = avmModelicaConnector.Class;

            foreach (avm.modelica.Redeclare avmModelicaRedeclare in avmModelicaConnector.Redeclare)
            {
                CyPhyML.ModelicaRedeclare cyPhyMLModelicaRedeclare = null;
                if (isInstance)
                {
                    // We cannot create a new Redeclare; look for the existing one.
                    cyPhyMLModelicaRedeclare = cyPhyMLModelicaConnector.Children
                                                                       .ModelicaRedeclareCollection
                                                                       .Where(n => n.Name == avmModelicaRedeclare.Locator)
                                                                       .FirstOrDefault();
                }
                // If not an instance, or the redeclare is missing (library version of port is wrong)
                if (isInstance == false || cyPhyMLModelicaRedeclare == null)
                {
                    cyPhyMLModelicaRedeclare = CyPhyMLClasses.ModelicaRedeclare.Create(cyPhyMLModelicaConnector);
                }

                populateModelicaRedeclare(avmModelicaRedeclare, cyPhyMLModelicaRedeclare);
            }

            foreach (avm.modelica.Parameter avmModelicaParameter in avmModelicaConnector.Parameter)
            {
                CyPhyML.ModelicaParameter cyPhyMLModelicaParameter = null;
                if (isInstance)
                {
                    cyPhyMLModelicaParameter = cyPhyMLModelicaConnector.Children
                                                                       .ModelicaParameterCollection
                                                                       .Where(n => n.Name == avmModelicaParameter.Locator)
                                                                       .FirstOrDefault();
                }

                // If not an instance, or the parameter is missing (library version of port is wrong)
                if (isInstance == false || cyPhyMLModelicaParameter == null)
                {
                    cyPhyMLModelicaParameter = CyPhyMLClasses.ModelicaParameter.Create(cyPhyMLModelicaConnector);
                }

                _avmCyPhyMLObjectMap.Add(avmModelicaParameter, cyPhyMLModelicaParameter);
                registerValueNode(avmModelicaParameter.Value, avmModelicaParameter);
                cyPhyMLModelicaParameter.Name = avmModelicaParameter.Locator;
                if (avmModelicaParameter.Value != null)
                {
                    cyPhyMLModelicaParameter.Attributes.ID = avmModelicaParameter.Value.ID;

                    if (!String.IsNullOrWhiteSpace(avmModelicaParameter.Value.Unit))
                    {
                        if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmModelicaParameter.Value.Unit))
                        {
                            cyPhyMLModelicaParameter.Referred.unit = _unitSymbolCyPhyMLUnitMap[avmModelicaParameter.Value.Unit];
                        }
                        else
                        {
                            writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmModelicaParameter.Value.Unit), MessageType.WARNING);
                        }
                    }
                }
            }
        }


        public CyPhyML.CADModel process(avm.cad.CADModel avmCADModel, CyPhyML.Component parentComponent = null)
		{
			if (parentComponent == null)
			{
				parentComponent = _cyPhyMLComponent;
			}

			CyPhyML.CADModel cyPhyMLCADModel = CyPhyMLClasses.CADModel.Create(parentComponent);

			_avmCyPhyMLObjectMap.Add( avmCADModel, cyPhyMLCADModel );

            cyPhyMLCADModel.Name = string.IsNullOrWhiteSpace(avmCADModel.Name) ? "CADModel" : avmCADModel.Name;
			cyPhyMLCADModel.Attributes.Author = avmCADModel.Author;
			cyPhyMLCADModel.Attributes.Notes = avmCADModel.Notes;

			foreach (avm.cad.Metric avmCADMetric in avmCADModel.ModelMetric) {
				CyPhyML.CADMetric cyPhyMLCADMetric = CyPhyMLClasses.CADMetric.Create(cyPhyMLCADModel);
				_avmCyPhyMLObjectMap.Add(avmCADMetric, cyPhyMLCADMetric);
				cyPhyMLCADMetric.Name = avmCADMetric.Name;
				cyPhyMLCADMetric.Attributes.ParameterName = avmCADMetric.Name;

                try
                {
                    if (avmCADMetric.Value.ValueExpression is avm.FixedValue)
                    {
                        cyPhyMLCADMetric.Attributes.Value = ((avm.FixedValue)avmCADMetric.Value.ValueExpression).Value;
                    }
                    else if (avmCADMetric.Value.ValueExpression is avm.ParametricValue)
                    {
                        // This case doesn't really make sense, but Ricardo provides models with this structure.
                        // In this case, take the Fixed Value of the thing and use it as the value.
                        var avmParametricValue = avmCADMetric.Value.ValueExpression as avm.ParametricValue;
                        cyPhyMLCADMetric.Attributes.Value = (avmParametricValue.Default as avm.FixedValue).Value;
                    }
                    else
                    {
                        writeMessage("Could not parse value of CAD Metric: " + cyPhyMLCADMetric.Name, MessageType.WARNING);
                    }
                }
                catch
                {
                    writeMessage("Exception parsing the value of CAD Metric: " + cyPhyMLCADMetric.Name, MessageType.WARNING);
                }
				
				registerValueNode(avmCADMetric.Value, avmCADMetric);
			}

			foreach (avm.cad.Parameter avmCADParameter in avmCADModel.Parameter) {
				CyPhyML.CADParameter cyPhyMLCADParameter = CyPhyMLClasses.CADParameter.Create(cyPhyMLCADModel);
				_avmCyPhyMLObjectMap.Add(avmCADParameter, cyPhyMLCADParameter);
				cyPhyMLCADParameter.Name = avmCADParameter.Name;
				cyPhyMLCADParameter.Attributes.ParameterName = avmCADParameter.Name;
				cyPhyMLCADParameter.Attributes.Unit = avmCADParameter.Value.Unit;
				if (avmCADParameter.Value != null)
				{
					Dictionary<avm.DataTypeEnum,CyPhyMLClasses.CADParameter.AttributesClass.CADParameterType_enum> d_AVMParamType_to_CADParamType = new Dictionary<DataTypeEnum,CyPhyMLClasses.CADParameter.AttributesClass.CADParameterType_enum>() 
					{
						{avm.DataTypeEnum.Boolean, CyPhyMLClasses.CADParameter.AttributesClass.CADParameterType_enum.Boolean },
						{avm.DataTypeEnum.Integer, CyPhyMLClasses.CADParameter.AttributesClass.CADParameterType_enum.Integer },
						{avm.DataTypeEnum.Real, CyPhyMLClasses.CADParameter.AttributesClass.CADParameterType_enum.Float},
						{avm.DataTypeEnum.String, CyPhyMLClasses.CADParameter.AttributesClass.CADParameterType_enum.String }
					};
					DataTypeEnum? avmDataType = avmCADParameter.Value.DataType;
					if (avmCADParameter.Value.DataTypeSpecified == false)
					{
						avmDataType = null;
						var avmValue = avmCADParameter.Value;
						while (avmValue.ValueExpression != null && avmValue.ValueExpression is DerivedValue)
						{
							DerivedValue avmDerivedValue = (DerivedValue)avmValue.ValueExpression;
							KeyValuePair<ValueNode, object> avmValueSource;
							if (!_avmValueNodeIDMap.TryGetValue(avmDerivedValue.ValueSource, out avmValueSource))
							{
								throw new ApplicationException(String.Format("Value source '{0}' is not defined for CADParameter '{1}'",
									avmDerivedValue.ValueSource, avmCADParameter.Name));
							}
							// If the ValueSource is a Value object, we'll take its DataType
							if (avmValueSource.Key is avm.Value)
							{
								var avmValueSourceTarget = avmValueSource.Key as avm.Value;
								if (avmValueSourceTarget.DataTypeSpecified)
								{
									avmDataType = avmValueSourceTarget.DataType;
									break;
								}
								avmValue = avmValueSourceTarget;
							}
						}
						if (avmDataType == null)
						{
							throw new ApplicationException(String.Format("DataType is not specified for {0}", avmCADParameter.Name));
						}
					}
					cyPhyMLCADParameter.Attributes.CADParameterType = d_AVMParamType_to_CADParamType[avmDataType.Value];

					if (!String.IsNullOrWhiteSpace(avmCADParameter.Value.Unit))
					{
						if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmCADParameter.Value.Unit))
						{
							cyPhyMLCADParameter.Referred.unit = _unitSymbolCyPhyMLUnitMap[avmCADParameter.Value.Unit];
						}
						else
						{
							writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmCADParameter.Value.Unit), MessageType.WARNING);
						}
					}
				}
				if (avmCADParameter.Value.ValueExpression is avm.FixedValue)
				{
					cyPhyMLCADParameter.Attributes.Value = ((avm.FixedValue)avmCADParameter.Value.ValueExpression).Value;
				}
				
				registerValueNode(avmCADParameter.Value, avmCADParameter);
			}

			foreach (avm.cad.Datum avmCADDatum in avmCADModel.Datum) {
				string avmDatumTypeName = avmCADDatum.GetType().ToString();
				if (!_cyPhyMLNameCreateMethodMap.ContainsKey(avmDatumTypeName)) {
					writeMessage("WARNING:  No way to create CyPhyML object from \"" + avmDatumTypeName + "\" avm datum.", MessageType.WARNING);
					continue;
				}

				CyPhyML.CADDatum cyPhyMLCADDatum = null;
				_cyPhyMLNameCreateMethodMap[avmDatumTypeName].call(cyPhyMLCADModel, out cyPhyMLCADDatum);

				_avmCyPhyMLObjectMap.Add(avmCADDatum, cyPhyMLCADDatum);

				registerPort(avmCADDatum);

				if (avmCADDatum is avm.cad.Plane) {
					//cyPhyMLCADDatum
				}

				// If the XML has a name, use that. Otherwise, use the datum name.
				if (!String.IsNullOrWhiteSpace(avmCADDatum.Name))
					cyPhyMLCADDatum.Name = avmCADDatum.Name;
				else
					cyPhyMLCADDatum.Name = avmCADDatum.DatumName;

				cyPhyMLCADDatum.Attributes.DatumName = avmCADDatum.DatumName;
				cyPhyMLCADDatum.Attributes.Definition = avmCADDatum.Definition;
				cyPhyMLCADDatum.Attributes.DefinitionNotes = avmCADDatum.Notes;
				cyPhyMLCADDatum.Attributes.InstanceNotes = avmCADDatum.Notes;
				cyPhyMLCADDatum.Attributes.ID = avmCADDatum.ID;

				foreach (avm.cad.Metric avmCADMetric in avmCADDatum.DatumMetric) {
					registerValueNode(avmCADMetric.Value, avmCADMetric);
				}
			}

			try
			{
				CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLCADModel);
			} catch (Exception)
			{
				// snyako: this call fails
				// ...
			}

			return cyPhyMLCADModel;
		}


		private void process(avm.manufacturing.ManufacturingModel avmManufacturingModel) {

			CyPhyML.ManufacturingModel cyPhyMLManufacturingModel = CyPhyMLClasses.ManufacturingModel.Create(_cyPhyMLComponent);

			_avmCyPhyMLObjectMap.Add(avmManufacturingModel, cyPhyMLManufacturingModel);

            cyPhyMLManufacturingModel.Name = string.IsNullOrWhiteSpace(avmManufacturingModel.Name) ? "ManufacturingModel" : avmManufacturingModel.Name;
			cyPhyMLManufacturingModel.Attributes.Author = avmManufacturingModel.Author;
			cyPhyMLManufacturingModel.Attributes.Notes = avmManufacturingModel.Notes;

			foreach (avm.manufacturing.Parameter avmManufacturingModelParameter in avmManufacturingModel.Parameter) {

				CyPhyML.ManufacturingModelParameter cyPhyMLManufacturingModelParameter = CyPhyMLClasses.ManufacturingModelParameter.Create(cyPhyMLManufacturingModel);
                cyPhyMLManufacturingModelParameter.Name = avmManufacturingModelParameter.Name;
                cyPhyMLManufacturingModelParameter.Attributes.Notes = avmManufacturingModelParameter.Notes;

                _avmCyPhyMLObjectMap.Add(avmManufacturingModelParameter, cyPhyMLManufacturingModelParameter);
                registerValueNode(avmManufacturingModelParameter.Value, avmManufacturingModelParameter);

                if (avmManufacturingModelParameter.Value != null)
                {
                    if (!String.IsNullOrWhiteSpace(avmManufacturingModelParameter.Value.Unit))
                    {
                        if (_unitSymbolCyPhyMLUnitMap.ContainsKey(avmManufacturingModelParameter.Value.Unit))
                        {
                            cyPhyMLManufacturingModelParameter.Referred.unit = _unitSymbolCyPhyMLUnitMap[avmManufacturingModelParameter.Value.Unit];
                        }
                        else
                        {
                            writeMessage(String.Format("WARNING: No unit lib match found for: {0}", avmManufacturingModelParameter.Value.Unit), MessageType.WARNING);
                        }
                    }
                }
			}

			CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutChildrenByName(cyPhyMLManufacturingModel);
		}

        private void processResources() {
			foreach (avm.DomainModel avmDomainModel in _avmDomainModelSet) {
				if (_avmCyPhyMLObjectMap.ContainsKey(avmDomainModel)) {
					CyPhyML.DomainModel cyPhyMLDomainModel = _avmCyPhyMLObjectMap[avmDomainModel] as CyPhyML.DomainModel;
					string usesResource = avmDomainModel.UsesResource;
					if ( !String.IsNullOrWhiteSpace(usesResource) && _avmResourceIDMap.ContainsKey(usesResource)) {
						avm.Resource avmResource = _avmResourceIDMap[usesResource];
						if ( _avmCyPhyMLObjectMap.ContainsKey( avmResource )) {
							CyPhyMLClasses.UsesResource.Connect(cyPhyMLDomainModel, _avmCyPhyMLObjectMap[avmResource] as CyPhyML.Resource, parent: (CyPhyML.Component)null);
							if (cyPhyMLDomainModel is CyPhyML.CADModel)
							{
								var cyPhyCadModel = (CyPhyML.CADModel)cyPhyMLDomainModel;
								if (avmResource.Path.EndsWith(".asm"))
								{
									cyPhyCadModel.Attributes.FileType = CyPhyMLClasses.CADModel.AttributesClass.FileType_enum.Assembly;
								}
							}
						}
					}
				}
			}
		}

		private void setSupercedes(List<string> supercedes)
        {
            if (supercedes == null)
                return;

			String s_Supercedes = "";
			foreach (var id in supercedes)
			{
				if (String.IsNullOrWhiteSpace(s_Supercedes))
					s_Supercedes = id;
				else
					s_Supercedes +='\n' + id;
			}

			_cyPhyMLComponent.Attributes.Supercedes = s_Supercedes;
		}

		public CyPhyML.Component AVM2CyPhyMLNonStatic( avm.Component avmComponent ) {

			SetComponentName( avmComponent.Name );
			SetComponentId(avmComponent.ID);
			if ( ! String.IsNullOrEmpty(avmComponent.Version) )
				_cyPhyMLComponent.Attributes.Version = avmComponent.Version;
			setClassifications( avmComponent.Classifications );
			setSupercedes(avmComponent.Supercedes);

			foreach (avm.Property avmProperty in avmComponent.Property) {
				process(avmProperty);
			}

			foreach (avm.Port avmPort in avmComponent.Port) {
				process(avmPort);
			}

			foreach (avm.Resource avmResource in avmComponent.ResourceDependency) {
				process(avmResource);
			}

			foreach (avm.Connector avmConnector in avmComponent.Connector) {
				process(avmConnector);
			}

			foreach (avm.DistributionRestriction avmDistributionRestriction in avmComponent.DistributionRestriction) {
				process(avmDistributionRestriction);
			}

			foreach (avm.DomainModel avmDomainModel in avmComponent.DomainModel) {
				_avmDomainModelSet.Add(avmDomainModel);
			}

			foreach (avm.modelica.ModelicaModel avmModelicaModel in avmComponent.DomainModel.OfType<avm.modelica.ModelicaModel>()) {
				process(avmModelicaModel);
			}

            foreach (avm.cyber.CyberModel avmCyberModel in avmComponent.DomainModel.OfType<avm.cyber.CyberModel>()) {
                process(avmCyberModel);
            }

			foreach (avm.cad.CADModel avmCADModel in avmComponent.DomainModel.OfType<avm.cad.CADModel>()) {
				process(avmCADModel);
			}

			foreach (avm.manufacturing.ManufacturingModel avmManufacturingModel in avmComponent.DomainModel.OfType<avm.manufacturing.ManufacturingModel>()) {
				process(avmManufacturingModel);
			}

			foreach (var avmEdaModel in avmComponent.DomainModel
											        .OfType<avm.schematic.eda.EDAModel>())
			{
                process(avmEdaModel);
			}

            foreach (var avmSpiceModel in avmComponent.DomainModel
                                                      .OfType<avm.schematic.spice.SPICEModel>())
            {
                process(avmSpiceModel);
            }

			foreach (var avmSystemCModel in avmComponent.DomainModel
														.OfType<avm.systemc.SystemCModel>())
			{
				process(avmSystemCModel);
            }

            foreach (var avmRFModel in avmComponent.DomainModel
                                                   .OfType<avm.rf.RFModel>())
            {
                process(avmRFModel);
            }
			
			foreach (var simpleFormula in avmComponent.Formula.OfType<avm.SimpleFormula>()) {
				process(simpleFormula);
			}

			foreach (var complexFormula in avmComponent.Formula.OfType<avm.ComplexFormula>()) {
				process(complexFormula);
			}

			processPorts();
			processValues();
			processResources();

            DoLayout();
            if (!this.aMemberHasLayoutData)
            {
                CyPhy2ComponentModel.CyPhyComponentAutoLayout.LayoutComponent(_cyPhyMLComponent);
            }

			_cyPhyMLComponent.RunFormulaEvaluator();

			return _cyPhyMLComponent;
		}

		public static CyPhyML.Component AVM2CyPhyML(CyPhyML.ComponentAssembly cyPhyMLComponentParent, avm.Component avmComponent, bool resetUnitLib = true, object messageConsole = null)
		{
			CyPhyMLComponentBuilder cyPhyMLComponentBuilder = new CyPhyMLComponentBuilder(cyPhyMLComponentParent, resetUnitLib, messageConsole);
			return cyPhyMLComponentBuilder.AVM2CyPhyMLNonStatic( avmComponent );
		}

		public static CyPhyML.Component AVM2CyPhyML(CyPhyML.Components cyPhyMLComponentParent, avm.Component avmComponent, bool resetUnitLib = true, object messageConsole = null)
		{
			CyPhyMLComponentBuilder cyPhyMLComponentBuilder = new CyPhyMLComponentBuilder(cyPhyMLComponentParent, resetUnitLib, messageConsole);
			return cyPhyMLComponentBuilder.AVM2CyPhyMLNonStatic( avmComponent );
		}
    }
}