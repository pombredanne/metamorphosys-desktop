#include "stdafx.h"
#include <CFDAnalysis.h>
#include <isis_ptc_toolkit_functions.h>
#include "UdmBase.h"
#include <CADPostProcessingParameters.h>
#include <ToolKitPassThroughFunctions.h>
#include <sstream>
#include <JsonHelper.h>
#include <boost/filesystem.hpp>
#include <ExteriorShell.h>


namespace isis
{

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	// If at lease one of the assemblies in in_CADAssemblies specifies cFDAnalysis == true, then return true.
	bool IsACFDAnalysisRun( const CADAssemblies &in_CADAssemblies )
	{
		for ( std::list<isis::TopLevelAssemblyData>::const_iterator i( in_CADAssemblies.topLevelAssemblies.begin()); 
				i !=  in_CADAssemblies.topLevelAssemblies.end();
				++i)
		{
			if ( i->analysesCAD.analysesCFD.size() > 0 ) return true;
		}
		return false;
	}



	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	void CreateXMLFile_ComputedValues_CFD( 
					const std::string									&in_PathAndFileName,
					const isis::CADAssemblies							&in_CADAssemblies,
					std::map<std::string, isis::CADComponentData>		&in_CADComponentData_map )
																	throw (isis::application_exception)
	{
		log4cpp::Category& logcat_fileonly = log4cpp::Category::getInstance(LOGCAT_LOGFILEONLY);

		Udm::SmartDataNetwork dn_CFDParameters ( CADPostProcessingParameters::diagram );
		dn_CFDParameters.CreateNew( in_PathAndFileName, "CADPostProcessingParameters", CADPostProcessingParameters::Components::meta);

		bool computedValues_CFD_Found = false;
		try
		{
			for each ( TopLevelAssemblyData i in in_CADAssemblies.topLevelAssemblies )
			{
				CADPostProcessingParameters::Components componentsRoot = 
						  CADPostProcessingParameters::Components::Cast(dn_CFDParameters.GetRootObject());

				componentsRoot.ConfigurationID() = i.configurationID;
	
				// Outer loop - CADAnalysisComponents  ( std::list<CADAnalysisComponent>
				// We can loop through via the following function because list<AnalysisFEA> analysisFEA can only contain 
				// one item (i.e. multiple analyses per assembly are currently not supported.


				for each ( CADComputation j in i.assemblyMetrics)
				{

					if (j.computationType == COMPUTATION_COEFFICIENT_OF_DRAG )
					{
						computedValues_CFD_Found = true;
						CADPostProcessingParameters::Component  componentRoot = CADPostProcessingParameters::Component::Create( componentsRoot );
						componentRoot.ComponentInstanceID() = j.componentID;
						componentRoot.FEAElementID() = "";
				
						CADPostProcessingParameters::Metrics metricsRoot = CADPostProcessingParameters::Metrics::Create( componentRoot );
			
						CADPostProcessingParameters::Metric metricRoot = CADPostProcessingParameters::Metric::Create( metricsRoot );
						metricRoot.MetricID()	=	j.metricID;
						metricRoot.Type()		=   ComputationType_string(j.computationType);
						metricRoot.DataFormat() =   ComputationDimension_string(j.computationDimension);
					}
				}	
			}
			if ( !computedValues_CFD_Found )
			{
				if ( dn_CFDParameters.isOpen()) dn_CFDParameters.CloseNoUpdate();
				std::stringstream errorString;
				errorString <<	"Function CreateXMLFile_ComputedValues_CFD, was invoked but in_CADAssemblies does not contain any CFD computations.";
				throw isis::application_exception(errorString.str());
				//logcat.infoStream() << "Point 11-4";
			}

			///////////////////////////
			// Write XML File
			//////////////////////////
			
			if ( dn_CFDParameters.isOpen()) dn_CFDParameters.CloseWithUpdate();
		}
		catch ( udm_exception &ex )
		{
			// If any error occurs, do not save the metrics xml file.  It makes no sense to save a computed values file
			// with erroneous data.
			if ( dn_CFDParameters.isOpen()) dn_CFDParameters.CloseNoUpdate();
			std::stringstream errorString;
			errorString <<  "Function CreateXMLFile_ComputedValues_CFD threw a udm_exception.  " << ex.what();
			throw isis::application_exception(errorString.str());
		}
		catch ( isis::application_exception& ex )
		{
			if ( dn_CFDParameters.isOpen()) dn_CFDParameters.CloseNoUpdate();
			std::stringstream errorString;
			errorString <<  "Function CreateXMLFile_ComputedValues_CFD threw an application_exception.  " << ex.what();
			throw isis::application_exception(errorString.str());
		}
		catch ( std::exception& ex )
		{
			if ( dn_CFDParameters.isOpen()) dn_CFDParameters.CloseNoUpdate();
			std::stringstream errorString;
			errorString <<  "Function CreateXMLFile_ComputedValues_CFD threw an exception.  " << ex.what();
			throw isis::application_exception(errorString.str());
		}
		catch ( ... )
		{
			if ( dn_CFDParameters.isOpen()) dn_CFDParameters.CloseNoUpdate();
			std::stringstream errorString;
			errorString <<  "Function CreateXMLFile_ComputedValues_CFD, threw an unknown excpetion";
			throw isis::application_exception(errorString.str());

		}
			
	}	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	CFD, for now, requires the following coordinate system.
	//		Z-axis pointing up, x back, and y right.
	//	CFD testbneches, will assure that the global coordinate system adheres to the above orientation.
	//  This function is a temporary solution for computing the water line.  It will be used until the
	//  slicing-the-solid function has been converted to be compatible with the /MD compiler setting.
	//
	//  Only the units of mm, mm^2, mm^3, and kg/mm^3 are supported.

