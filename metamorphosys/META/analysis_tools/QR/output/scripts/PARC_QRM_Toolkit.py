#!/usr/bin/env python
#
# USAGERIGHTS meta-x
#
# This module contains a library for generating XML from a Modelica model,
# and for running the PARC envisioner on such XML and getting back a
# representation of the envisionment.
#

import sys, os, tempfile, subprocess, re, platform, shutil, webbrowser, StringIO, threading
try:
    # 2.6
    import json
except ImportError:
    # 2.5
    try:
        import simplejson as json
    except ImportError:
        sys.stderr.write("Neither json nor simplejson modules are available.  Cannot proceed.")
        raise RuntimeError("Can't find either json or simplejson modules")

# try:
#     # for read_initial_values_from_omc_mat_file
#     import scipy.io
# except ImportError:
#     sys.stderr.write("Can't import scipy.io.  Cannot proceed.")
#     raise RuntimeError("Can't import scipy.io")

QRM = None
"""This specifies the location of the PARC QRM tool executable.  If set to None, the code
will look on the environment variable PATH for an executable named 'QRM'.  If not found,
a RuntimeError will be raised."""

OMC = None
"""This specifies the location of the OpenModelica 'omc' executable.  If set to None, the code
will look on the environment variable PATH for an executable named 'omc'.  If not found,
a RuntimeError will be raised."""

def quote_backslashes (s):
    return re.sub(r"\\", r"\\\\", s)

def get_temp_dir():
    dirname = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../QRM")
    if not os.path.exists(dirname):
        os.mkdir(dirname)
    return dirname

def convert_json_to_CyPhy_results_format (inputjson):

    """Take the JSON format generated by the envisioner (a graph of the envisionment),
    and create the summary format desired by CyPhy."""
    
    data = json.loads(inputjson)
    # do a bit of validation
    assert('model' in data and 'variables' in data and len(data['variables']) > 0 and 'situations' in data)
    # find the name of this test
    testname = data['model']
    # find the requirements
    # r22500 omc puts a $<varname> at the end of the type 
    requirements = [vname for vname in data['variables'] if 'Requirement$' in data['variables'][vname]['type']]
    print 'Number of requirements: ' + str(len(requirements))
    # find the terminals
    terminals = [x for x in data['situations'] if x['type'] == 'INSTANT' and not x['children']]
    print 'Number of Terminals: ' + str(len(terminals))
    results = []
    for requirement in requirements:
        values = [(y['value'].upper() for y in x['vars'] if y['name'] == requirement).next() for x in terminals]
        values = [(x if x != u'VIOLATED' else u'FAIL') for x in values] 
        print 'values:' + str(values)
        results.append({'ReqName': requirement,
                        'Source' : 'PARC',
                        'Result' : reduce(lambda x, y: x if (x == y) else False, values, values[0]) or u'UNKNOWN',
                        'Details' :[]})
        suggestions = [x['suggestions'][requirement] for x in terminals if ('suggestions' in x and requirement in x.get('suggestions'))]
        #print 'suggestions:' + str(suggestions)
        if suggestions:
            suggestions = reduce(lambda x, y: x+y, [[(y['change'].capitalize() + ' ' + y['variable']) for y in x] for x in suggestions])
        #print 'suggestions:' + str(suggestions)
        if suggestions:
            results[-1]['Details'] = [{"GroupTitle": "Changes suggested by QRM's symbolic differential qualitative analysis",
                                       "GroupBody": suggestions}]
    return json.dumps({'FormalVerification':
                        results},
                        sort_keys=False,
                        indent=2)

class SubprocessWithTimeout(object):
    def __init__(self, command, shell=None, close_fds=None):
        self.__command = command
        self.__process = None
        self.__stdout = None
        self.__stderr = None
        if shell is None:
            self.__shell = False
        else:
            self.__shell = shell
        if close_fds is None:
            self.__close_fds = False
        else:
            self.__close_fds = shell
    def run (self, timeout=None):
        def runnable():
            self.__stdout, self.__stderr = self.__process.communicate()
        _env = os.environ.copy()
        _env['PARC_QRM_TOOLKIT_LOCATION'] = os.path.dirname(os.path.abspath(__file__))
       # print _env
        self.__process = subprocess.Popen(self.__command,
                                          shell=self.__shell,
                                          close_fds=self.__close_fds,
                                          env=_env,
                                          stdout=subprocess.PIPE,
                                          stderr=subprocess.PIPE,
                                          stdin=subprocess.PIPE)
        if timeout is not None:
            t = threading.Thread(target=runnable)
            t.start()
            t.join(timeout)
            if t.is_alive():
                self.__process.terminate()
                t.join()
        else:
            runnable()
        return self.__process.returncode, self.__stdout, self.__stderr

