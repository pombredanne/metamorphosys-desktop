#!/bin/sh

# Copyright (c) 2007, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# ---
# Author: Craig Silverstein
#
# This script is meant to be run at distribution-generation time, for
# instance by autogen.sh.  It does some of the work configure would
# normally do, for windows systems.  In particular, it expands all the
# @...@ variables found in .in files, and puts them here, in the windows
# directory.
#
# This script should be run before any new release.

if [ -z "$1" ]; then
   echo "USAGE: $0 <src/ directory>"
   exit 1
fi

DLLDEF_MACRO_NAME="CTEMPLATE_DLL_DECL"

# The text we put in every .h files we create.  As a courtesy, we'll
# include a helpful comment for windows users as to how to use
# CTEMPLATE_DLL_DECL.  Apparently sed expands \n into a newline.  Good!
DLLDEF_DEFINES="\
// NOTE: if you are statically linking the template library into your binary\n\
// (rather than using the template .dll), set '/D $DLLDEF_MACRO_NAME='\n\
// as a compiler flag in your project file to turn off the dllimports.\n\
#ifndef $DLLDEF_MACRO_NAME\n\
# define $DLLDEF_MACRO_NAME  __declspec(dllimport)\n\
#endif"

# template_cache.h gets a special DEFINE to work around the
# difficulties in dll-exporting stl containers.  Ugh.
TEMPLATE_CACHE_DLLDEF_DEFINES="\
// NOTE: if you are statically linking the template library into your binary\n\
// (rather than using the template .dll), set '/D $DLLDEF_MACRO_NAME='\n\
// as a compiler flag in your project file to turn off the dllimports.\n\
#ifndef $DLLDEF_MACRO_NAME\n\
# define $DLLDEF_MACRO_NAME  __declspec(dllimport)\n\
extern template class __declspec(dllimport) std::allocator<std::string>;\n\
extern template class __declspec(dllimport) std::vector<std::string>;\n\
#else\n\
template class __declspec(dllexport) std::allocator<std::string>;\n\
template class __declspec(dllexport) std::vector<std::string>;\n\
#endif"

# Read all the windows config info into variables
# In order for the 'set' to take, this requires putting all in a subshell.
(
  while read define varname value; do
    [ "$define" != "#define" ] && continue
    eval "$varname='$value'"
  done

  # Process all the .in files in the "google" subdirectory
  mkdir -p "$1/windows/ctemplate"
  for file in "$1"/ctemplate/*.in; do
     echo "Processing $file"
     outfile="$1/windows/ctemplate/`basename $file .in`"

     if test "`basename $file`" = template_cache.h.in; then
       MY_DLLDEF_DEFINES=$TEMPLATE_CACHE_DLLDEF_DEFINES
     else
       MY_DLLDEF_DEFINES=$DLLDEF_DEFINES
     fi

     # Besides replacing @...@, we also need to turn on dllimport
     # We also need to replace hash by hash_compare (annoying we hard-code :-( )
     sed -e "s!@ac_windows_dllexport@!$DLLDEF_MACRO_NAME!g" \
         -e "s!@ac_windows_dllexport_defines@!$MY_DLLDEF_DEFINES!g" \
         -e "s!@ac_cv_cxx_hash_map@!$HASH_MAP_H!g" \
         -e "s!@ac_cv_cxx_hash_set@!$HASH_SET_H!g" \
         -e "s!@ac_cv_cxx_hash_map_class@!$HASH_NAMESPACE::hash_map!g" \
         -e "s!@ac_cv_cxx_hash_set_class@!$HASH_NAMESPACE::hash_set!g" \
         -e "s!@ac_google_attribute@!${HAVE___ATTRIBUTE__:-0}!g" \
         -e "s!@ac_google_end_namespace@!$_END_GOOGLE_NAMESPACE_!g" \
         -e "s!@ac_google_namespace@!$GOOGLE_NAMESPACE!g" \
         -e "s!@ac_google_start_namespace@!$_START_GOOGLE_NAMESPACE_!g" \
         -e "s!@ac_htmlparser_namespace@!$HTMLPARSER_NAMESPACE!g" \
         -e "s!@ac_cv_uint64@!unsigned __int64!g" \
         -e "s!@ac_cv_have_stdint_h@!0!g" \
         -e "s!@ac_cv_have_inttypes_h@!0!g" \
         -e "s!@ac_have_attribute_weak@!0!g" \
         -e "s!\\bhash\\b!hash_compare!g" \
         "$file" > "$outfile"
  done
) < "$1/windows/config.h"

echo "DONE"