	class CFD_Analyzer {
	public:
		CFD_Analyzer( 	
						const std::string								    &in_ProeIsisExtensionsDir,  // Contains template for hydrostatics.json
						const std::string									&in_WorkingDirectory,
						const isis::TopLevelAssemblyData					&in_TopLevelAssemblyData,
						std::map<std::string, isis::CADComponentData>		&in_CADComponentData_map )
																					throw (isis::application_exception);

		void analyze(const CFD_Fidelity in_fidelity);

	private:
		log4cpp::Category& m_logcat_fileonly;
		log4cpp::Category& m_logcat_consoleandfile;

		void analyze_v0();
		void analyze_v1();

		const ::boost::filesystem::path     m_ProeIsisExtensionsDir;
		const ::boost::filesystem::path     m_WorkingDirectory;
		const isis::TopLevelAssemblyData					& m_TopLevelAssemblyData;
		std::map<std::string, isis::CADComponentData>		& m_CADComponentData_map;

		const std::string m_hydrostaticsFile_fileNameOnly;
		const ::boost::filesystem::path m_hydrostaticsFile_PathAndFileName;

		double m_Assembly_Mass;				// kg/mm^3, mass of the entire assembly,  must be a positive non-zero number
		double m_Fluid_Density;				// kg/mm^3,  must be a positive non-zero number

		double m_WaterLine_Height_zAxis;		// mm
		double m_ReferenceArea;				// mm^2, This is analogous to wetted-surface-area.
		double m_DisplacedVolume;			// mm^3
		double m_HydrostaticVolume;			// mm^3

		double m_RightingMomentArm;

		double m_CG_x;
		double m_CG_y;
		double m_CG_z;

		// Will compute the following in the future, for now UpdateHydrostaticsJsonFile does not add them to the json file.
		double m_CB_x;
		double m_CB_y;
		double m_CB_z;

		std::vector< std::pair<double, double> > m_xsection_area;

		void UpdateHydrostaticsJson();
	};

