import os
import time
import shutil
import datetime
import logging
import subprocess
from py_modelica.modelica_simulation_tools.tool_base import ToolBase
from py_modelica.modelica_simulation_tools.openmodelica_element_tree import OpenModelicaElementTree
from py_modelica.utility_functions import subprocess_call
from py_modelica.exception_classes import ModelicaInstantiationError, ModelicaCompilationError,\
    ModelicaSimulationError


class OpenModelica(ToolBase):

    tool_name = "OpenModelica"
    model_statistics = {}
    compile_errors = []
    om_home = ""
    om_etree = None      # OpenModelicaElementTree for parsing .xml files
    short_name = ""

    def __init__(self, model_config, om_home=""):
        """
        Constructor for OpenModelica class, called before ToolBase's
        _initialize.

        This method only makes sure that there is a environment
        OPENMODELICAHOME defined.

        """
        if not om_home:
            self.om_home = os.getenv("OPENMODELICAHOME")
            if self.om_home:
                if os.path.exists(self.om_home):
                    self.tool_path = os.path.join(self.om_home, "bin")
                else:
                    msg = "OpenModelica path not found at env: {0}".format(self.om_home)
                    raise ModelicaInstantiationError(msg)
            else:
                if os.name == "nt":
                    msg = "No environment variable OPENMODELICAHOME defined."
                    raise ModelicaInstantiationError(msg)
        elif os.path.exists(om_home):
            self.om_home = om_home
            self.tool_path = os.path.join(self.om_home, "bin")
        else:
            msg = "Given OpenModelica home not found at: {0}".format(om_home)
            raise ModelicaInstantiationError(msg)
        self._initialize(model_config)
    # end of _set_tool_home

    def _write_mos_script(self, log):
        """
        Writes out .mos-script for translation of the modelica model

        """

        log.debug("Entered _write_mos_script")

        with open(self.mos_file_name, 'wb') as file_out:
            lines = ['// OpenModelica script file to run a model']
            lines.append('loadModel(Modelica, {"' + self.msl_version + '"});')
            for lib_name in self.lib_package_names:
                lines.append('loadModel({0});'.format(lib_name))
            if self.model_file_name != "":
                lines.append('cd("{0}");'.format(self.mo_dir.replace("\\", "/")))
                lines.append('loadFile("{0}");'.format(os.path.basename(self.model_file_name)))

            translate = 'translateModel(' + self.model_name
            #if self.variable_filter:
            #    translate += ', variable_filter=['
            #    for var in self.variable_filter:
            #        translate += var
            #    translate += ']'
            translate += ', fileNamePrefix="{0}"'.format(self.short_name)
            translate += ');'
            lines.append(translate)
            lines.append('getErrorString();')
            file_out.write("\n".join(lines))
            log.debug("Generated .mos-script at : {0}".format(self.mos_file_name))
    # end of _write_mos_script

    def _setup_libs_env_vars(self, log):
        """
        Function adds given library paths to environment-variable OPENMODELICALIBRARY.
        Which is updated in os.environ and returned.

        If path does not exist on hard-drive it looks for it at; /working_dir/Modelica
        (This is where the packages are put during remote execution.)

        """

        log.debug('Entered _setup_libs_env_vars')

        my_env = os.environ
        lib_paths = ""
        remote = False
        # supports relative paths and adds the package paths if exist
        for lib_path in self.lib_package_paths:
            lib_full_path = os.path.abspath(lib_path)
            if os.path.exists(lib_full_path):
                lib_paths += lib_full_path
                lib_paths += os.pathsep
            else:
                print "The library path {0} does not exist, this might lead to errors.".format(lib_full_path)

        if 'OPENMODELICALIBRARY' in my_env:
            my_env['OPENMODELICALIBRARY'] += os.pathsep + lib_paths
            log.debug("Added paths to existing OPENMODELICALIBRARY environment variable; ")
        else:
            if os.name == 'nt':
                om_std_lib = os.path.join(self.om_home, 'lib', 'omlibrary')
            elif os.name == 'posix':
                om_std_lib = os.sep + os.path.join('usr', 'lib', 'omlibrary')
            else:
                raise ModelicaInstantiationError('Only Windows and Linux are supported by py_modelica.')

            om_lib = {'OPENMODELICALIBRARY': '{0}{1}{2}'.format(om_std_lib, os.pathsep, lib_paths)}
            log.debug("No environment variable OPENMODELICALIBRARY found, created;")
            my_env.update(om_lib)
        log.debug('OPENMODELICALIBRARY : {0}'.format(my_env['OPENMODELICALIBRARY']))

        return my_env
    # end of _setup_libs_env_vars

    def _print_revision_number(self, log):
        """
        Gets the revision number of the omc-compiler

        """
        log.debug("Entered _print_revision_number")

        command = '"{0}" +version'.format(os.path.join(self.tool_path, "omc"))
        try:
            return_str = subprocess_call(command, log)
            version = return_str.split('(')
            self.tool_version = version[0].strip()
            self.tool_version_number = version[1].strip().strip(')')
        except subprocess.CalledProcessError as err:
            raise ModelicaCompilationError("Could not call omc.", sp_msg=err.returncode)
    # end of _print_revision_number

    def _translate_modelica_model(self, log, my_env):
        """
        Calls omc(.exe) to translate the modelica model into c-code.

        """
        os.chdir(self.mo_dir)

        command = '"{0}" +q +s "{1}"'.format(os.path.join(self.tool_path, 'omc'), self.mos_file_name)

        t_stamp = time.time()
        try:
            return_string = subprocess_call(command, log, my_env)
        except subprocess.CalledProcessError as err:
            raise ModelicaCompilationError('OMC could not compile model.', sp_msg=err.returncode)
        self.translation_time = time.time() - t_stamp

        if os.path.exists(os.path.join(self.mo_dir, self.short_name) + '_init.xml'):
            self.model_is_compiled = True
        else:
            msg = 'Subprocess call with command = "{0}" returned with 0, but _init.xml does not '\
                  'exist - something went wrong during translation of model.'.format(command)
            raise ModelicaCompilationError(msg, return_string)

        # N.B. this is not used and thus not maintained
        if not self.working_dir == self.mo_dir:
            files_to_move = [self.short_name + '.c',
                             self.short_name + '.makefile',
                             self.short_name + '.o',
                             self.short_name + '_functions.c',
                             self.short_name + '_functions.h',
                             self.short_name + '_init.xml',
                             self.short_name + '_records.c',
                             self.short_name + '_records.o',
                             '_' + self.short_name + '.h']

            for this_file in files_to_move:
                dst_file_name = os.path.join(self.working_dir, this_file)
                if os.path.exists(dst_file_name):
                    # remove dst file if it already exists
                    os.remove(dst_file_name)
                this_file = os.path.join(self.mo_dir, this_file)
                if os.path.exists(this_file):
                    shutil.move(this_file, self.working_dir)

        os.chdir(self.working_dir)
    # end of _translate_modelica_model

    def _make_model(self, log):
        """
        Compiles the generated c-code into an executable
        """
        if os.name == 'nt':
            # Windows
            # Make model

            # Add %OPENMODELICAHOME%\MinGW\bin to environment variables
            env_var_mingw = os.path.join(os.getenv('OPENMODELICAHOME'), 'mingw', 'bin')
            my_env = os.environ
            my_env["PATH"] += os.pathsep + env_var_mingw

            command = 'mingw32-make.exe -f {0}.makefile'.format(self.short_name)

            # compile the c-code
            t_stamp = time.time()
            try:
                subprocess_call(command, log, my_env)
            except subprocess.CalledProcessError as err:
                raise ModelicaCompilationError("Generated C-code from omc could not be compiled",
                                               sp_msg=err.returncode)
            self.make_time = time.time() - t_stamp

        elif os.name == 'posix':
            # Unix
            # make -f model_name.makefile
            command = "make -f {0}.makefile".format(self.short_name)
            t_stamp = time.time()
            try:
                subprocess_call(command, log)
            except subprocess.CalledProcessError as err:
                raise ModelicaCompilationError("Generated C-code from omc could not be compiled",
                                               sp_msg=err.returncode)
            self.make_time = time.time() - t_stamp
    # end of _make_model

    def compile_model(self):
        """
        Compile the model

        """

        log = logging.getLogger()
        log.debug("Entered compile_model")

        # create a directory for the compiled model
        self.working_dir = os.path.normpath(os.path.join(os.getcwd(), self.output_dir))
        if not os.path.exists(self.working_dir):
            os.makedirs(self.working_dir)
        log.debug("Working dir : {0}".format(self.working_dir))

        # write .mos script (short_name is used for output files)
        if not self.short_name:
            self.short_name = self.model_name.split('.')[-1]
            log.info('Result mat-file name not given using default : {0}_res.mat'.format(
                self.short_name))
        else:
            log.info('Result mat-file name set to : {0}_res.mat'.format(self.short_name))

        self.result_mat = '{0}_res.mat'.format(self.short_name)
        self.mos_file_name = 'om_sim.mos'
        self._write_mos_script(log)

        # print and save revision number
        self._print_revision_number(log)

        # Add paths to additional modelica-libraries in OPENMODELICALIBRARY
        my_env = os.environ
        if self.lib_package_paths:
            my_env = self._setup_libs_env_vars(log)

        # translate the modelica code according to the .mos script
        self._translate_modelica_model(log, my_env)

        # compile the c-code into executable
        self._make_model(log)

        self.compilation_time = self.translation_time + self.make_time

        # Load *_init.xml into data-tree-structure
        xml_file = os.path.join(self.working_dir, '{0}_init.xml'.format(self.short_name))
        self.om_etree = OpenModelicaElementTree(xml_file)
        self.model_statistic = self.om_etree.get_statistics()

        return self.model_is_compiled
    # end of compile_model

    def simulate_model(self):
        """
        Simulate model using current settings

        """
        log = logging.getLogger()
        log.debug("Entered simulate_model")

        if not self.model_is_compiled:
            msg = 'The model was never compiled!'
            log.error(msg)
            raise ModelicaSimulationError('The model was never compiled!')

        # change current directory to working directory
        os.chdir(self.working_dir)

        # short_name.exe
        command = ''
        if os.name == 'nt':
            command = '{0}.exe'.format(self.short_name)
        elif os.name == 'posix':
            command = './{0}'.format(self.short_name)

        # run the simulation

        total_cnt = 0   # Counter to check to total elapsed simulation time

        om_stdout = open('om_stdout.txt', 'w')
        t_stamp = time.time()
        sim_process = subprocess.Popen([command], stdout=om_stdout, stderr=om_stdout)
        log.debug('OpenModelica simulation sub-process opened.')
        while sim_process.poll() is None:
            time.sleep(1)
            total_cnt += 1
            if total_cnt > self.max_simulation_time:
                sim_process.kill()
                raise ModelicaSimulationError("OpenModelica simulation took more than {1:.1f} hours. "
                                              "Simulation killed.".format(float(self.max_simulation_time)/3600))

        self.simulation_time = time.time() - t_stamp
        self.total_time = self.compilation_time + self.simulation_time

        om_stdout.close()
        with open('om_stdout.txt', 'r') as f_in:
            return_string = '\n'.join(f_in.readlines())
            log.info("Simulation output : {0}".format(return_string))

        if not os.path.exists(self.result_mat):
            msg = 'Subprocess call with command = "{0}" returned with 0, but the result '\
                  '.mat-file does not exist'.format(command)
            raise ModelicaSimulationError(msg, return_string)
        else:
            self.model_did_simulate = True
            log.info('OpenModelica simulation was successful.')

        return self.model_did_simulate
    # end of simulate_model

    def change_experiment(self,
                          start_time='0',
                          stop_time='1',
                          n_interval='500',
                          tolerance='1e-5',
                          solver='dassl',
                          increment='',
                          max_fixed_step='',
                          output_format='',
                          variable_filter=''):
        """
        Change the default experiment values.

        """

        log = logging.getLogger()
        log.debug("Entered change_experiment")
        if not self.model_is_compiled:
            msg = "Model must be compiled before changing experiment."
            log.error(msg)
            return False

        os.chdir(self.working_dir)

        self.experiment.clear()
        self.experiment['StartTime'] = start_time
        self.experiment['StopTime'] = stop_time
        self.experiment['NumberOfIntervals'] = n_interval
        self.experiment['Tolerance'] = tolerance
        self.experiment['Solver'] = solver

        if increment:
            self.experiment['Increment'] = increment
        else:
            step_size = (float(stop_time) - float(start_time))/float(n_interval)
            self.experiment['Increment'] = str(step_size)

        if output_format:
            self.experiment['OutputFormat'] = output_format

        changed = self.om_etree.change_experiment(self.experiment['StartTime'],
                                                  self.experiment['StopTime'],
                                                  self.experiment['Increment'],
                                                  self.experiment['Tolerance'],
                                                  self.experiment['Solver'],
                                                  output_format,
                                                  variable_filter)
        # generate a new date_time for saving result
        self.date_time = '{0}'.format(datetime.datetime.today())
        if changed:
            self.om_etree.write()
        os.chdir(self.root_dir)
        if changed:
            log.info("Experiment has been change to: {0}".format(self.experiment))
        else:
            log.debug("No changes were made.")
        return changed
    # end of change_experiment

    def change_parameter(self, change_dict):
        """
        Change parameters values of those given in change_dict

        """
        log = logging.getLogger()
        log.debug("Entered change_parameter")
        if not self.model_is_compiled:
            log.error("Model not compiled before changing parameters.")
            return False
        os.chdir(self.working_dir)
        changed = self.om_etree.change_parameter(change_dict)
        if changed:
            self.om_etree.write()
        os.chdir(self.root_dir)

        # generate a new date_time for saving result
        self.date_time = '{0}'.format(datetime.datetime.today())

        return changed
    # end of change_parameter