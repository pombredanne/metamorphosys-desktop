/*
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

// UdmApp.cpp: implementation of the CUdmApp class.
// This file was automatically generated as UdmApp.cpp
// by UDM Interpreter Wizard on Thursday, March 27, 2008 10:37:31
/*********************************************************************************/
//DesignSpaceHelper overview:
//1. if it is invoked inside a designContainer, then the design exploration starts here
//   else: a dialog will pop up to select the designcontainer
//2. run cyphy2dert to generate the desertiface xml file at backstage
//3. initially apply the default constraints(group constraint, connector compability constraint)
//4. pop up the main dialog
//5. user can manipulate the dialog, it mainly controls the constraint application
//6. if user presses button "ShowCfg", then desertIfaceback xml file will be generate
//7. a configuration list and tree will be shown up in the configuration dialog
//8. user can choose to export the selected configuration, then the CWC models will be generated

//More detailed doc about the code will come.....
/*********************************************************************************/
#include "stdafx.h"
#include "UdmApp.h"
#include "UdmConfig.h"
#include "Uml.h"
#include "CyPhyML.h"
#include "ConstraintMainDialog.h"
#include "UdmUtil.h"
#include "UdmConsole.h"

#include "DesertHelper.h"
#include "DSERootSelDialog.h"
#include "Mga.h"

using namespace CyPhyML;

CString CUdmApp::mgaPath = "";

/* 
Remarks to CUdmApp::UdmMain(...):
0.	The p_backend points to an already open backend, and the framework 
	closes it automatically. DO NOT OPEN OR CLOSE IT!
	To commit changes use p_backend->CommitEditSequence().
	To abort changes use p_backend->AbortEditSequence().
	To save changes to a different file use p_backend->SaveAs() or p_backend->CloseAs().

1.	Focus is the currently open model.

2.	The possible values for param (from GME DecoratorLib.h component_startmode_enum):
	GME_MAIN_START			=   0,
	GME_BROWSER_START		=   1,
	GME_CONTEXT_START		=   2,
	GME_EMBEDDED_START		=   3,
	GME_MENU_START			=  16,
	GME_BGCONTEXT_START		=  18,
	GME_ICON_START			=  32,
	METAMODEL_CHECK_SYNTAX	= 101

 3. The framework catches all the exceptions and reports the error in a message box,
	clean up and close the transactions aborting the changes. You can override this 
	behavior by catching udm_exception. Use udm_exception::what() to form an error 
	message.
*/

/***********************************************/
/* Main entry point for Udm-based Interpreter  */
/***********************************************/
void CUdmApp::UdmMain(
					 Udm::DataNetwork* p_backend,		// Backend pointer(already open!)
					 Udm::Object focusObject,			// Focus object
					 long param,
					bool applyConstraintsInNoninteractiveMode)						// Parameters
{	
	DesertHelper dhelper((LPCTSTR)mgaPath, *p_backend, focusObject);
	if(focusObject!=Udm::null && (Uml::IsDerivedFrom(focusObject.type(), CyPhyML::DesignContainer::meta)))
	{
		CyPhyML::DesignContainer focusRootDC = CyPhyML::DesignContainer::Cast(focusObject);
		if(focusRootDC.isInstance()) {
			GMEConsole::Console::Out::writeLine("Warning: DESERT invoked on a DesignContainer that is an instance model.\r\n");
			return;
		}
		dhelper.setRootDC(focusRootDC);
	}
	else
	{
		CyPhyML::RootFolder cyphy_rf = CyPhyML::RootFolder::Cast(p_backend->GetRootObject());
		CDSERootSelDialog dsedlg(cyphy_rf, param==GME_SILENT_MODE);
		if(dsedlg.DoModal()==IDOK)
		{
			Udm::Object sel = dsedlg.GetSelectedDSERoot();
			if(sel!=Udm::null)  
				if (Uml::IsDerivedFrom(sel.type(), CyPhyML::DesignContainer::meta))
				{
					//set the root DesignContainer
					dhelper.setRootDC(CyPhyML::DesignContainer::Cast(sel));
				}
				else
				{
					dhelper.setRootDS(CyPhyML::DesignSpace::Cast(sel));
					dhelper.setAllRootDCs(dsedlg.GetAllRootDesignContainers());
				}
			else
				return;
		}
		else
			return;
	}
	try{
		if(param!=GME_SILENT_MODE)
		{
			if(dhelper.runCyPhy2Desert())
			{
				CConstraintMainDialog dlg(&dhelper);
				dlg.DoModal();
			}
		}
		else
		{//for silent mode, like CyPhyCriticalityMeter
			dhelper.showGui = false;
			dhelper.executeAll(applyConstraintsInNoninteractiveMode);
		}

		dhelper.writeLog();
		dhelper.close();					
	}
	catch(udm_exception &exc)
	{
		dhelper.writeLog();
		dhelper.close();
		throw exc;
	}
	catch(...)
	{
		dhelper.writeLog();		
		dhelper.close();
		throw;
	}
}