	///////////////////////////////
	/**
	Update the JSON Hydrostatic file with the values obtained.
	*/
	void CFD_Analyzer::UpdateHydrostaticsJson() {

		// The following is old code, it was needed when the CFD code was creating the hydrostatics file.
		::boost::filesystem::path checkFile = m_hydrostaticsFile_PathAndFileName;
		if (!::boost::filesystem::exists(checkFile) )
		{
			std::stringstream errorString;
			errorString <<  "Function CFD_Driver, could not find "
				<< "file  " << m_hydrostaticsFile_PathAndFileName << ".  "
				<< "For CFD analysis, this file must exist.";
			throw isis::application_exception(errorString.str());
		}
		
		m_logcat_consoleandfile.infoStream() << "";
		m_logcat_consoleandfile.infoStream() << "Creating Hydrostatics File v01";	

		m_logcat_fileonly.infoStream() << log4cpp::eol
			<< "hydrostaticsFile_PathAndFileName: "  << log4cpp::eol
			<< "       " << m_hydrostaticsFile_PathAndFileName << log4cpp::eol
			<< "Fluid_Density:           "  << m_Fluid_Density << log4cpp::eol
			<< "waterLine_Height_zAxis:  "  << m_WaterLine_Height_zAxis << log4cpp::eol
			<< "referenceArea:           "  << m_ReferenceArea << log4cpp::eol
			<< "displacedVolume:         "  << m_DisplacedVolume << log4cpp::eol
			<< "hydrostaticVolume:       "  << m_HydrostaticVolume << log4cpp::eol
			<< "rightingMomentArm:       "  << m_RightingMomentArm << log4cpp::eol
			<< "cG_x:                    "  << m_CG_x << log4cpp::eol
			<< "cG_y:                    "  << m_CG_y << log4cpp::eol
			<< "cG_z:                    "  << m_CG_z << log4cpp::eol
			<< "cB_x:                    "  << m_CB_x << log4cpp::eol
			<< "cB_y:                    "  << m_CB_y << log4cpp::eol
			<< "cB_z:                    "  << m_CB_z << log4cpp::eol
			<< "xsec: (size)             "  << m_xsection_area.size() << log4cpp::eol
		;

		isis_CADCommon::UpdateHydrostaticsJsonFile( m_hydrostaticsFile_PathAndFileName,
													m_Fluid_Density,
													m_WaterLine_Height_zAxis,
													// Wetted surface area
													m_ReferenceArea,  
													m_DisplacedVolume,
													m_HydrostaticVolume,
													m_RightingMomentArm, 
													// Center of Gravity
													m_CG_x, m_CG_y, m_CG_z,
													// Center of Bouncy
													m_CB_x,  m_CB_y, m_CB_z,
													m_xsection_area);
	}


