﻿// -----------------------------------------------------------------------
// <copyright file="VersionInfo.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace META
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.IO;
    using Microsoft.Win32;
    using System.Diagnostics;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public static class VersionInfo
    {
        private const string unknown = "UNKNOWN";

        private static string m_CyPhyMLGuid = string.Empty;
        private static string m_CyPhyML = string.Empty;
        private static string m_MetaVersion = string.Empty;
        private static string m_GmeVersion = string.Empty;
        private static string m_MetaPath = string.Empty;
        private static string m_DashboardPath = string.Empty;

        private static string m_ProeISISExtPath = string.Empty;
        private static string m_ProeISISExtVer = string.Empty;

        private static string m_PythonVEnvScriptsPath = string.Empty;
        private static string m_PythonVEnvPath = string.Empty;
        private static string m_PythonVEnvExe = string.Empty;
        private static string m_PythonVEnvActivate = string.Empty;
        private static string m_PythonVersion = string.Empty;
        private static string m_PythonExe = string.Empty;


        public static string CyPhyMLGuid
        {
            get
            {
                if (string.IsNullOrEmpty(m_CyPhyMLGuid))
                {
                    // HKEY_CURRENT_USER\Software\GME\Paradigms\CyPhyML
                    var baseKey = RegistryKey.OpenBaseKey(
                        RegistryHive.CurrentUser,
                        RegistryView.Registry64);

                    var subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");

                    if (subKey == null)
                    {
                        baseKey = RegistryKey.OpenBaseKey(
                            RegistryHive.LocalMachine,
                            RegistryView.Registry64);

                        subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");
                    }

                    if (subKey == null)
                    {
                        baseKey = RegistryKey.OpenBaseKey(
                            RegistryHive.CurrentUser,
                            RegistryView.Registry32);

                        subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");
                    }

                    if (subKey == null)
                    {
                        baseKey = RegistryKey.OpenBaseKey(
                            RegistryHive.LocalMachine,
                            RegistryView.Registry32);

                        subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");
                    }

                    string value = @"CurrentVersion";
                    m_CyPhyMLGuid = (string)subKey.GetValue(value, unknown);
                }

                return m_CyPhyMLGuid;
            }
        }

        public static string CyPhyML
        {
            get
            {
                if (string.IsNullOrEmpty(m_CyPhyML))
                {
                    // HKEY_CURRENT_USER\Software\GME\Paradigms\CyPhyML
                    string versionGuid = CyPhyMLGuid;
                    string version = unknown;

                    // FIXME: Use GME to get the Version string...
                    // HKEY_CURRENT_USER\Software\GME\Paradigms\CyPhyML
                    var baseKey = RegistryKey.OpenBaseKey(
                        RegistryHive.CurrentUser,
                        RegistryView.Registry64);

                    var subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");

                    if (subKey == null)
                    {
                        baseKey = RegistryKey.OpenBaseKey(
                            RegistryHive.LocalMachine,
                            RegistryView.Registry64);

                        subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");
                    }

                    if (subKey == null)
                    {
                        baseKey = RegistryKey.OpenBaseKey(
                            RegistryHive.CurrentUser,
                            RegistryView.Registry32);

                        subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");
                    }

                    if (subKey == null)
                    {
                        baseKey = RegistryKey.OpenBaseKey(
                            RegistryHive.LocalMachine,
                            RegistryView.Registry32);

                        subKey = baseKey.OpenSubKey(@"Software\GME\Paradigms\CyPhyML");
                    }

                    if (subKey != null)
                    {
                        foreach (var item in subKey.GetValueNames())
                        {
                            if (item != "CurrentVersion" &&
                                (subKey.GetValue(item) as string) == versionGuid)
                            {
                                version = item;
                                break;
                            }
                        }
                    }
                    m_CyPhyML = version;
                }
                return m_CyPhyML;
            }
        }

        /// <summary>
        /// Gets Meta path from the registry
        /// </summary>
        public static string MetaVersion
        {
            get
            {
                if (string.IsNullOrEmpty(m_MetaVersion))
                {
                    var version = GetVersion("META toolchain");

                    if (version == unknown &&
                        Directory.Exists(MetaPath))
                    {
                        ProcessStartInfo psi = new ProcessStartInfo()
                        {
                            Arguments = "info",
                            CreateNoWindow = true,
                            FileName = "svn",
                            RedirectStandardOutput = true,
                            UseShellExecute = false,
                            WorkingDirectory = MetaPath,
                        };
                        try
                        {
                            Process p = Process.Start(psi);
                            p.WaitForExit();
                            if (p.ExitCode == 0)
                            {
                                var infoXml = p.StandardOutput.ReadToEnd();
                                version = infoXml;
                            }
                        }
                        catch (System.ComponentModel.Win32Exception)
                        {
                            // SVN doesn't exist. It's okay, let's just move along. 
                            version = "META is not installed. Source code is NOT under subversion OR command line svn client is not installed! META TOOLS MIGHT NOT BE FULLY FUNCTIONAL.";
                        }

                    }
                    m_MetaVersion = version;
                }
                return m_MetaVersion;
            }
        }

        /// <summary>
        /// Gets Meta path from the registry
        /// </summary>
        public static string GmeVersion
        {
            get
            {
                if (string.IsNullOrEmpty(m_GmeVersion))
                {
                    m_GmeVersion = GetVersion("GME (64 bit)") != unknown ?
                       GetVersion("GME (64 bit)") :
                       GetVersion("GME");
                }
                return m_GmeVersion;
            }
        }

        /// <summary>
        /// Gets Meta path from the registry
        /// </summary>
        public static string MetaPath
        {
            get
            {
                if (string.IsNullOrEmpty(m_MetaPath))
                {
                    string keyName = @"HKEY_LOCAL_MACHINE\Software\META";
                    string value = @"META_PATH";

                    m_MetaPath = (string)Registry.GetValue(
                        keyName,
                        value,
                        unknown);
                }
                return m_MetaPath;
            }
        }

        /// <summary>
        /// returns with the virtual python environment's Scripts folder
        /// </summary>
        public static string DashboardPath
        {
            get
            {
                if (string.IsNullOrEmpty(m_DashboardPath))
                {
                    m_DashboardPath = Path.Combine(
                        MetaPath,
                        "bin",
                        "dashboard");
                }

                return m_DashboardPath;
            }
        }

        /// <summary>
        /// returns with the virtual python environment's Scripts folder
        /// </summary>
        public static string PythonVEnvScriptsPath
        {
            get
            {
                if (string.IsNullOrEmpty(m_PythonVEnvPath))
                {
                    m_PythonVEnvPath = Path.Combine(
                        MetaPath,
                        "bin",
                        "Python27",
                        "Scripts");
                }
                return m_PythonVEnvPath;
            }
        }

        /// <summary>
        /// returns the virtual python environment's toplevel folder
        /// </summary>
        public static string PythonVEnvPath
        {
            get
            {
                return Path.Combine(
                    MetaPath,
                    "bin",
                    "Python27");
            }
        }

        /// <summary>
        /// returns with the virtual python environment's python.exe
        /// (currently META_PATH\bin\Python27\scripts\python.exe)
        /// </summary>
        public static string PythonVEnvExe
        {
            get
            {
                if (string.IsNullOrEmpty(m_PythonVEnvExe))
                {
                    m_PythonVEnvExe = Path.Combine(PythonVEnvScriptsPath, "python.exe");
                }
                return m_PythonVEnvExe;
            }
        }

        /// <summary>
        /// returns with the virtual python environment's activate.bat
        /// </summary>
        public static string PythonVEnvActivate
        {
            get
            {
                if (string.IsNullOrEmpty(m_PythonVEnvActivate))
                {
                    m_PythonVEnvActivate = Path.Combine(
                        PythonVEnvScriptsPath,
                        "activate.bat");
                }
                return m_PythonVEnvActivate;
            }
        }

        public static string PythonExe
        {
            get
            {
                if (string.IsNullOrEmpty(m_PythonExe) == false &&
                    m_PythonExe != unknown)
                {
                    return m_PythonExe;
                }

                m_PythonExe = unknown;

                // Get the system python based on .py file association
                RegistryKey baseRegistryKey = RegistryKey.OpenBaseKey(RegistryHive.ClassesRoot, RegistryView.Default);
                string subKey = @"Python.File\shell\open\command";
                RegistryKey systemPython = baseRegistryKey.OpenSubKey(subKey);
                if (systemPython != null)
                {
                    m_PythonExe = systemPython.GetValue("") as string;
                }

                return m_PythonExe;
            }
        }

        public static string PythonVersion
        {
            get
            {
                if (string.IsNullOrEmpty(m_PythonVersion) == false &&
                    m_PythonVersion != unknown)
                {
                    return m_PythonVersion;
                }

                m_PythonVersion = unknown;

                string pythonDllPath = Path.Combine(
                    Environment.GetEnvironmentVariable("windir"),
                    "SysWOW64",
                    "python27.dll");

                if (File.Exists(pythonDllPath))
                {
                    m_PythonVersion = string.Format("{0} {1} {2}",
                        pythonDllPath,
                        FileVersionInfo.GetVersionInfo(pythonDllPath).ProductVersion,
                        GetDllMachineType(pythonDllPath));
                }

                return m_PythonVersion;
            }
        }

        public static string ProeISISExtPath
        {
            get
            {
                if (string.IsNullOrEmpty(m_ProeISISExtPath))
                {
                    m_ProeISISExtPath = unknown;
                    // GET PATH
                    //Env variable
                    //PROE_ISIS_EXTENSIONS
                    string assumedPath = Environment.GetEnvironmentVariable("PROE_ISIS_EXTENSIONS");

                    if (string.IsNullOrEmpty(assumedPath))
                    {
                        //EXE in SVN
                        //META_SVN\trunk\deploy\CAD_Installs\Proe ISIS Extensions\bin\CADCreoParametricCreateAssembly.exe
                        assumedPath = Path.Combine(
                            MetaPath,
                            "deploy",
                            "CAD_Installs",
                            "Proe ISIS Extensions",
                            "bin",
                            "CADCreoParametricCreateAssembly.exe");

                        if (File.Exists(assumedPath))
                        {
                            m_ProeISISExtPath = assumedPath;
                        }
                    }
                    else
                    {
                        assumedPath = Path.Combine(
                            assumedPath,
                            "bin",
                            "CADCreoParametricCreateAssembly.exe");

                        if (File.Exists(assumedPath))
                        {
                            m_ProeISISExtPath = assumedPath;
                        }
                    }
                }

                return m_ProeISISExtPath;
            }
        }

        public static string ProeISISExtVer
        {
            get
            {
                if (string.IsNullOrEmpty(m_ProeISISExtVer))
                {
                    m_ProeISISExtVer = unknown;
                    if (ProeISISExtPath != unknown)
                    {
                        m_ProeISISExtVer = FileVersionInfo.
                            GetVersionInfo(ProeISISExtPath).ProductVersion;
                    }
                }
                return m_ProeISISExtVer;
            }
        }


        private static string GetVersion(string productName)
        {
            // TODO: do this in the right way
            string product_version = unknown;

            string subKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall";
            using (RegistryKey baseRegistryKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32))
            using (RegistryKey uninstallKey = baseRegistryKey.OpenSubKey(subKey))
            foreach (var applicationSubKeyName in uninstallKey.GetSubKeyNames())
            {
                RegistryKey appKey = baseRegistryKey.OpenSubKey(subKey + "\\" + applicationSubKeyName);
                using (appKey)
                {
                    string appName = appKey.GetValue("DisplayName", "").ToString();

                    if (appName == productName)
                    {
                        string appVersion = appKey.GetValue("DisplayVersion").ToString();
                        product_version = appVersion;
                    }
                }
            }

            if (product_version == unknown)
            {
                subKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall";
                using (RegistryKey baseRegistryKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64))
                using (RegistryKey uninstallKey = baseRegistryKey.OpenSubKey(subKey))
                {
                    foreach (var applicationSubKeyName in uninstallKey.GetSubKeyNames())
                    {
                        RegistryKey appKey = baseRegistryKey.OpenSubKey(subKey + "\\" + applicationSubKeyName);
                        using (appKey)
                        {
                            string appName = appKey.GetValue("DisplayName", "").ToString();

                            if (appName == productName)
                            {
                                string appVersion = appKey.GetValue("DisplayVersion").ToString();
                                product_version = appVersion;
                            }
                        }
                    }
                }
            }

            return product_version;
        }

        public static MachineType GetDllMachineType(string dllPath)
        {
            // source with some modifications: http://stackoverflow.com/questions/1001404/check-if-unmanaged-dll-is-32-bit-or-64-bit

            //see http://www.microsoft.com/whdc/system/platform/firmware/PECOFF.mspx
            //offset to PE header is always at 0x3C
            //PE header starts with "PE\0\0" =  0x50 0x45 0x00 0x00
            //followed by 2-byte machine type field (see document above for enum)

            MachineType machineType = MachineType.IMAGE_FILE_MACHINE_UNKNOWN;

            using (FileStream fs = new FileStream(dllPath, FileMode.Open, FileAccess.Read))
            using (BinaryReader br = new BinaryReader(fs))
            {
                fs.Seek(0x3c, SeekOrigin.Begin);
                Int32 peOffset = br.ReadInt32();
                fs.Seek(peOffset, SeekOrigin.Begin);
                UInt32 peHead = br.ReadUInt32();
                if (peHead != 0x00004550) // "PE\0\0", little-endian
                {
                    Trace.TraceError("Dll type: Can't find PE header for {0}", dllPath);
                }
                machineType = (MachineType)br.ReadUInt16();
            }

            return machineType;
        }

        public enum MachineType : ushort
        {
            IMAGE_FILE_MACHINE_UNKNOWN = 0x0,
            IMAGE_FILE_MACHINE_AM33 = 0x1d3,
            IMAGE_FILE_MACHINE_AMD64 = 0x8664,
            IMAGE_FILE_MACHINE_ARM = 0x1c0,
            IMAGE_FILE_MACHINE_EBC = 0xebc,
            IMAGE_FILE_MACHINE_I386 = 0x14c,
            IMAGE_FILE_MACHINE_IA64 = 0x200,
            IMAGE_FILE_MACHINE_M32R = 0x9041,
            IMAGE_FILE_MACHINE_MIPS16 = 0x266,
            IMAGE_FILE_MACHINE_MIPSFPU = 0x366,
            IMAGE_FILE_MACHINE_MIPSFPU16 = 0x466,
            IMAGE_FILE_MACHINE_POWERPC = 0x1f0,
            IMAGE_FILE_MACHINE_POWERPCFP = 0x1f1,
            IMAGE_FILE_MACHINE_R4000 = 0x166,
            IMAGE_FILE_MACHINE_SH3 = 0x1a2,
            IMAGE_FILE_MACHINE_SH3DSP = 0x1a3,
            IMAGE_FILE_MACHINE_SH4 = 0x1a6,
            IMAGE_FILE_MACHINE_SH5 = 0x1a8,
            IMAGE_FILE_MACHINE_THUMB = 0x1c2,
            IMAGE_FILE_MACHINE_WCEMIPSV2 = 0x169,
        }

        // returns true if the dll is 64-bit, false if 32-bit, and null if unknown
        public static bool? UnmanagedDllIs64Bit(string dllPath)
        {
            switch (GetDllMachineType(dllPath))
            {
                case MachineType.IMAGE_FILE_MACHINE_AMD64:
                case MachineType.IMAGE_FILE_MACHINE_IA64:
                    return true;
                case MachineType.IMAGE_FILE_MACHINE_I386:
                    return false;
                default:
                    return null;
            }
        }
    }
}
