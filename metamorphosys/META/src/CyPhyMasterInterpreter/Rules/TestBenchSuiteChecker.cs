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
using System.Linq;
using System.Text;
using CyPhy = ISIS.GME.Dsml.CyPhyML.Interfaces;
using CyPhyClasses = ISIS.GME.Dsml.CyPhyML.Classes;

namespace CyPhyMasterInterpreter.Rules
{

    public class TestBenchSuiteChecker : ContextChecker
    {
        public CyPhy.TestBenchSuite testBenchSuite { get; set; }

        public TestBenchSuiteChecker(CyPhy.TestBenchSuite testBenchSuite)
        {
            this.testBenchSuite = testBenchSuite;
        }

        public override GME.MGA.IMgaModel GetContext()
        {
            return this.testBenchSuite.Impl as GME.MGA.IMgaModel;
        }

        public override void CheckNoThrow()
        {
            base.CheckNoThrow();
            
            this.m_details.AddRange(this.TestBenchReferences());
        }

        protected IEnumerable<ContextCheckerResult> TestBenchReferences()
        {
            List<ContextCheckerResult> results = new List<ContextCheckerResult>();

            // at least one test bench ref
            if (this.testBenchSuite.Children.TestBenchRefCollection.Any())
            {
                var feedback = new ContextCheckerResult()
                {
                    Success = true,
                    Subject = this.testBenchSuite.Impl,
                    Message = "Test bench suite has at least one test bench reference."
                };

                results.Add(feedback);

                var ids = this.testBenchSuite
                    .Children
                    .TestBenchRefCollection
                    .Where(x => (x.Impl as GME.MGA.IMgaReference).Referred != null)
                    .Select(x => (x.Impl as GME.MGA.IMgaReference).Referred.ID)
                    .ToList();

                if (ids.Count != ids.Distinct().Count())
                {
                    feedback = new ContextCheckerResult()
                    {
                        Success = false,
                        Subject = this.testBenchSuite.Impl,
                        Message = "One test bench can be used only once. Remove the duplicates."
                    };

                    results.Add(feedback);
                }
                else
                {
                    feedback = new ContextCheckerResult()
                    {
                        Success = true,
                        Subject = this.testBenchSuite.Impl,
                        Message = "Each test bench used only once."
                    };

                    results.Add(feedback);
                }
            }
            else
            {
                var feedback = new ContextCheckerResult()
                {
                    Success = false,
                    Subject = this.testBenchSuite.Impl,
                    Message = "Test bench suite has no test bench reference. It must have at least one test bench reference."
                };

                results.Add(feedback);
            }

            CyPhy.DesignEntity designEntity = null;

            // no null refs
            foreach (var testBenchRef in this.testBenchSuite.Children.TestBenchRefCollection)
            {
                // check test benches
                if (testBenchRef.AllReferred == null)
                {
                    var feedback = new ContextCheckerResult()
                    {
                        Success = false,
                        Subject = testBenchRef.Impl,
                        Message = "Test bench reference cannot be null."
                    };

                    results.Add(feedback);

                    continue;
                }
                else if ((testBenchRef.AllReferred is CyPhy.TestBenchType) == false)
                {
                    var feedback = new ContextCheckerResult()
                    {
                        Success = false,
                        Subject = testBenchRef.Impl,
                        Message = "Currently only Test Bench Types are allowed."
                    };

                    results.Add(feedback);

                    continue;
                }
                else
                {
                    var feedback = new ContextCheckerResult()
                    {
                        Success = true,
                        Subject = testBenchRef.Impl,
                        Message = "Test bench reference is not null."
                    };

                    results.Add(feedback);
                }

                var testBench = testBenchRef.AllReferred as CyPhy.TestBenchType;

                // testbench ref is NOT null at this point
                ContextChecker testBenchChecker = ContextChecker.GetContextChecker(testBench.Impl as GME.MGA.MgaModel);

                testBenchChecker.TryCheck();

                results.AddRange(testBenchChecker.Details);

                // check top level system under test pointers
                var tlsut = testBench.Children.TopLevelSystemUnderTestCollection.FirstOrDefault();
                
                if (tlsut != null &&
                    tlsut.Referred.DesignEntity != null)
                {
                    if (designEntity == null)
                    {
                        designEntity = tlsut.Referred.DesignEntity;
                    }
                    else
                    {
                        if (designEntity.Impl.ID == tlsut.Referred.DesignEntity.ID)
                        {
                            var feedback = new ContextCheckerResult()
                            {
                                Success = true,
                                Subject = testBenchRef.Impl,
                                Message = "Test bench is defined for the same design or design space."
                            };

                            results.Add(feedback);
                        }
                        else
                        {
                            var feedback = new ContextCheckerResult()
                            {
                                Success = false,
                                Subject = testBenchRef.Impl,
                                Message = "Test bench does not point to the same design space."
                            };

                            results.Add(feedback);
                        }
                    }
                }
            }

            return results;
        }
    }
}