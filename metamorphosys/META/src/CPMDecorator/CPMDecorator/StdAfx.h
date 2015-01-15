// Copyright (C) 2013-2015 MetaMorph Software, Inc

// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this data, including any software or models in source or binary
// form, as well as any drawings, specifications, and documentation
// (collectively "the Data"), to deal in the Data without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Data, and to
// permit persons to whom the Data is furnished to do so, subject to the
// following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Data.

// THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

// =======================
// This version of the META tools is a fork of an original version produced
// by Vanderbilt University's Institute for Software Integrated Systems (ISIS).
// Their license statement:

// Copyright (C) 2011-2014 Vanderbilt University

// Developed with the sponsorship of the Defense Advanced Research Projects
// Agency (DARPA) and delivered to the U.S. Government with Unlimited Rights
// as defined in DFARS 252.227-7013.

// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this data, including any software or models in source or binary
// form, as well as any drawings, specifications, and documentation
// (collectively "the Data"), to deal in the Data without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Data, and to
// permit persons to whom the Data is furnished to do so, subject to the
// following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Data.

// THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

// stdafx.h : include file for standard system include files,
//      or project specific include files that are used frequently,
//      but are changed infrequently

#if !defined(AFX_STDAFX_H__8B8917B1_B409_43D6_9604_73055641403B__INCLUDED_)
#define AFX_STDAFX_H__8B8917B1_B409_43D6_9604_73055641403B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define STRICT
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0500
#endif
#define _ATL_APARTMENT_THREADED

#include <afxwin.h>
#include <afxdisp.h>
#include <afxdlgs.h>
#include <afxcmn.h>
#include <afxcoll.h>
#include <afxtempl.h>

#include <atlbase.h>
//You may derive a class from CComModule and use it if you want to override
//something, but do not change the name of _Module
extern CComModule _Module;
#include <atlcom.h>

#ifndef __INTELLISENSE__
// Meta
#import "libid:0ADEEC71-D83A-11D3-B36B-005004D38590" no_implementation no_namespace raw_method_prefix("") high_method_prefix("imp_")
// Mga
#import "libid:270B4F86-B17C-11D3-9AD1-00AA00B6FE26" no_implementation no_namespace raw_method_prefix("") high_method_prefix("imp_")
// GME
#import "libid:0ADEEC71-D83A-11D3-B36B-005004CC8592" no_implementation no_namespace raw_method_prefix("") high_method_prefix("imp_")
// MgaUtil
#import "libid:461F30AE-3BF0-11D4-B3F0-005004D38590" no_implementation no_namespace raw_method_prefix("") high_method_prefix("imp_")
// Parser
#import "libid:70C41B15-E3CE-11D3-B37A-005004D38590" no_implementation no_namespace raw_method_prefix("") high_method_prefix("imp_")
#else
// IntelliSense has a known issue with the above lines.
//  http://connect.microsoft.com/VisualStudio/feedback/details/533526/vc-2010-intellisense-import-directive-using-libid-does-not-work
#ifdef _DEBUG
// If IntelliSense reports "Cannot open source file", compile then reopen the project
#include "Debug\Meta.tlh"
#include "Debug\Mga.tlh"
#else
#include "Release\Meta.tlh"
#include "Release\Mga.tlh"
#endif
#endif

typedef unsigned long feature_code;
#define IID_IMgaDataSource __uuidof(IMgaDataSource)
// Feature codes
// FIXME should be an enum
typedef unsigned long feature_code;
const unsigned long F_RESIZABLE	= 1<<0;
const unsigned long	F_MOUSEEVENTS =	1<<1;
const unsigned long	F_HASLABEL =	1<<2;
const unsigned long	F_HASSTATE = 1<<3;
const unsigned long	F_HASPORTS = 1<<4;
const unsigned long	F_ANIMATION = 1<<5;
const unsigned long	F_IMGPATH = 1<<6;
const unsigned long	F_RESIZEAFTERMOD = 1<<7;

#import ".\DecoratorLib.tlb" no_implementation no_namespace raw_method_prefix("") high_method_prefix("imp_")

#define LIBID_DecoratorLib __uuidof(__DecoratorLib)
#define CLSID_Decorator __uuidof(Decorator)


#include "DecoratorError.h"

#include <stdio.h>

#define GENERATEDLIBHEADER	"DecoratorLib.h"

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__8B8917B1_B409_43D6_9604_73055641403B__INCLUDED)