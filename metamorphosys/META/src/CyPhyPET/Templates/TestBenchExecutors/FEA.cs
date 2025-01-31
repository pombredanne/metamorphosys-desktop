﻿// ------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version: 10.0.0.0
//  
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
// ------------------------------------------------------------------------------
namespace CyPhyPET.Templates.TestBenchExecutors
{
    using System;
    using System.IO;
    using System.Diagnostics;
    using System.Linq;
    using System.Xml.Linq;
    using System.Collections;
    using System.Collections.Generic;
    using ISIS.GME.Dsml.CyPhyML.Classes;
    
    
    #line 1 "C:\Users\snyako.ISIS\Desktop\META\src\CyPhyPET\Templates\TestBenchExecutors\FEA.tt"
    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.TextTemplating", "10.0.0.0")]
    public partial class FEA : FEABase
    {
        public virtual string TransformText()
        {
            this.Write(" \r\n");
            this.Write(" \r\n");
            this.Write("# ===========================================================================\r\n# " +
                    "Auto generated from FEA.tt\r\n# ==================================================" +
                    "=========================\r\n\"\"\"\r\nFunctions in this file are always called from th" +
                    "e TestBench directory. They must\r\nreturn from that directory (if there is an exc" +
                    "eption it does not matter).\r\n\"\"\"\r\nimport os\r\nimport subprocess\r\nimport logging\r\n" +
                    "import time\r\nimport xml.etree.ElementTree as ET\r\n# Throw this exeception for \"ex" +
                    "pected\" errors.\r\nfrom driver_runner import TestBenchExecutionError\r\n\r\n## This is" +
                    " the mapping of parameter names in the test-bench and the Name in CADAssembly.xm" +
                    "l\r\nparam_map = {\'ForceLoad\': \'x\'}\r\n\r\n## Maximum time in seconds to wait for each" +
                    " execution.\r\nMAX_WAIT_TIME = 3600\r\n\r\n\r\ndef initial_run():\r\n    \"\"\"\r\n    Setup wh" +
                    "atever needs to be setup once. Then execute a run once using the default paramet" +
                    "ers\r\n    in testbench_manifest.json. (These and their metrics will be saved and " +
                    "used in the final\r\n    testbench_manifest.json.\r\n    \"\"\"\r\n    log = logging.getL" +
                    "ogger()\r\n    log.info(\'Running initial run, calling exectute.\')\r\n    execute()\r\n" +
                    "\r\n\r\ndef update_parameters(parameters):\r\n    \"\"\"\r\n    Update parameters for the r" +
                    "un. (The parameters are already updated in testbench_manifest.json.)\r\n    :type " +
                    "parameters: dict\r\n    :param parameters: keys are name of Parameter and value is" +
                    " float.\r\n    \"\"\"\r\n    log = logging.getLogger()\r\n    log.info(\'About to update p" +
                    "arameters in CADAssembly.xml.\')\r\n    et = ET.parse(\'CADAssembly.xml\')\r\n    for k" +
                    "vp in parameters.iteritems():\r\n        if kvp[0] not in param_map:\r\n            " +
                    "log.warning(\'Parameter {} does not have a mapping to CADAssembly.xml\', kvp[0])\r\n" +
                    "        else:\r\n            parameter_name = param_map[kvp[0]]\r\n            param" +
                    "eter_value = kvp[1]\r\n            log.info(\'Parameter mapping found {} :-> {}\'.fo" +
                    "rmat(kvp[0], parameter_name))\r\n            cnt = _update_parameter(et, parameter" +
                    "_name, parameter_value)\r\n            log.info(\'Updated {} CADParameter(s) {} = {" +
                    "}\'.format(cnt, parameter_name, parameter_value))\r\n\r\n    et.write(\'CADAssembly.xm" +
                    "l\')\r\n    log.info(\'Wrote back to CADAssembly.xml\')\r\n\r\n\r\ndef execute():\r\n    \"\"\"\r" +
                    "\n    Execute the test-bench. A call to this function should update the metrics i" +
                    "n the testbench_manifest.json.\r\n    :rtype: dict or None\r\n    :return: Dictionar" +
                    "y with metrics names and values if testbench_manifest.json is not updated, else " +
                    "None.\r\n    \"\"\"\r\n    log = logging.getLogger()\r\n    cad_bat = \'runCADJob.bat\'\r\n  " +
                    "  out_put_file = \'PET_run.txt\'\r\n\r\n    if os.path.isfile(out_put_file):\r\n        " +
                    "os.remove(out_put_file)\r\n\r\n    log.info(\'About to call :: {}\'.format(os.path.abs" +
                    "path(cad_bat)))\r\n    was_killed = False\r\n    with open(out_put_file, \'w\') as f_o" +
                    "ut:\r\n        timer = 0\r\n        sim_process = subprocess.Popen(cad_bat, stdout=f" +
                    "_out, stderr=f_out)\r\n        while sim_process.poll() is None:\r\n            time" +
                    ".sleep(0.1)\r\n            timer += 0.1\r\n        if timer > MAX_WAIT_TIME:\r\n      " +
                    "      sim_process.kill()\r\n            f_out.write(\'runCADJob.bat exceeded MAX_WA" +
                    "IT_TIME = {0} (seconds).\'.format(MAX_WAIT_TIME))\r\n            was_killed = True\r" +
                    "\n\r\n    with open(out_put_file, \'r\') as f_in:\r\n        out_put = \'\'.join(f_in.rea" +
                    "dlines())\r\n    if was_killed:\r\n        raise TestBenchExecutionError(out_put)\r\n " +
                    "   else:\r\n        log.debug(out_put)\r\n        log.info(\'Successful {} run!\'.form" +
                    "at(cad_bat))\r\n    return None\r\n\r\ndef _update_parameter(et, name, value):\r\n    \"\"" +
                    "\"\r\n    This needs to be more generic.\r\n    \"\"\"\r\n    root = et.getroot()\r\n    cnt" +
                    " = 0\r\n    for p_elem in (elem for elem in root.iter(tag=\'Force\')):\r\n        p_el" +
                    "em.attrib[name] = str(value)\r\n        cnt += 1\r\n\r\n    return cnt");
            return this.GenerationEnvironment.ToString();
        }
    }
    
