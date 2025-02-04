﻿// ------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version: 10.0.0.0
//  
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
// ------------------------------------------------------------------------------
namespace CyPhyPET.Templates
{
    using System;
    using System.IO;
    using System.Diagnostics;
    using System.Linq;
    using System.Xml.Linq;
    using System.Collections;
    using System.Collections.Generic;
    using ISIS.GME.Dsml.CyPhyML.Classes;
    
    
    #line 1 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.TextTemplating", "10.0.0.0")]
    public partial class SurrogateValidation : SurrogateValidationBase
    {
        public virtual string TransformText()
        {
            this.Write(" \r\n");
            this.Write("# ===========================================================================\r\n# " +
                    "Auto generated from SurrogateValidation.tt\r\n# ==================================" +
                    "=========================================\r\n# OpenMDAO Assembly Component (Surrog" +
                    "ate validation)\r\nimport os\r\nimport pickle\r\nimport numpy\r\nimport logging\r\nimport " +
                    "json\r\nimport shutil\r\nimport numpy as np\r\n\r\nfrom openmdao.main.api import Assembl" +
                    "y, set_as_top\r\nfrom openmdao.lib.drivers.api import DOEdriver\r\nfrom openmdao.lib" +
                    ".doegenerators.api import Uniform\r\nfrom openmdao.lib.casehandlers.api import Lis" +
                    "tCaseRecorder\r\nfrom openmdao.lib.components.api import MetaModel\r\nfrom openmdao." +
                    "lib.surrogatemodels.api import KrigingSurrogate\r\nfrom openmdao.main.uncertain_di" +
                    "stributions import NormalDistribution\r\n\r\nfrom save_results import save_results\r\n" +
                    "\r\nfrom surrogate_model import SurrogateAssembly\r\nfrom ParameterStudy import Para" +
                    "meterStudy\r\n\r\nlog = logging.getLogger()\r\nwhile len(log.handlers) > 2:\r\n    log.r" +
                    "emoveHandler(log.handlers[-1])\r\n\r\n\r\nclass SurrogateValidation(Assembly):\r\n    \"\"" +
                    "\" Validates the surrogate model. Requires input from the Parameter study executi" +
                    "on. \"\"\"\r\n   \r\n    def __init__(self):\r\n        super(SurrogateValidation, self)." +
                    "__init__()\r\n\r\n        f = open( \"meta_model_info.p\", \"rb\" )\r\n        meta_model_" +
                    "info = pickle.load(f)\r\n\r\n        meta_model = meta_model_info[\'meta_model\']\r\n\r\n " +
                    "       ## Create component instances\r\n        self.add(\"meta_model\", meta_model)" +
                    "\r\n        self.meta_model.default_surrogate = meta_model.default_surrogate\r\n\r\n  " +
                    "      self.meta_model.model = SurrogateAssembly()\r\n        \r\n        self.meta_m" +
                    "odel._training_input_history = meta_model_info[\'training_input_history\']\r\n");
            
            #line 65 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.ObjectiveCollection)
    {
        foreach (var conn in item.SrcConnections.ObjectiveMappingCollection)
        {
            string name = conn.GenericSrcEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("        self.meta_model._training_data[\'");
            
            #line 71 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'] = meta_model_info[\'surrogate_info\'][\'");
            
            #line 71 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'][1]\r\n");
            
            #line 72 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
            
            #line default
            #line hidden
            this.Write("        \r\n        self.add(\'driver\', DOEdriver())\r\n        self.add(\'calc\', Surro" +
                    "gateAssembly())\r\n\r\n        # The type and level attributes of DOE\r\n        self." +
                    "driver.DOEgenerator = Uniform()\r\n        self.driver.DOEgenerator.num_samples = " +
                    "10\r\n\r\n");
            
            #line 82 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.DesignVariableCollection)
    {
        string low = "0.0";
        string high = "0.0";
        string range = item.Attributes.Range;
		low = range.Split(',').FirstOrDefault().Trim();
		high = range.Split(',').LastOrDefault().Trim();
        foreach (var conn in item.DstConnections.VariableSweepCollection)
        {
            string name = conn.GenericDstEnd.Name;
            InOuts += "meta_model." + name + ":%f ";
        
            
            #line default
            #line hidden
            this.Write("        if \'numpy\' in str(type(self.meta_model.");
            
            #line 94 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write(")):\r\n            self.meta_model.");
            
            #line 95 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write(" = numpy.asscalar(self.meta_model.");
            
            #line 95 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write(") \r\n        self.driver.add_parameter((\'meta_model.");
            
            #line 96 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\', \'calc.");
            
            #line 96 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'), low = ");
            
            #line 96 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(low));
            
            #line default
            #line hidden
            this.Write(", high = ");
            
            #line 96 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(high));
            
            #line default
            #line hidden
            this.Write(") # ");
            
            #line 96 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(item.Attributes.Range));
            
            #line default
            #line hidden
            this.Write("\r\n\r\n");
            
            #line 98 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
         }
    } 
            
            #line default
            #line hidden
            this.Write("        self.driver.case_outputs = [ \\\r\n");
            
            #line 101 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.ObjectiveCollection)
    {
        foreach (var conn in item.SrcConnections.ObjectiveMappingCollection)
        {
			string name = conn.GenericSrcEnd.Name;
            InOuts += "meta_model." + name + ":%f ";
			InOuts += "calc." + name + ":%f ";
        
            
            #line default
            #line hidden
            this.Write("            \'meta_model.");
            
            #line 109 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\', \\\r\n            \'calc.");
            
            #line 110 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\', \\\r\n");
            
            #line 111 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
            
            #line default
            #line hidden
            this.Write(@"            ]

        self.driver.recorders = [ListCaseRecorder(),]
        self.driver.force_execute = True
        self.driver.workflow.add('meta_model')
        self.driver.workflow.add('calc')
        self._logger.info('Assembly was created. (SurrogateValidation)')


def main():
    if os.path.exists('testbench_manifest.json') and os.path.isdir('TestBench'):
        shutil.copy('testbench_manifest.json', os.path.join('TestBench', 'testbench_manifest.json'))

    doe = SurrogateValidation()
    set_as_top(doe)
    doe.run()

    isKrigingDefault = isinstance(doe.meta_model.default_surrogate, KrigingSurrogate)

    if isKrigingDefault:
        for i, c in enumerate(doe.driver.recorders[0].cases):
            for case_output in doe.driver.case_outputs:
                if isinstance(c[case_output], NormalDistribution):
                    c[case_output] = c[case_output].mu
            doe.driver.recorders[0].cases[i] = c

    sr = save_results(doe, doe.driver.recorders[0])
    sr.save('output.mdao')
    
    # write the case output to the screen
    for c in doe.driver.recorders[0].get_iterator():
        print """);
            
            #line 144 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(InOuts));
            
            #line default
            #line hidden
            this.Write("\"%(\r\n");
            
            #line 145 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.DesignVariableCollection)
    {
        foreach (var conn in item.DstConnections.VariableSweepCollection)
        {
			string name = conn.GenericDstEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("            c[\'meta_model.");
            
            #line 151 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'],\r\n");
            
            #line 152 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
    foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.ObjectiveCollection)
    {
        foreach (var conn in item.SrcConnections.ObjectiveMappingCollection)
        {
			string name = conn.GenericSrcEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("            c[\'meta_model.");
            
            #line 160 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'],\r\n            c[\'calc.");
            
            #line 161 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'],\r\n");
            
            #line 162 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
            
            #line default
            #line hidden
            this.Write("            )\r\n");
            
            #line 165 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 if (SurrogateType == "ResponseSurface")
{
            
            #line default
            #line hidden
            this.Write("    ##  ResponseSurface is surrogate,\r\n    #   write model validation info in mod" +
                    "el_perf.json.\r\n    params = {}\r\n    actual = {}\r\n    predicted = {}\r\n");
            
            #line 172 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.DesignVariableCollection)
    {
        foreach (var conn in item.DstConnections.VariableSweepCollection)
        {
			string name = conn.GenericDstEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("    params[\'");
            
            #line 178 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'] = []\r\n");
            
            #line 179 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
    foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.ObjectiveCollection)
    {
        foreach (var conn in item.SrcConnections.ObjectiveMappingCollection)
        {
			string name = conn.GenericSrcEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("    actual[\'");
            
            #line 187 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'] = []\r\n    predicted[\'");
            
            #line 188 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'] = []\r\n");
            
            #line 189 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
            
            #line default
            #line hidden
            this.Write("\r\n    for c in doe.driver.recorders[0].get_iterator():\r\n");
            
            #line 193 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
 foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.DesignVariableCollection)
    {
        foreach (var conn in item.DstConnections.VariableSweepCollection)
        {
			string name = conn.GenericDstEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("        doe.meta_model.");
            
            #line 199 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write(" = c[\'meta_model.");
            
            #line 199 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\']\r\n        params[\'");
            
            #line 200 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'].append(c[\'meta_model.");
            
            #line 200 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'])\r\n");
            
            #line 201 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
    foreach (var item in pet.Children.ParameterStudyCollection.FirstOrDefault().Children.ObjectiveCollection)
    {
        foreach (var conn in item.SrcConnections.ObjectiveMappingCollection)
        {
			string name = conn.GenericSrcEnd.Name;
        
            
            #line default
            #line hidden
            this.Write("        actual[\'");
            
            #line 209 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'].append(c[\'calc.");
            
            #line 209 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'])\r\n        predicted[\'");
            
            #line 210 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'].append(c[\'meta_model.");
            
            #line 210 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
            this.Write(this.ToStringHelper.ToStringWithCulture(name));
            
            #line default
            #line hidden
            this.Write("\'])\r\n");
            
            #line 211 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
        }
    } 
            
            #line default
            #line hidden
            this.Write(@"
    f = open('model_perf.json','rb')
    perf_json = json.load(f)

    for resp in perf_json:
        y_name = resp['responseName']
        y_pred = np.array(predicted[y_name])
        y_act = np.array(actual[y_name])
        y_mean = y_pred.mean()
        n = len(y_pred)
        p = len(params.keys())

        SStot = np.linalg.norm(y_pred - y_mean) ** 2
        SSres = np.linalg.norm(y_pred - y_act) ** 2

        resp['R2']['validation'] = 1 - SSres / SStot
        Rsq = resp['R2']['validation']
        resp['R2adjusted']['validation'] = Rsq - (1 - Rsq) * p / (n - p - 1)

        residual = y_act-y_pred
        resp['MRE'] = {}
        resp['MRE']['mean'] = residual.mean()
        resp['MRE']['stdDeviation'] = residual.std()
        resp['MRE']['data'] = residual.tolist()

        resp['actualByPredicted']['validation'] = [ [y_act[i],y_pred[i]] for i in xrange(len(y_act)) ]

        resp['residualByPredicted']['validation'] = [ [residual[i],y_pred[i]] for i in xrange(len(y_act)) ]

    with open('model_perf.json','wb') as f_out:
        json.dump(perf_json, f_out, indent=4)
");
            
            #line 244 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"
}
            
            #line default
            #line hidden
            this.Write("\r\nif __name__ == \"__main__\":\r\n    main()\r\n");
            return this.GenerationEnvironment.ToString();
        }
        
        #line 248 "C:\META\meta_trunk\src\CyPhyPET\Templates\SurrogateValidation.tt"

    public ISIS.GME.Dsml.CyPhyML.Interfaces.ParametricExploration pet { get; set; }
    public string InOuts {get; set;}
	public string SurrogateType {get;set;}

        
        #line default
        #line hidden
    }
    
    #line default
    #line hidden
    #region Base class
    /// <summary>
    /// Base class for this transformation
    /// </summary>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.TextTemplating", "10.0.0.0")]
    public class SurrogateValidationBase
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
