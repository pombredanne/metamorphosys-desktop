__author__ = 'adam'

import sys
import os
import errno
import json
import datetime
import contextlib
import shlex


class NoStepsException(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        repr(self.value)


class TestBenchExecutor:
    _path_manifest = ''
    _dict_manifest = dict()
    _steps = list()

    def __init__(self, manifest_path):
        """
        @param manifest_path: The path to the test bench manifest
        @type manifest_path: str
        @return: Nothing
        @rtype: None
        @raise: NoStepsException if no execution steps found in manifest
        """

        self._path_manifest = manifest_path
        self._load_tb_manifest()
        # TODO: command-line option to skip this
        with self._update_manifest() as manifest:
            for step in manifest["Steps"]:
                step["Status"] = "UNEXECUTED"
                step["LogFile"] = None
                step["ExecutionStartTimestamp"] = None
                step["ExecutionCompletionTimestamp"] = None

        if len(self._steps) == 0:
            raise NoStepsException("No execution steps found in manifest")

    def _load_tb_manifest(self):
        with open(self._path_manifest, 'r') as f:
            self._dict_manifest = json.load(f)

        self._steps = self._dict_manifest["Steps"]

    def run_all(self):
        '''
        Executes all unexecuted steps in sequence.

        @return: 0 if executed successfully, <0 if error
        @rtype: int
        '''

        loop_limit = 100000
        num_loops = 0

        while num_loops <= loop_limit:
            num_loops += 1
            rtn_code = self.run_next_step()

            if rtn_code == 0:
                # Step successfully completed
                continue
            elif rtn_code == 1:
                # No steps remaining
                break
            else:
                # Error
                return rtn_code

        if num_loops >= loop_limit:
            raise Exception("run_all has exceeded the loop limit of {limit}. "
                            "Something is wrong with the step execution."
                            .format(limit=loop_limit))

        with self._update_manifest() as manifest:
            manifest["Status"] = "OK"

        return 0

    def run_next_step(self):
        """
        Find and execute the first unexecuted step.

        @return: 0 if executed successfully, 1 if no steps remaining, <0 if error
        @rtype: int
        """

        step = self._get_first_unexecuted_step()

        # if no steps remaining
        if step is None:
            return 1

        return self._execute_step(step)

    def _get_first_unexecuted_step(self):
        for s in self._steps:
            status = str(s["Status"])
            if status == "UNEXECUTED":
                return s

        # If none are unexecuted
        return None

    @contextlib.contextmanager
    def _update_manifest(self):
        """
        Load the manifest, run code, then save it
        
        Use as: with self._update_manifest() as manifest: manifest['this'] = 'that'
        """
        with open(self._path_manifest, 'r') as f:
            d_manifest = json.load(f)

        yield d_manifest

        with open(self._path_manifest, 'w') as f:
            json.dump(d_manifest, f, indent=2)

        # Update member copy of manifest dictionary
        self._dict_manifest = d_manifest
        self._steps = d_manifest["Steps"]

    def _update_step(self, step, updates):
        """
        Given a step and a set of updates, modify that step object in the manifest file.

        @param step: The step to be modified
        @type step: dict
        @param updates: A dictionary of key-value pairs to be updated
        @type updates: dict
        @return: The modified step
        @rtype: dict
        """
        # Load the json file
        # find the matching step
        # update it
        # save back

        with self._update_manifest() as d_manifest:
            d_steps = d_manifest["Steps"]
            r_step = None
            for s in d_steps:
                if s == step:
                    r_step = s
                    break

            r_step.update(updates)

        return r_step

    @property
    def _time(self):
        """
        @return: The time, in ISO 8601 standard format
        @rtype: str
        """
        return datetime.datetime.now().isoformat()

    def _mark_manifest_status(self):
        """
        Based on the status of the manifest's steps, mark it as OK, FAILED, or UNEXECUTED
        """

        any_failed = False
        any_unexecuted = False
        for step in self._steps:
            if step["Status"] is "FAILED":
                any_failed = True
            elif step["Status"] is "UNEXECUTED":
                any_unexecuted = True

        with self._update_manifest() as manifest:
            if any_failed:
                manifest["Status"] = "FAILED"
            elif any_unexecuted:
                manifest["Status"] = "UNEXECUTED"

    def _execute_step(self, step):
        step = self._update_step(step, {"ExecutionStartTimestamp": self._time})

        log = None
        ### Execute step
        try:
            import subprocess

            if not step.get("LogFile"):
                step = self._update_step(step, {
                    "LogFile": "log/log" + step["ExecutionStartTimestamp"].replace(':', '') + ".log"})

            logpath = os.path.join(os.path.dirname(self._path_manifest), step["LogFile"])
            try:
                os.makedirs(os.path.dirname(logpath))
            except OSError as e:
                if e.errno != errno.EEXIST:
                    raise
            log = open(logpath, "wb")
            with open(os.devnull, "r") as null_file:
                invocation = step["Invocation"]
                if invocation.lower().startswith("python.exe "):
                    invocation = "\"" + sys.executable + "\" " + step["Invocation"][len("python.exe "):]
                invocation = shlex.split(invocation)
                if os.path.splitext(invocation[0])[1].lower() in ('.cmd', '.bat'):
                    # special-case, since cmd.exe doesn't directly support UNC paths (e.g. shared folders). Scripts should also include "pushd %~dp0"
                    invocation[0] = os.path.join(os.getcwd(), os.path.dirname(self._path_manifest), invocation[0])
                log.flush()
                subprocess.check_call(invocation, stdin=null_file, stdout=log, stderr=subprocess.STDOUT,
                                      shell=False, close_fds=False,
                                      cwd=os.path.join(os.getcwd(), os.path.dirname(self._path_manifest)))
            step = self._update_step(step, {"ExecutionCompletionTimestamp": self._time})
            step = self._update_step(step, {"Status": "OK"})
            if step == self._steps[-1]:
                self._mark_manifest_status()
            return 0
        except subprocess.CalledProcessError as e:
            step = self._update_step(step, {"ExecutionCompletionTimestamp": self._time})
            step = self._update_step(step, {"Status": "FAILED"})
            self._mark_manifest_status()
            log.write(str(e))
            with open(os.path.join(os.path.dirname(os.path.abspath(self._path_manifest)), "_FAILED.txt"), "w") as failed:
                failed.write('"%s" failed:\n' % invocation)
                failed.write(str(e))
                failed.write('\n\nSee log: %s' % step["LogFile"])
            return -1
        except OSError as e:
            step = self._update_step(step, {"ExecutionCompletionTimestamp": self._time})
            step = self._update_step(step, {"Status": "FAILED"})
            self._mark_manifest_status()
            log.write(str(e))
            return -1
        finally:
            if log:
                log.close()
