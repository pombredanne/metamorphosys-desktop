/* DSblock model generated by Dymola from Modelica model componentz.ThermTB
 Dymola Version 2014 (64-bit), 2013-03-25 translated this at Fri Sep 27 11:59:28 2013

   */

#include <matrixop.h>
/* Declaration of C-structs */
/* Prototypes for functions used in model */
/* Codes used in model */
/* DSblock C-code: */

#include <moutil.c>
PreNonAliasDef(0)
PreNonAliasDef(1)
DYMOLA_STATIC const char*modelName="componentz.ThermTB";
DYMOLA_STATIC const char*usedLibraries[]={0};
DYMOLA_STATIC const char*dllLibraryPath[]={0};
DYMOLA_STATIC const char*default_dymosim_license_filename=
 "c:/users/ted/appdata/roaming/dynasim/dymola.lic";
#include <dsblock1.c>

/* Define variable names. */

#define Sections_

TranslatedEquations

BoundParameterSection
InitialSection
#if defined(DynSimStruct) || defined(BUILDFMU)
F_[0] = 0;
F_[1] = 0;
#endif
InitialSection
DefaultSection
InitializeData(0)
InitialSection
InitialSection
Init=false;InitializeData(2);Init=true;
EndInitialSection

OutputSection

DynamicsSection
W_[1] = X_[1]-X_[0];
W_[0] = DP_[1]*W_[1];
 /* Linear system of equations to solve. */
F_[0] = RememberSimple_(F_[0], 0);
SolveScalarLinearParametric(DP_[0],"term_edited.heatCapacitor.C", W_[0],
  "term_edited.port_a.Q_flow", F_[0],"der(term_edited.heatCapacitor.T)");
 /* End of Equation Block */ 

 /* Linear system of equations to solve. */
F_[1] = RememberSimple_(F_[1], 1);
SolveScalarLinearParametric(DP_[2],"heatCapacitor.C",  -W_[0]," -term_edited.port_a.Q_flow",
   F_[1],"der(heatCapacitor.T)");
 /* End of Equation Block */ 


AcceptedSection1

AcceptedSection2

DefaultSection
InitializeData(1)
EndTranslatedEquations

#include <dsblock6.c>

PreNonAliasNew(0)
StartNonAlias(0)
DeclareParameter("term_edited.heatCapacitor.C", "Heat capacity of element (= cp*m) [J/K]",\
 0, 200, 0.0,0.0,0.0,0,560)
DeclareState("term_edited.heatCapacitor.T", "Temperature of element [K|degC]", 0,\
 293.15, 0.0,1E+100,0.0,0,560)
DeclareDerivative("term_edited.heatCapacitor.der(T)", "der(Temperature of element) [K/s]",\
 0, 0.0,0.0,0.0,0,512)
DeclareAlias2("term_edited.heatCapacitor.der_T", "Time derivative of temperature (= der(T)) [K/s]",\
 "term_edited.heatCapacitor.der(T)", 1, 6, 0, 0)
DeclareAlias2("term_edited.heatCapacitor.port.T", "Port temperature [K|degC]", \
"term_edited.heatCapacitor.T", 1, 1, 0, 4)
DeclareAlias2("term_edited.heatCapacitor.port.Q_flow", "Heat flow rate (positive if flowing from outside into the component) [W]",\
 "term_edited.port_a.Q_flow", 1, 5, 0, 132)
DeclareAlias2("term_edited.port_a.T", "Port temperature [K|degC]", \
"heatCapacitor.T", 1, 1, 1, 4)
DeclareVariable("term_edited.port_a.Q_flow", "Heat flow rate (positive if flowing from outside into the component) [W]",\
 0.0, 0.0,0.0,0.0,0,776)
DeclareAlias2("term_edited.thermalConductor.Q_flow", "Heat flow rate from port_a -> port_b [W]",\
 "term_edited.port_a.Q_flow", 1, 5, 0, 0)
DeclareVariable("term_edited.thermalConductor.dT", "port_a.T - port_b.T [K,]", \
0.0, 0.0,0.0,0.0,0,512)
DeclareAlias2("term_edited.thermalConductor.port_a.T", "Port temperature [K|degC]",\
 "heatCapacitor.T", 1, 1, 1, 4)
DeclareAlias2("term_edited.thermalConductor.port_a.Q_flow", "Heat flow rate (positive if flowing from outside into the component) [W]",\
 "term_edited.port_a.Q_flow", 1, 5, 0, 132)
DeclareAlias2("term_edited.thermalConductor.port_b.T", "Port temperature [K|degC]",\
 "term_edited.heatCapacitor.T", 1, 1, 0, 4)
DeclareAlias2("term_edited.thermalConductor.port_b.Q_flow", "Heat flow rate (positive if flowing from outside into the component) [W]",\
 "term_edited.port_a.Q_flow", -1, 5, 0, 132)
DeclareParameter("term_edited.thermalConductor.G", "Constant thermal conductance of material [W/K]",\
 1, 3, 0.0,0.0,0.0,0,560)
DeclareParameter("heatCapacitor.C", "Heat capacity of element (= cp*m) [J/K]", 2,\
 10, 0.0,0.0,0.0,0,560)
DeclareState("heatCapacitor.T", "Temperature of element [K|degC]", 1, 573.15, \
0.0,1E+100,0.0,0,560)
DeclareDerivative("heatCapacitor.der(T)", "der(Temperature of element) [K/s]", 0,\
 0.0,0.0,0.0,0,512)
DeclareAlias2("heatCapacitor.der_T", "Time derivative of temperature (= der(T)) [K/s]",\
 "heatCapacitor.der(T)", 1, 6, 1, 0)
DeclareAlias2("heatCapacitor.port.T", "Port temperature [K|degC]", \
"heatCapacitor.T", 1, 1, 1, 4)
DeclareAlias2("heatCapacitor.port.Q_flow", "Heat flow rate (positive if flowing from outside into the component) [W]",\
 "term_edited.port_a.Q_flow", -1, 5, 0, 132)
EndNonAlias(0)
#define NX_    2
#define NX2_   0
#define NU_    0
#define NY_    0
#define NW_    2
#define NP_    3
#define NPS_   0
#define MAXAuxStr_   0
#define MAXAuxStrLen_   500
#define NHash1_ 548404218
#define NHash2_ -284135242
#define NHash3_ 0
#define NI_    0
#define NRelF_ 0
#define NRel_  0
#define NTim_  0
#define NSamp_ 0
#define NCons_ 0
#define NA_    12
#define SizePre_ 0
#define SizeEq_ 2
#define SizeDelay_ 0
#define QNLmax_ 0
#define MAXAux 0
#define NrDymolaTimers_ 0
#define NWhen_ 0
#define NCheckIf_ 0
#define NGlobalHelp_ 0
#ifndef NExternalObject_
#define NExternalObject_ 0
#endif

#define DymolaHaveUpdateInitVars 1
#include <dsblock5.c>

DYMOLA_STATIC void UpdateInitVars(double *time, double X_[], double XD_[], double U_[], 
double DP_[], long IP_[], Dymola_bool LP_[], double F_[], double Y_[], double W_[], double QZ_[], double duser_[], long iuser_[], void*cuser_[]) {
static Real initStore[1];
}
StartDataBlock
StartEqBlock
DoRemember_(F_[1], 0, 1);
DoRemember_(F_[0], 0, 0);
EndEqBlock
EndDataBlock