    #line default
    #line hidden
    #region Base class
    /// <summary>
    /// Base class for this transformation
    /// </summary>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.TextTemplating", "10.0.0.0")]
    public class FEABase
    {
        #region Fields
        private global::System.Text.StringBuilder generationEnvironmentField;
        private global::System.CodeDom.Compiler.CompilerErrorCollection errorsField;
        private global::System.Collections.Generic.List<int> indentLengthsField;
        private string currentIndentField = "";
        private bool endsWithNewline;
        private global::System.Collections.Generic.IDictionary<string, object> sessionField;
        #endregion
        #region Properties
        /// <summary>
        /// The string builder that generation-time code is using to assemble generated output
        /// </summary>
        protected System.Text.StringBuilder GenerationEnvironment
        {
            get
            {
                if ((this.generationEnvironmentField == null))
                {
                    this.generationEnvironmentField = new global::System.Text.StringBuilder();
                }
                return this.generationEnvironmentField;
            }
            set
            {
                this.generationEnvironmentField = value;
            }
        }
        /// <summary>
        /// The error collection for the generation process
        /// </summary>
        public System.CodeDom.Compiler.CompilerErrorCollection Errors
        {
            get
            {
                if ((this.errorsField == null))
                {
                    this.errorsField = new global::System.CodeDom.Compiler.CompilerErrorCollection();
                }
                return this.errorsField;
            }
        }
        /// <summary>
        /// A list of the lengths of each indent that was added with PushIndent
        /// </summary>
        private System.Collections.Generic.List<int> indentLengths
        {
            get
            {
                if ((this.indentLengthsField == null))
                {
                    this.indentLengthsField = new global::System.Collections.Generic.List<int>();
                }
                return this.indentLengthsField;
            }
        }
        /// <summary>
        /// Gets the current indent we use when adding lines to the output
        /// </summary>
        public string CurrentIndent
        {
            get
            {
                return this.currentIndentField;
            }
        }
        /// <summary>
        /// Current transformation session
        /// </summary>
        public virtual global::System.Collections.Generic.IDictionary<string, object> Session
        {
            get
            {
                return this.sessionField;
            }
            set
            {
                this.sessionField = value;
            }
        }
        #endregion
        #region Transform-time helpers
        /// <summary>
        /// Write text directly into the generated output
        /// </summary>
        public void Write(string textToAppend)
        {
            if (string.IsNullOrEmpty(textToAppend))
            {
                return;
            }
            // If we're starting off, or if the previous text ended with a newline,
            // we have to append the current indent first.
            if (((this.GenerationEnvironment.Length == 0) 
                        || this.endsWithNewline))
            {
                this.GenerationEnvironment.Append(this.currentIndentField);
                this.endsWithNewline = false;
            }
            // Check if the current text ends with a newline
            if (textToAppend.EndsWith(global::System.Environment.NewLine, global::System.StringComparison.CurrentCulture))
            {
                this.endsWithNewline = true;
            }
            // This is an optimization. If the current indent is "", then we don't have to do any
            // of the more complex stuff further down.
            if ((this.currentIndentField.Length == 0))
            {
                this.GenerationEnvironment.Append(textToAppend);
                return;
            }
            // Everywhere there is a newline in the text, add an indent after it
            textToAppend = textToAppend.Replace(global::System.Environment.NewLine, (global::System.Environment.NewLine + this.currentIndentField));
            // If the text ends with a newline, then we should strip off the indent added at the very end
            // because the appropriate indent will be added when the next time Write() is called
            if (this.endsWithNewline)
            {
                this.GenerationEnvironment.Append(textToAppend, 0, (textToAppend.Length - this.currentIndentField.Length));
            }
            else
            {
                this.GenerationEnvironment.Append(textToAppend);
            }
        }
        /// <summary>
        /// Write text directly into the generated output
        /// </summary>
        public void WriteLine(string textToAppend)
        {
            this.Write(textToAppend);
            this.GenerationEnvironment.AppendLine();
            this.endsWithNewline = true;
        }
        /// <summary>
        /// Write formatted text directly into the generated output
        /// </summary>
        public void Write(string format, params object[] args)
        {
            this.Write(string.Format(global::System.Globalization.CultureInfo.CurrentCulture, format, args));
        }
        /// <summary>
        /// Write formatted text directly into the generated output
        /// </summary>
        public void WriteLine(string format, params object[] args)
        {
            this.WriteLine(string.Format(global::System.Globalization.CultureInfo.CurrentCulture, format, args));
        }
        /// <summary>
        /// Raise an error
        /// </summary>
        public void Error(string message)
        {
            System.CodeDom.Compiler.CompilerError error = new global::System.CodeDom.Compiler.CompilerError();
            error.ErrorText = message;
            this.Errors.Add(error);
        }
        /// <summary>
        /// Raise a warning
        /// </summary>
        public void Warning(string message)
        {
            System.CodeDom.Compiler.CompilerError error = new global::System.CodeDom.Compiler.CompilerError();
            error.ErrorText = message;
            error.IsWarning = true;
            this.Errors.Add(error);
        }
        /// <summary>
        /// Increase the indent
        /// </summary>
        public void PushIndent(string indent)
        {
            if ((indent == null))
            {
                throw new global::System.ArgumentNullException("indent");
            }
            this.currentIndentField = (this.currentIndentField + indent);
            this.indentLengths.Add(indent.Length);
        }
        /// <summary>
        /// Remove the last indent that was added with PushIndent
        /// </summary>
        public string PopIndent()
        {
            string returnValue = "";
            if ((this.indentLengths.Count > 0))
            {
                int indentLength = this.indentLengths[(this.indentLengths.Count - 1)];
                this.indentLengths.RemoveAt((this.indentLengths.Count - 1));
                if ((indentLength > 0))
                {
                    returnValue = this.currentIndentField.Substring((this.currentIndentField.Length - indentLength));
                    this.currentIndentField = this.currentIndentField.Remove((this.currentIndentField.Length - indentLength));
                }
            }
            return returnValue;
        }
        /// <summary>
        /// Remove any indentation
        /// </summary>
        public void ClearIndent()
        {
            this.indentLengths.Clear();
            this.currentIndentField = "";
        }
        #endregion
        #region ToString Helpers
        /// <summary>
        /// Utility class to produce culture-oriented representation of an object as a string.
        /// </summary>
        public class ToStringInstanceHelper
        {
            private System.IFormatProvider formatProviderField  = global::System.Globalization.CultureInfo.InvariantCulture;
            /// <summary>
            /// Gets or sets format provider to be used by ToStringWithCulture method.
            /// </summary>
            public System.IFormatProvider FormatProvider
            {
                get
                {
                    return this.formatProviderField ;
                }
                set
                {
                    if ((value != null))
                    {
                        this.formatProviderField  = value;
                    }
                }
            }
            /// <summary>
            /// This is called from the compile/run appdomain to convert objects within an expression block to a string
            /// </summary>
            public string ToStringWithCulture(object objectToConvert)
            {
                if ((objectToConvert == null))
                {
                    throw new global::System.ArgumentNullException("objectToConvert");
                }
                System.Type t = objectToConvert.GetType();
                System.Reflection.MethodInfo method = t.GetMethod("ToString", new System.Type[] {
                            typeof(System.IFormatProvider)});
                if ((method == null))
                {
                    return objectToConvert.ToString();
                }
                else
                {
                    return ((string)(method.Invoke(objectToConvert, new object[] {
                                this.formatProviderField })));
                }
            }
        }
        private ToStringInstanceHelper toStringHelperField = new ToStringInstanceHelper();
        public ToStringInstanceHelper ToStringHelper
        {
            get
            {
                return this.toStringHelperField;
            }
        }
        #endregion
    }
    #endregion
}