def generate_xml (modelica_model_name, modelica_files, msl_version=None, timeout=None):
    """
    Given one or more files containing a model, and the name of that model,
    use OpenModelica's "omc" tool to generate an optimized XML description of that model.

    :param modelica_model_name: the name of the Modelica model
    :type modelica_model_name: string

    :param modelica_files: the paths to one or more files containing Modelica code
    :type modelica_files: either a string, for just one file, or a sequence of strings, if multiple files

    :param msl_version: which version of the Modelica Standard Library to specify.  If None, the default library version is used.
    :type msl_version: a string containing the version number

    :param timeout: timeout for XML generation process, optional
    :type timeout: float

    :return: a pathname for a generated XML file containing an optimized description of the specified model
    :rtype: a string
    """
    
    global OMC

    if not OMC:
        exe_name = "omc" + (".exe" if (platform.system() == "Windows") else "")
        for d in os.environ.get("PATH").split(os.pathsep):
            tpath = os.path.abspath(os.path.join(d, exe_name))
            if os.path.exists(tpath) and os.access(tpath, os.X_OK):
                OMC = tpath
                break
    if not OMC:
        raise RuntimeError("'omc' not on PATH %s" % (os.environ.get("PATH").split(os.pathsep),))

    mos_file = tempfile.mktemp(".mos", dir=get_temp_dir())
    try:
        fp = open(mos_file, "w")
        try:
            fp.write("echo(false);\n")
            fp.write('setCommandLineOptions("+debug=failtrace");\n');
            fp.write('setCommandLineOptions("+showErrorMessages");\n');
            # fp.write('setCommandLineOptions("+indexReductionMethod=dummyDerivative");\n');
            # fp.write('setCommandLineOptions("+preOptModules=removeSimpleEquations,inlineArrayEqn,'
            #          'removeFinalParameters,removeEqualFunctionCalls,removeUnusedParameter,'
            #          'removeUnusedVariables");\n')
            # fp.write('setCommandLineOptions("+postOptModules=lateInline,removeUnusedParameter,'
            #          'removeUnusedFunctions");\n')
            if msl_version:
                fp.write('loadModel(Modelica,{"%s"});\n' % msl_version)
            else:
                fp.write('loadModel(Modelica);\n')
            if isinstance(modelica_files, (str, unicode)):
                modelica_files = (modelica_files,)
            for modelfile in modelica_files:
                fpath = os.path.abspath(modelfile)
                if not os.path.exists(fpath):
                    raise ValueError("Specified model file '%s' doesn't exist!" % modelfile)
    #            fp.write('loadFile("' + quote_backslashes(fpath) + '");\n')
            fp.write('loadFile("' + fpath + '");\n')
    #        xml_file = os.path.join(os.path.dirname(tempfile.mktemp()), modelica_model_name)
            xml_file = modelica_model_name
            fp.write('dumpXMLDAE(' + modelica_model_name + ',"optimiser",addMathMLCode=true,fileNamePrefix="'
                     + quote_backslashes(xml_file) + '");\n');
            fp.write('print(getErrorString());\n')
        finally:
            fp.close()

        xml_file += ".xml"
        command = [OMC, mos_file]
        returncode, stdout, stderr = SubprocessWithTimeout(command).run(timeout=timeout)
        if returncode == 0:
            if os.path.exists(xml_file):
                return os.path.abspath(xml_file)
            else:
                raise RuntimeError("omc completed successfully, but no XML file %s was generated.  Stdout was %s, stderr %s." % (xml_file, repr(stdout.strip()), repr(stderr.strip())))
        else:
            raise RuntimeError("omc failed: exit status = %s, stderr was %s" % (returncode, repr(stderr)))
    finally:
        print(mos_file)
 #if os.path.exists(mos_file): os.unlink(mos_file)

