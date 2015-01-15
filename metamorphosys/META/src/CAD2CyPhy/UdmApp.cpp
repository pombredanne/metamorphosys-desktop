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

#include "stdafx.h"
#include "UdmApp.h"
#include "UdmConfig.h"
#include "Uml.h"
#include "UdmUtil.h"

#include "UdmConsole.h"
#include "string_utils.h"
#include "CAD2CyPhy.h"

using namespace std;

/*********************************************************************************/
/* Initialization function. The framework calls it before preparing the backend. */
/* Initialize here the settings in the config global object.					 */
/* Return 0 if successful.														 */
/*********************************************************************************/
int CUdmApp::Initialize()
{


	// TODO: Your initialization code comes here...
	return 0;
}



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
					 std::set<Udm::Object> selectedObjects,	// Selected objects
					 long param)						// Parameters
{	

	// TODO: Your Code Comes Here...

	try 
	{

		CyPhyML::RootFolder rf = CyPhyML::RootFolder::Cast(p_backend->GetRootObject());
		// FIXME: reenable after language changes
		//CAD2CyPhy c2c;
		//c2c.UpdateMetrics(rf);				// updates every top ComponentAssembly from metrics output file

	}
	catch (udm_exception &exc)
	{
		GMEConsole::Console::writeLine("Udm exception occured! Exception description: " + (std::string)exc.what(), MSG_ERROR);
	}
	catch (...)
	{
		GMEConsole::Console::writeLine("Other exception occured!", MSG_ERROR);
	}



/************************** Demo Code - Delete It *********************/
	// Welcome
	//AfxMessageBox("Hello Udm-based Interpreter World!");
	
//	AfxMessageBox(param);

/*

	if (focusObject != Udm::null)
	{
		Uml::Class typeObj = focusObject.type();
		AfxMessageBox(((string)typeObj.name()).c_str());

		if (focusObject.type() == CyPhyML::ComponentAssembly::meta)
		{
	//		GMEConsole::Console::writeLine((string)CyPhyML::ComponentAssembly::Cast(focusObject).name(), MSG_INFO);
			AfxMessageBox("FocusObject NOT NULL");
			AfxMessageBox(((string)CyPhyML::ComponentAssembly::Cast(focusObject).name()).c_str());
		}
	}
	else
	{
		GMEConsole::Console::writeLine("Focus Object is NULL!", MSG_ERROR);
		AfxMessageBox("FocusObject is NULL");
	}
	*/

#ifdef _DEBUG
	/*
	// Displaying the name of the root object meta
	Udm::Object rootObject=p_backend->GetRootObject();
	std::string rootObjectName("Root Object's Class Name: ");
	rootObjectName+=UdmUtil::ExtractName(rootObject.type());
	AfxMessageBox(rootObjectName.c_str());

	// Displaying the focus object
	if(focusObject!=&Udm::_null)
	{
		std::string focusObjectName("Focus Object Name: ");
		focusObjectName+=UdmUtil::ExtractName(focusObject);
		AfxMessageBox(focusObjectName.c_str());
	}

	// Displaying selected objects
	if(!selectedObjects.empty())
	{
		std::string selObjNames("Selected Objects:\r\n");
		// Iterate set
		for(std::set<Udm::Object>::iterator i=selectedObjects.begin();
														i!=selectedObjects.end();i++)
		{
			selObjNames+=UdmUtil::ExtractName(*i);
			selObjNames+="\r\n";
		}
		AfxMessageBox(selObjNames.c_str());	
	*/
#endif
/****************************** Demo Code End *************************/
													
}