	/**
	The original placeholder analysis.
	It builds a bottom heavy bounding box approximation of the vehicle.
	*/
	void CFD_Analyzer::analyze_v0()	{

		isis_CADCommon::Point_3D	boundingBox_Point_1;
		isis_CADCommon::Point_3D	boundingBox_Point_2;
		double						boundingBoxDimensions_xyz[3];
		
		RetrieveBoundingBox_ComputeFirstIfNotAlreadyComputed(	m_TopLevelAssemblyData.assemblyComponentID,
																m_CADComponentData_map,
																boundingBox_Point_1,
																boundingBox_Point_2,
																boundingBoxDimensions_xyz );

		// {x, y, z} direction	
		double boundingBox_Length_xAxis =  abs(boundingBox_Point_2.x - boundingBox_Point_1.x);
		double boundingBox_Width_yAxis	=  abs(boundingBox_Point_2.y - boundingBox_Point_1.y);
		double boundingBox_Height_zAxis =  abs(boundingBox_Point_2.z - boundingBox_Point_1.z);

		// Must select the smallest starting z coordinate since the waterline offset is always positive
		double boundingBox_OffsetToStartOfBoundingBox_zCoordinate 
			= ( boundingBox_Point_2.z < boundingBox_Point_1.z )
				? boundingBox_Point_2.z : boundingBox_Point_1.z;

		//////////////////////////////////////
		// Should verify units are kg and mm
		/////////////////////////////////////
		// Add this check later.  Since the top assembly is mmKgs, the units should be correct
		//ProUnitsystem unitSystem;
		//isis::isis_ProMdlPrincipalunitsystemGet (in_CADComponentData_map[in_TopLevelAssemblyData.assemblyComponentID].modelHandle, &unitSystem);

		//////////////////////////////////////
		// Compute Waterline Information
		//////////////////////////////////////

		m_logcat_fileonly.infoStream() << log4cpp::eol 
			<< "HydrostaticComputations, v0" << log4cpp::eol
			<< " Inputs:" << log4cpp::eol	
			<< "   boundingBox: " << log4cpp::eol
			<< "      OffsetToStartOfBoundingBox_zCoordinate = " << boundingBox_OffsetToStartOfBoundingBox_zCoordinate << log4cpp::eol
			<< "      Height_zAxis =                           " << boundingBox_Height_zAxis << log4cpp::eol
			<< "      Width_yAxis =                            " << boundingBox_Width_yAxis << log4cpp::eol
			<< "      Length_xAxis =                           " << boundingBox_Length_xAxis << log4cpp::eol
			<< "   assembly_Mass =                             " << m_Assembly_Mass << log4cpp::eol
			<< "   Fluid_Density =                             " << m_Fluid_Density << log4cpp::eol
			<< log4cpp::eol;

		///////////////////////////////////////////////////////////////
		// Check the entries that could cause a divide by zero error.
		//////////////////////////////////////////////////////////////
		if ( boundingBox_Height_zAxis <= 0.0 ||
			 boundingBox_Width_yAxis  <= 0.0 ||
			 boundingBox_Length_xAxis <= 0.0 ||
			 m_Assembly_Mass            <= 0.0 ||
			 m_Fluid_Density             <= 0.0 )
		{
			std::stringstream errorString;
			errorString <<  "Function HydrostaticComputations_temporaryAlgorithm, recieved a zero or negative number for one of the following values:" << std::endl <<
					"   in_BoundingBox_Height_zAxis: "	<<   boundingBox_Height_zAxis << std::endl <<
					"   in_BoundingBox_Width_yAxis: "	<<   boundingBox_Width_yAxis << std::endl <<
					"   in_BoundingBox_Length_xAxis: "	<<   boundingBox_Length_xAxis << std::endl <<
					"   in_Assembly_Mass: "				<<   m_Assembly_Mass << std::endl <<
					"   in_Fluid_Density: "				<<   m_Fluid_Density; 
			throw isis::application_exception(errorString.str());
		}

		double boundingBoxVolume = boundingBox_Height_zAxis * boundingBox_Width_yAxis * boundingBox_Length_xAxis;

		// Waterline = Bounding_box_height * (1/3 + (Mass/Fluid_density/Bounding_box_volume � 1/5)*5/6)
		m_WaterLine_Height_zAxis = 
			boundingBox_Height_zAxis * 
			(1.0/3.0 
				+ (m_Assembly_Mass/m_Fluid_Density/boundingBoxVolume - 1.0/5.0) * 5.0/6.0);

		// If it would sink, set waterline to the top of the part.
		if ( m_WaterLine_Height_zAxis > boundingBox_Height_zAxis )
			m_WaterLine_Height_zAxis = boundingBox_Height_zAxis;

		// Adjust for the start of the z axis relative to the global corrdinate system.
		m_WaterLine_Height_zAxis +=  boundingBox_OffsetToStartOfBoundingBox_zCoordinate;

		// Reference_Area = (2 * Bounding_box_height * Bounding_box_width + 3 * Bounding_box_length * Bounding_box_height ) * (3/5 + (Mass/Fluid_density/Bounding_box_volume � 1/3)*3/5)
		m_ReferenceArea = 
			(2.0 * boundingBox_Height_zAxis * boundingBox_Width_yAxis 
			+ 3.0 * boundingBox_Length_xAxis * boundingBox_Height_zAxis ) 
			* (3.0/5.0 
				+ (m_Assembly_Mass/m_Fluid_Density/boundingBoxVolume - 1.0/3.0) * 3.0/5.0);

		// Hydrostatic_volume = Bounding_box_volume
		m_HydrostaticVolume = boundingBoxVolume;
	}