def do_envisionment (xml_file, timeout=None, depth=None, CyPhy_output=False):
    """
    Given an OpenModelica XML dump of a Modelica model,
    use PARC's "QRM" tool to generate an qualitative envisionment of that model, and
    return a description of that envisionment in a JSON-formatted file.

    :param xml_file: the pathname to the file containing the XML dump
    :type xml_file: string

    :param timeout: timeout in seconds, optional
    :type timeout: float

    :param depth: max depth of envisionment, optional (currently not implemented)
    :type depth: integer

    :param CyPhy_output: whether to generate CyPhy JSON output format, optional, defaults to False
    :type CyPhy_output: boolean

    :return: a pathname for a generated JSON file containing a description of the envisionment
    :rtype: a string
    """

    global QRM

    if not QRM:
        exe_name = "QRM" + (".exe" if (platform.system() == "Windows") else "")
        for d in os.environ.get("PATH").split(os.pathsep):
            tpath = os.path.abspath(os.path.join(d, exe_name))
            if os.path.exists(tpath) and os.access(tpath, os.X_OK):
                QRM = tpath
                break

    if not QRM:
        raise RuntimeError("envisioner not on PATH %s" % (os.environ.get("PATH").split(os.pathsep),))

    json_file = tempfile.mktemp(".json", dir=get_temp_dir())
    command = [QRM, "--omcxmldae", json_file, xml_file]
    returncode, stdout, stderr = SubprocessWithTimeout(command).run(timeout=timeout)
    if returncode == 0:
        if os.path.exists(json_file):
            if CyPhy_output:
                json = open(json_file).read()
                open(json_file, "w").write(convert_json_to_CyPhy_results_format(json))
            return os.path.abspath(json_file)
        else:
            raise RuntimeError("QRM completed successfully, but no JSON file was generated")
    else:
        raise RuntimeError("QRM failed: exit status = %s, stderr was %s, stdout was %s" % (
            returncode, repr(stderr), repr(stdout)))


def do_envisionment_from_modelica (modelica_model_name, modelica_files, rewrites_file, timeout=None, depth=None, CyPhy_output=False):
    """
    Given one or more files containing a model, and the name of that model,
    use OpenModelica's "omc" tool to generate an optimized XML description of that model.

    :param modelica_model_name: the name of the Modelica model
    :type modelica_model_name: string

    :param modelica_files: the paths to one or more files or libraries containing Modelica code
    :type modelica_files: either a string, for just one file, or a sequence of strings, if multiple files

    :param timeout: timeout in seconds, optional
    :type timeout: float

    :param depth: max depth of envisionment, optional (currently not implemented)
    :type depth: integer

    :param CyPhy_output: whether to generate CyPhy JSON output format, optional, defaults to False
    :type CyPhy_output: boolean

    :return: a pathname for a generated JSON file containing a description of the envisionment
    :rtype: a string
    """

    global QRM

    if not QRM:
        exe_name = "QRM" + (".exe" if (platform.system() == "Windows") else "")
        for d in os.environ.get("PATH").split(os.pathsep):
            tpath = os.path.abspath(os.path.join(d, exe_name))
            if os.path.exists(tpath) and os.access(tpath, os.X_OK):
                QRM = tpath
                break

    if not QRM:
        raise RuntimeError("envisioner not on PATH %s" % (os.environ.get("PATH").split(os.pathsep),))

    json_file = tempfile.mktemp(".json", dir=get_temp_dir())
    command = [QRM, "--modelica", json_file, modelica_model_name, rewrites_file]
    print "command"
    print command
    print modelica_files
    if modelica_files:
        command += modelica_files
    print command
    returncode, stdout, stderr = SubprocessWithTimeout(command, close_fds=True).run(timeout=timeout)
    if returncode == 0:
        if os.path.exists(json_file):
            if CyPhy_output:
                json = open(json_file).read()
#                open(json_file+'.bak', "w").write(json) # useful for debugging
                open(json_file, "w").write(convert_json_to_CyPhy_results_format(json))
            return os.path.abspath(json_file)
        else:
            raise RuntimeError("QRM completed successfully, but no JSON file was generated")
    else:
        raise RuntimeError("QRM failed: exit status = %s, stderr was %s, stdout was %s" % (
            returncode, repr(stderr), repr(stdout)))


def read_initial_values_from_omc_mat_file (mat_file_path):
    """Given a matlab-4 .mat file containing the results of an OpenModelica
    simulation run, read the file and extract the values of the parameters
    and variables for time==0, and return a dictionary containing them.

    Requires scipy.
    """

    data = scipy.io.loadmat(mat_file_path, chars_as_strings=False)
    namedata = data.get('name').transpose()
    names = [reduce(lambda x, y: x+y, namedata[row]) for row in range(namedata.shape[0])]
    datatypes = data.get('dataInfo')
    # form varinfo: (name, whether it's a variable, index of var's row in data_2)
    varinfo = zip(names, [(x != 1) for x in datatypes[0]], (x for x in datatypes[1]))
    parameters = data.get('data_1')
    variables = data.get('data_2')
    # get first value of each variable (and parameter)
    initial_values = variables.transpose()[0]
    parameter_values = parameters.transpose()[0]
    return dict([(var[0], initial_values[abs(var[2])-1]) for var in varinfo if var[1]] +
                [(var[0], parameter_values[abs(var[2])-1]) for var in varinfo if not var[1]])

