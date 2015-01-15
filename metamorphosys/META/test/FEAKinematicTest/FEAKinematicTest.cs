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
using Xunit;
using System.IO;
using System.Diagnostics;

namespace FEAKinematicTest
{
    public class FEAKinematicTest : IUseFixture<FEAKinematicTest.AssemblyAdamsFixture>
    {
        AssemblyAdamsFixture fixture;

        public class AssemblyAdamsFixture
        {
            public readonly string createAssemblyExe;
            public readonly string AdamsScript;
            public readonly string AdamsBat;
            public readonly string FeaScript;

            public AssemblyAdamsFixture()
            {
                string proeIsisExtensionsDir = System.Environment.GetEnvironmentVariable("PROE_ISIS_EXTENSIONS");
                string adamsDir = System.Environment.GetEnvironmentVariable("ADAMS_PATH");
                createAssemblyExe = Path.Combine(proeIsisExtensionsDir ?? "", "bin", "CADCreoParametricCreateAssembly.exe");
                AdamsScript = Path.Combine(proeIsisExtensionsDir ?? "", "bin", "Adams", "CreateAdamsModel.py");
                FeaScript = Path.Combine(proeIsisExtensionsDir ?? "", "bin", "Abaqus", "AbaqusMain.py");
                AdamsBat = Path.Combine(adamsDir ?? "", "bin", "adams2013_2_x64.bat");
                if (File.Exists(createAssemblyExe) == false)
                {
                    throw new FileNotFoundException("CADCreoParametricCreateAssembly.exe is not installed.");
                }
                if (File.Exists(AdamsScript) == false)
                {
                    throw new FileNotFoundException("CreateAdamsModel.py is not installed.");
                }
            }
        }

        private bool RunProcess(string exec, string args, string workingdir, out int exitcode, int timeout = 45000)
        {
            ProcessStartInfo info = new ProcessStartInfo()
            {
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                RedirectStandardInput = false,
                UseShellExecute = false,
                WindowStyle = ProcessWindowStyle.Normal,
                CreateNoWindow = false,
                FileName = exec,
                Arguments = args,
                WorkingDirectory = workingdir
            };

            Process process = new Process();
            process.StartInfo = info;

            process.Start();

            bool exited = process.WaitForExit(timeout);
            if (!exited)
            {
                process.Kill();
                process.WaitForExit();
            }
            exitcode = process.ExitCode;

            return exited;
        }

        [Fact]
        public void KinematicTB_4Bar()
        {
            CyPhyPropagateTest.MetaLinkCreoTest.KillCreo();
            string XmePath = Path.GetFullPath(@"..\..\..\..\models\MBD\MBD.xme");
            string TestbenchPath = "/@Testing|kind=Testing|relpos=0/@Kinematic_FourBar|kind=KinematicTestBench|relpos=0";
            string OutputDir = Path.Combine(Path.GetDirectoryName(XmePath), "Kinematic_FourBar");

            bool status = CADTeamTest.CyPhy2CADRun.Run(OutputDir, XmePath, TestbenchPath, true);
            Assert.True(File.Exists(Path.Combine(OutputDir, CADTeamTest.CADTests.generatedAsmFile)), "Failed to generate " + CADTeamTest.CADTests.generatedAsmFile);
            Assert.True(File.Exists(Path.Combine(OutputDir, CADTeamTest.CADTests.generatedMBDFile)), "Failed to generate " + CADTeamTest.CADTests.generatedMBDFile);

            int exitcode;

            Assert.True(RunProcess(fixture.createAssemblyExe, "-w . -i CADAssembly.xml", OutputDir, out exitcode));

            Assert.Equal(exitcode, 0);
            Assert.True(CADCreoTest.Cyphy2CADCreoTest.VerifyCADAssemblerLog(Path.Combine(OutputDir, "log", "cad-assembler.log")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "systemundertest_1.asm.2")));
            //Assert.True(File.Exists(Path.Combine(OutputDir, "PARASOLID", "SystemUnderTest_1_asm.x_t")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "ComputedValues.xml")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "CADAssembly_metrics.xml")));

            Assert.True(RunProcess(@"c:\Python27\python.exe", "\""+fixture.AdamsScript+"\"", OutputDir, out exitcode));

