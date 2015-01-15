# Copyright (C) 2013-2015 MetaMorph Software, Inc

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this data, including any software or models in source or binary
# form, as well as any drawings, specifications, and documentation
# (collectively "the Data"), to deal in the Data without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Data, and to
# permit persons to whom the Data is furnished to do so, subject to the
# following conditions:

# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Data.

# THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

# =======================
# This version of the META tools is a fork of an original version produced
# by Vanderbilt University's Institute for Software Integrated Systems (ISIS).
# Their license statement:

# Copyright (C) 2011-2014 Vanderbilt University

# Developed with the sponsorship of the Defense Advanced Research Projects
# Agency (DARPA) and delivered to the U.S. Government with Unlimited Rights
# as defined in DFARS 252.227-7013.

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this data, including any software or models in source or binary
# form, as well as any drawings, specifications, and documentation
# (collectively "the Data"), to deal in the Data without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Data, and to
# permit persons to whom the Data is furnished to do so, subject to the
# following conditions:

# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Data.

# THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

import py_modelica_exporter as this_package
from optparse import OptionParser
import sys
import os

from exporters import ComponentExporter, TreeExporter, PackageExporter, ParsingException, ComponentAssemblyExporter

import logging
import timeit

# create logger with 'spam_application'
logger = logging.getLogger('py_modelica_exporter')
logger.setLevel(logging.DEBUG)

# create file handler which logs even debug messages
if not os.path.isdir('log'):
    os.mkdir('log')

fh = logging.FileHandler(os.path.join('log', 'py_modelica_exporter.log'))
fh.setLevel(logging.DEBUG)

# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.WARNING)

# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)

# add the handlers to the logger
logger.addHandler(fh)
logger.addHandler(ch)


# get class name to export
def main():
    parser = OptionParser()
    parser.add_option("-v", "--version", action="store_true", default=False,
                      help='Displays the version number of this package.')
    parser.add_option("-c", "--components", action="store", type="string",
                      help='A semicolon-separated list of components to export.')
    parser.add_option("-j", "--json", action="store_true", default=False,
                      help='Exports the component in json format.')
    parser.add_option("-t", "--tree", action="store", type="string",
                      help='Export tree starting from this component')
    parser.add_option("-p", "--packages", type="string", action="store",
                      help='Load semicolon-separated list of external package.mo paths')
    parser.add_option("-f", "--config", type="string", action="store",
                      help='Load list of external packages from config file')
    parser.add_option("-x", "--xml", action="store_true", default=False,
                      help='Exports the component in xml format.')
    parser.add_option("-a", "--assemblies", action="store", type="string",
                      help='A semicolon-separated list of component-assemblies to export.')
    parser.add_option("-s", "--standard", action="store_true", default=False,
                      help='List the models from the MSL')
    parser.add_option("-i", "--icons", action="store_true", default=False,
                      help='Export an icon.svg based on each model annotation.')

    (opts, args) = parser.parse_args()

    if opts.version:
        print this_package.__version__
    elif opts.components:
        if opts.packages:
            external_packages = [p for p in opts.packages.split(';') if p]
        else:
            external_packages = []

        if opts.icons:
            component_exporter = ComponentExporter(external_packages, export_icons=True)
        else:
            component_exporter = ComponentExporter(external_packages, export_icons=False)

        components_to_export = [c for c in opts.components.split(';') if c]

        extracted_components = []
        for modelica_uri in components_to_export:
            if opts.json:
                start_time = timeit.default_timer()
                extracted_components.append(component_exporter.get_component_json(modelica_uri))
                stop_time = timeit.default_timer()

                total_time = stop_time - start_time
                logger.info('Extracted info for {0} - {1} seconds'.format(modelica_uri, total_time))

        if opts.json:
            import json
            with open('modelica_components.json', 'w') as f_out:
                json.dump(extracted_components, f_out)

    elif opts.tree:
        treeToExport = opts.tree

        treeExporter = TreeExporter(treeToExport)

        if opts.json:
            #treeExporter.export_to_json(treeToExport + '.tree.json')
            treeExporter.export_to_json('ModelicaPackages.tree.json')
        if opts.xml:
            treeExporter.export_to_xml(treeToExport + '.tree.xml')

    elif opts.packages:
        external_packages = [p for p in opts.packages.split(';') if p]

        package_exporter = PackageExporter(external_packages, load_MSL=opts.standard)

        if opts.json:
            package_exporter.packageNames.sort()
            package_exporter.exportToJson('ModelicaPackages.tree.json')
            #package_exporter.exportToJson("_".join(package_exporter.externalPackageNames) + '.tree.json')

    elif opts.config:
        externalPackageFile = opts.config
        logger.info('loading packages from "{0}" ... '.format(externalPackageFile))

        package_exporter = PackageExporter(externalPackageFile, load_MSL=opts.standard)

        if opts.json:
            package_exporter.packageNames.sort()
            package_exporter.exportToJson("_".join(package_exporter.packageNames) + '.tree.json')

    elif opts.assemblies:

        if opts.packages:
            external_packages = [p for p in opts.packages.split(';') if p]
        else:
            external_packages = []
        assembly_uris = [c.strip() for c in opts.assemblies.split(';') if c]
        extracted_assemblies = []

        component_assembly_exporter = ComponentAssemblyExporter(external_packages)
        for modelica_uri in assembly_uris:
            extracted_assemblies.append(component_assembly_exporter.get_component_assembly_json(modelica_uri))

        if opts.json:
            import json
            with open('component_assemblies.json', 'w') as f_out:
                json.dump(extracted_assemblies, f_out)
    else:
        print help(this_package)

    return 0


sys.exit(main())