def write_initial_values_from_omc_mat_file_to_lisp (mat_file_path, output_file=None):
    """Given a matlab-4 .mat file containing the results of an OpenModelica
    simulation, write the initial values for variables and parameters to
    stdout in a lisp-friendly format."""

    d = read_initial_values_from_omc_mat_file(mat_file_path)
    (sys.stdout if output_file is None else output_file).write(
        '(' + ''.join([('("' + key + '" . ' + str(value) + ')') for key, value in d.items()]) + ')\n')

def analyze_envisionment (json_file_path):
    """
    Given the json file containing the envisionment, generate a textual report
    to the report_file_path if specified, to a temp file otherwise.  Return
    a string containing the report.
    """

    qvalue_explanations = {
        "(Q- . DEC)": "negative, decreasing",
        "(Q- . STD)": "negative, unchanging",
        "(Q- . INC)": "negative, increasing",
        "(Q0 . DEC)": "zero, decreasing",
        "(Q0 . STD)": "zero, unchanging",
        "(Q0 . INC)": "zero, increasing",
        "(Q+ . DEC)": "positive, decreasing",
        "(Q+ . STD)": "positive, unchanging",
        "(Q+ . INC)": "positive, increasing",
        }
    
    def translate_qvalue (qvalue):
        if qvalue in qvalue_explanations:
            return qvalue_explanations[qvalue]
        else:
            return qvalue

    def display_situation (interesting_variables, situation):
        status = situation["status"]
        output.write("  %s%s:\n" % (situation['id'], (status and (" (" + status + ")")) or ""))
        for variable in sorted(situation['vars']):
            if variable["name"] in interesting_variables:
                if variable["name"].startswith("condition"):
                    output.write("    condition [%s]:  %s\n" % (
                        interesting_variables[variable["name"]]["type"],
                        variable["value"]))
                else:
                    output.write("    %s:  %s\n" % (
                        variable["name"], translate_qvalue(variable["value"])))

    data = json.load(open(json_file_path))
    output = StringIO.StringIO()
    initials_count = 0
    for situation in data['situations']:
        if situation["initial"]:
            initials_count += 1
    interesting_variables = {}
    for varname, vardata in data["variables"].items():
        if (varname.startswith("condition") or
            ((not varname.startswith("dummy")) and ("." not in varname) and (varname != "time")) or
            vardata["state"]):
            interesting_variables[varname] = vardata

    output.write("Model:  %s\n" % data["model"])
    e = data["envisioner"]
    output.write("QRM version:  %s.%s%s%s\n" % (
        e["major_version"], e["minor_version"],
        e["tag"] and ("/" + e["tag"]) or "",
        e["revision"] and (" (revision " + e["revision"] + ")") or ""))
    output.write("Modelica processor:  %s\n" % data["model_generator"])
    output.write("%s\n" % ("-"*50))

    output.write("State variables:\n")
    for varname, vardata in sorted(data["variables"].items()):
        if "state" in vardata and vardata["state"]:
            output.write("  %s  (%s)\n" % (varname, vardata["type"]))

    output.write("%s\n" % ("-"*50))

    output.write("Initial situations:\n")
    for situation in data['situations']:
        if situation["initial"]:
            display_situation(interesting_variables, situation)
    output.write("%s\n" % ("-"*50))
    output.write("Terminal situations:\n")
    for situation in data['situations']:
        if not situation["children"]:
            display_situation(interesting_variables, situation)
    result = output.getvalue()
    output.close()
    return result        


def display_envisionment (json_file_path):

    """Builds an HTML file which displays the JSON file.  Returns the path
    to the temporary directory which contains the files.  That directory should
    be removed after the user is finished with it."""

    tdir = get_temp_dir()
    envisionment_data = json.load(open(json_file_path))
    envisionment_data["tempdir"] = tdir
    current_dir = os.path.dirname(__file__)
    html_template = open(os.path.join(current_dir, "template.html"), "r").read()
    open(os.path.join(tdir, "envisionment.html"), "w").write(html_template % envisionment_data)
    shutil.copyfile(os.path.join(current_dir, "ui.js"), os.path.join(tdir, "ui.js"))
    shutil.copyfile(os.path.join(current_dir, "d3.v2.js"), os.path.join(tdir, "d3.v2.js"))
    # we actually need a javascript file to get around cross-origin pseudo-security
    open(os.path.join(tdir, "envisionment.js"), "w").write(
        "var model = " + open(json_file_path).read() + ";\n")
    webbrowser.open("file:///%s/envisionment.html" % tdir)                            
    
    return tdir