	/**
	Uses Creo to compute the hydrostatic values.
	The working solid is shrinkwrapped and that shrinkwrap
	is made the current model.
	The current model is then evaluated.
	*/
	void CFD_Analyzer::analyze_v1()	{
		m_logcat_fileonly.infoStream() << log4cpp::eol 
			<< "HydrostaticComputations, v1" << log4cpp::eol;	

		isis::hydrostatic::ExteriorShell ex_shell("default");
		isis::hydrostatic::PolatedSpace::ptr hydrostatic;
		ProMdl top = m_CADComponentData_map[ m_TopLevelAssemblyData.assemblyComponentID ].modelHandle;
		ex_shell.set_working_solid(static_cast<ProSolid>(top));

		ProError rc;
		const std::string hydro_shell_name = "hydrostatic_shell";
		switch( rc = ex_shell.create_shrinkwrap(hydro_shell_name) ) {
		case PRO_TK_NO_ERROR: break;
		default:
			// m_logcat_fileonly.infoStream() << "   Fluid_Density:                                       " << m_Fluid_Density;
			m_logcat_consoleandfile.errorStream() << "could not construct hydrostatic-shell";
			return;
		}
		// ex_shell.set_name(hydro_shell_name);
		// ex_shell.activate_model( hydro_shell_name );
		if (! ex_shell.has_wrapped_solid()) {
			m_logcat_consoleandfile.errorStream() << "could not load/activate hydrostatic-shell";
			return;
		}
		ex_shell.set_current_solid_to_wrapped();

		isis::hydrostatic::Result result;
		const double heel_angle = 0.0; 
		const double trim_angle = 0.0; 
		switch( rc = ex_shell.computeHydrostatic(result, false, 
			0.001, m_DisplacedVolume, heel_angle, trim_angle) ) 
		{
		case PRO_TK_NO_ERROR: break;
		default: return;
		}
		m_HydrostaticVolume = result.total_volume;

		m_WaterLine_Height_zAxis = result.depth;
		m_ReferenceArea = result.wetted_area;

		m_CB_x = result.cob[0];
		m_CB_y = result.cob[1];
		m_CB_z = result.cob[2];

		{  // compute the righting moment arm
			// v_rot = v cos q + (w x v) sin q + w(w . v)(1-cos q)
			// Rodriques rotation formula
			double ra[3];
			ra[0] = m_CB_x - m_CG_x;
			ra[1] = m_CB_y - m_CG_y;
			ra[2] = m_CB_z - m_CG_z;

			/**
			These values need to change when heel and 
			trim angles are other than 0.0
			The transverse component is the righting arm.
			*/
			double la[3];
			la[0] = 0.0;
			la[1] = 1.0;
			la[2] = 0.0; 
			
			m_RightingMomentArm = 0.0;
			for( int ix=0; ix < 3; ++ix) 
				m_RightingMomentArm += ra[ix]*la[ix];
		}

		m_xsection_area = result.xsection_area;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	CFD_Analyzer::CFD_Analyzer(	
		const std::string								    &in_ProeIsisExtensionsDir,  // Contains template for hydrostatics.json
		const std::string									&in_WorkingDirectory,
		const isis::TopLevelAssemblyData					&in_TopLevelAssemblyData,
		std::map<std::string, isis::CADComponentData>		&in_CADComponentData_map )
					throw (isis::application_exception) 
	:	m_logcat_fileonly(log4cpp::Category::getInstance(LOGCAT_LOGFILEONLY)),
		m_logcat_consoleandfile(log4cpp::Category::getInstance(LOGCAT_CONSOLEANDLOGFILE)),
		m_ProeIsisExtensionsDir(in_ProeIsisExtensionsDir), m_WorkingDirectory(in_WorkingDirectory),
		m_hydrostaticsFile_fileNameOnly("hydrostatics.json"),
		m_hydrostaticsFile_PathAndFileName(in_WorkingDirectory + "\\" + m_hydrostaticsFile_fileNameOnly),

		m_TopLevelAssemblyData(in_TopLevelAssemblyData), 
		m_CADComponentData_map(in_CADComponentData_map),
		m_RightingMomentArm(0.0), 
		m_CG_x(0.0), m_CG_y(0.0), m_CG_z(0.0), 
		m_CB_x(0.0), m_CB_y(0.0), m_CB_z(0.0)
	{ 
		ProError rc;
		std::stringstream errorString;
		m_logcat_fileonly.infoStream()
			<< " extensions dir = " << m_ProeIsisExtensionsDir << log4cpp::eol
			<< " working dir = " << m_WorkingDirectory << log4cpp::eol
			<< " working path = " << m_hydrostaticsFile_PathAndFileName << log4cpp::eol
			;

		if (! ::boost::filesystem::exists(m_ProeIsisExtensionsDir) ) {
			errorString <<  "directory not found "
				<< "[" << m_ProeIsisExtensionsDir << "]";
			throw isis::application_exception(errorString.str());
		}
	}

	/**
	CFD, for now, requires the following coordinate system.
		Z-axis pointing up, x back, and y right.
	*/
	void CFD_Analyzer::analyze( const CFD_Fidelity in_fidelity )	{
		std::stringstream errorString;
		m_logcat_fileonly.infoStream() << "fidelity = " << in_fidelity;

		//////////////////////////////////////////////////////////////////////////////
		// If there is a hydrostatics.json in the current working dir, must delete it
		//////////////////////////////////////////////////////////////////////////////
		::boost::filesystem::path deleteFile = m_hydrostaticsFile_PathAndFileName;
		if (::boost::filesystem::exists(deleteFile) ) ::boost::filesystem::remove(deleteFile);
	
		//////////////////////////////////////////////////////////////////////////////
		// Copy hydrostatics.json template to the working dir
		//////////////////////////////////////////////////////////////////////////////	
		::boost::filesystem::path hydrostaticsFileTemplate__PathAndFileName = m_ProeIsisExtensionsDir 
			/ "templates" /  m_hydrostaticsFile_fileNameOnly;
		::boost::system::error_code ec;
		::boost::filesystem::copy(hydrostaticsFileTemplate__PathAndFileName, 
			m_hydrostaticsFile_PathAndFileName, ec);
		if (ec) {
			errorString 
				<< " could not copy hydrostatic templace, "
				<< "cause = " << ec.message();
			throw isis::application_exception(errorString.str());
		}

		//////////////////////////////////////////////
		// Make sure CFD Analysis has been specified
		//////////////////////////////////////////////
		if (m_TopLevelAssemblyData.analysesCAD.analysesCFD.size() != 1 )
		{
			errorString <<  "Function CFD_Driver, for a CFD analysis, "
				<< "there must be one and only one CFD analysis defined.  "
				<< "There are " << m_TopLevelAssemblyData.analysesCAD.analysesCFD.size() << " defined.";
			throw isis::application_exception(errorString.str());
		}

		///////////////////////////////////////////////////////////////
		// Make sure HydrostaticParameters, if not exit this function
		//////////////////////////////////////////////////////////////
		list<AnalysisCFD>::const_iterator analysesCFD_itr = m_TopLevelAssemblyData.analysesCAD.analysesCFD.begin();
		std::string fluidMaterial = isis::ConvertToUpperCase(analysesCFD_itr->cADHydrostaticParameters.fluidMaterial);

		if ( !analysesCFD_itr->cADHydrostaticParameters_exist )
		{
			// This is a CFD run that does not use the Waterline/Hydrostatic information; therefore, there is not need to update the
			// Hydrostatic json file with the waterline information.
			m_logcat_consoleandfile.infoStream() 
				<< "\n\nThe CFD analysis does not use Hydrostatic/Wateline information; "
				<< "therefore, the " << m_hydrostaticsFile_fileNameOnly << " file will not be updated.";
			return;
		}
		
		////////////////////////////////////
		// Get the fluid material/density
		///////////////////////////////////
		// For now, the material should be FRESH or SALT
		if (  fluidMaterial == "FRESH" )
			m_Fluid_Density = 0.000001; // kg/mm^3
		else if (  fluidMaterial == "SALT" )
			m_Fluid_Density =  0.000001035; // kg/mm^3	
		else {
			m_logcat_fileonly.errorStream() << "\nWARNING, CFD fluid material not set to FRESH or Salt, assuming SALT.  "
				<< "Actual setting: " << fluidMaterial;
			m_Fluid_Density =  0.000001035; // kg/mm^3	
		}

		////////////////////////////////////
		// Get Assembly Mass and C.G.
		///////////////////////////////////
		ProMassProperty  mass_prop;

		isis_ProSolidMassPropertyGet_WithDescriptiveErrorMsg(m_TopLevelAssemblyData.assemblyComponentID, 
			m_CADComponentData_map, &mass_prop );

		if ( mass_prop.mass == 0 ) {
			std::stringstream errorString;
			errorString <<  "Function CFD_Driver retrieved zero mass for "
				<< "ComponentInstanceID: " << m_TopLevelAssemblyData.assemblyComponentID << ". "
				<< "Model name: " << m_CADComponentData_map[m_TopLevelAssemblyData.assemblyComponentID].name;
			throw isis::application_exception(errorString.str());
		}
		m_Assembly_Mass = mass_prop.mass;

		m_CG_x = mass_prop.center_of_gravity[0];
		m_CG_y = mass_prop.center_of_gravity[1];
		m_CG_z = mass_prop.center_of_gravity[2];

		// Compute displaced volume.
		m_DisplacedVolume = m_Assembly_Mass / m_Fluid_Density;
		m_logcat_consoleandfile.infoStream() 
			<< " hydrostatic analysis: fidelity = " << in_fidelity;

		switch( in_fidelity ) {
		case V0:
			analyze_v0();
			break;
		case V1:
			analyze_v1();
			break;
		default:
			m_logcat_consoleandfile.errorStream() << "unrecognized fidelity level " << in_fidelity;
		}
	
		UpdateHydrostaticsJson();
		m_logcat_consoleandfile.infoStream() << "   Created:    " << m_hydrostaticsFile_PathAndFileName;
	} 
	
	////////////////////////////////////////
	/**
	The externally visible function.
	*/
	void CFD_Driver( 	const CFD_Fidelity								in_fidelity,
				const std::string									&in_ExtensionDirectory,
				const std::string									&in_WorkingDirectory,
				const isis::TopLevelAssemblyData					&in_TopLevelAssemblyData,
				std::map<std::string, isis::CADComponentData>		&in_CADComponentData_map )
																			throw (isis::application_exception) 
	{
		CFD_Analyzer analyzer( in_ExtensionDirectory, in_WorkingDirectory, 
			in_TopLevelAssemblyData, in_CADComponentData_map);

		analyzer.analyze(in_fidelity);
	}

} // END namespace isis