            Assert.Equal(exitcode, 0);
            Assert.True(File.Exists(Path.Combine(OutputDir, "adams_output.cmd")));

            Assert.True(RunProcess(fixture.AdamsBat, "aview ru-st b adams_output.cmd", OutputDir, out exitcode));

            // Verify the LODs based on the CADAssembly.xml
            //Assert.True(File.Exists(Path.Combine(OutputDir, "LT_{20a7f644-93b4-4671-9e2c-47e1ee5db150}.lod")));
            //Assert.True(File.Exists(Path.Combine(OutputDir, "LT_{529f6c29-efea-44e3-ba79-dc01afcd3a3d}.lod")));
            //Assert.True(File.Exists(Path.Combine(OutputDir, "LT_{82becddd-722a-4fe1-a072-edd655b2c082}.lod")));
            //Assert.True(File.Exists(Path.Combine(OutputDir, "LT_{9cabe073-a5c4-481b-a83d-2ddaf469edb3}.lod")));

        }


        //[Fact]
        public void FEATB_4Bar()
        {
            CyPhyPropagateTest.MetaLinkCreoTest.KillCreo();

            string XmePath = Path.GetFullPath(@"..\..\..\..\models\MBD\MBD.xme");
            string TestbenchPath = "/@Testing|kind=Testing|relpos=0/@FEA_Fourbar|kind=CADTestBench|relpos=0";
            string OutputDir = Path.Combine(Path.GetDirectoryName(XmePath), "FEA_FourBar");

            bool status = CADTeamTest.CyPhy2CADRun.Run(OutputDir, XmePath, TestbenchPath, true);
            Assert.True(File.Exists(Path.Combine(OutputDir, CADTeamTest.CADTests.generatedAsmFile)), "Failed to generate " + CADTeamTest.CADTests.generatedAsmFile);

            int exitcode;

            Assert.True(RunProcess(fixture.createAssemblyExe, "-w . -i CADAssembly.xml", OutputDir, out exitcode));

            Assert.Equal(exitcode, 0);
            Assert.True(CADCreoTest.Cyphy2CADCreoTest.VerifyCADAssemblerLog(Path.Combine(OutputDir, "log", "cad-assembler.log")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "fea_fourbar_1.asm.2")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "ComputedValues.xml")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "CADAssembly_metrics.xml")));

            Assert.True(RunProcess(@"c:\SIMULIA\Abaqus\Commands\abaqus.bat", "cae noGUI=" + "\""+fixture.FeaScript+"\"", OutputDir, out exitcode, 1200000));

            Assert.True(exitcode == 0);
        }

        //[Fact]
        public void FEAKinematicTB_4Bar()
        {
            KinematicTB_4Bar();

            string XmePath = Path.GetFullPath(@"..\..\..\..\models\MBD\MBD.xme");
            string TestbenchPath = "/@Testing|kind=Testing|relpos=0/@FEA_Fourbar|kind=CADTestBench|relpos=0";
            string OutputDir = Path.Combine(Path.GetDirectoryName(XmePath), "Kinematic_FourBar");

            bool status = CADTeamTest.CyPhy2CADRun.Run(OutputDir, XmePath, TestbenchPath, false, false);
            Assert.True(File.Exists(Path.Combine(OutputDir, CADTeamTest.CADTests.generatedAsmFile)), "Failed to generate " + CADTeamTest.CADTests.generatedAsmFile);

            int exitcode;

            Assert.True(RunProcess(fixture.createAssemblyExe, "-w . -i CADAssembly.xml", OutputDir, out exitcode));

            Assert.Equal(exitcode, 0);
            Assert.True(CADCreoTest.Cyphy2CADCreoTest.VerifyCADAssemblerLog(Path.Combine(OutputDir, "log", "cad-assembler.log")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "fea_fourbar_1.asm.2")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "ComputedValues.xml")));
            Assert.True(File.Exists(Path.Combine(OutputDir, "CADAssembly_metrics.xml")));

            Assert.True(RunProcess(@"c:\SIMULIA\Abaqus\Commands\abaqus.bat", "cae noGUI=" + "\"" + fixture.FeaScript + "\"", OutputDir, out exitcode, 120000));

            Assert.True(exitcode == 0);
        }

        public void SetFixture(FEAKinematicTest.AssemblyAdamsFixture data)
        {
            this.fixture = data;
        }

    }
}