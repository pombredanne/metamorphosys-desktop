// processed by FAME Modelica Library Fault-Augmentor [version 19011]

within Modelica.Mechanics;

package Rotational
 "Library to model 1-dimensional, rotational mechanical systems"
 extends Modelica.Icons.Package;

 import SI = Modelica.SIunits;

 package UsersGuide
  "User's Guide of Rotational Library"
  extends Modelica.Icons.Information;

  class Overview
   "Overview"
   extends Modelica.Icons.Information;

  annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>

<p>
This package contains components to model <b>1-dimensional rotational
mechanical</b> systems, including different types of gearboxes,
shafts with inertia, external torques, spring/damper elements,
frictional elements, backlash, elements to measure angle, angular velocity,
angular acceleration and the cut-torque of a flange. In sublibrary
<b>Examples</b> several examples are present to demonstrate the usage of
the elements. Just open the corresponding example model and simulate
the model according to the provided description.
</p>
<p>
A unique feature of this library is the <b>component-oriented</b>
modeling of <b>Coulomb friction</b> elements, such as friction in bearings,
clutches, brakes, and gear efficiency. Even (dynamically) coupled
friction elements, e.g., as in automatic gearboxes, can be handeled
<b>without</b> introducing stiffness which leads to fast simulations.
The underlying theory is new and is based on the solution of mixed
continuous/discrete systems of equations, i.e., equations where the
<b>unknowns</b> are of type <b>Real</b>, <b>Integer</b> or <b>Boolean</b>.
Provided appropriate numerical algorithms for the solution of such types of
systems are available in the simulation tool, the simulation of
(dynamically) coupled friction elements of this library is
<b>efficient</b> and <b>reliable</b>.
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/drive1.png\" ALT=\"drive1\">

<p>
A simple example of the usage of this library is given in the
figure above. This drive consists of a shaft with inertia J1=0.2 which
is connected via an ideal gearbox with gear ratio=5 to a second shaft
with inertia J2=5. The left shaft is driven via an external,
sinusoidal torque.
The <b>filled</b> and <b>non-filled grey squares</b> at the left and
right side of a component represent <b>mechanical flanges</b>.
Drawing a line between such squares means that the corresponding
flanges are <b>rigidly attached</b> to each other.
By convention in this library, the connector characterized as a
<b>filled</b> grey square is called <b>flange_a</b> and placed at the
left side of the component in the \"design view\" and the connector
characterized as a <b>non-filled</b> grey square is called <b>flange_b</b>
and placed at the right side of the component in the \"design view\".
The two connectors are completely <b>identical</b>, with the only
exception that the graphical layout is a little bit different in order
to distinguish them for easier access of the connector variables.
For example, <code>J1.flange_a.tau</code> is the cut-torque in the connector
<code>flange_a</code> of component <code>J1</code>.
</p>
<p>
The components of this
library can be <b>connected</b> together in an <b>arbitrary</b> way. E.g., it is
possible to connect two springs or two shafts with inertia directly
together, see figure below.
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/driveConnections1.png\" ALT=\"driveConnections1\">

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/driveConnections2.png\" ALT=\"driveConnections2\">

</HTML>"));
  end Overview;

  class FlangeConnectors
   "Flange Connectors"
   extends Modelica.Icons.Information;

  annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>
<p>
A flange is described by the connector class
Interfaces.<b>Flange_a</b>
or Interfaces.<b>Flange_b</b>. As already noted, the two connector
classes are completely identical. There is only a difference in the icons,
in order to easier identify a flange variable in a diagram.
Both connector classes contain the following variables:
</p>
<pre>
   Modelica.SIunits.Angle       phi  \"Absolute rotation angle of flange\";
   <b>flow</b> Modelica.SIunits.Torque tau  \"Cut-torque in the flange\";
</pre>
<p>
If needed, the angular velocity <code>w</code> and the
angular acceleration <code>a</code> of a flange connector can be
determined by differentiation of the flange angle <code>phi</code>:
</p>
<pre>
     w = <b>der</b>(phi);    a = <b>der</b>(w);
</pre>
</HTML>"));
  end FlangeConnectors;

  class SupportTorques
   "Support Torques"
   extends Modelica.Icons.Information;

  annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>

<p>The following figure shows examples of components equipped with
a support flange (framed flange in the lower center), which can be used
to fix components on the ground or on other rotating elements or to combine
them with force elements. Via Boolean parameter <b>useSupport</b>, the
support torque is enabled or disabled. If it is enabled, it must be connected.
If it is disabled, it must not be connected.
Enabled support flanges offer, e.g., the possibility to model gearboxes mounted on
the ground via spring-damper-systems (cf. example
<a href=\"modelica://Modelica.Mechanics.Rotational.Examples.ElasticBearing\">ElasticBearing</a>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/bearing.png\" ALT=\"bearing\">

<p>
Depending on the setting of <b>useSupport</b>, the icon of the corresponding
component is changing, to either show the support flange or a ground mounting.
For example, the two implementations in the following figure give
identical results.</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/bearing2.png\" ALT=\"bearing2\">

</HTML>"));
  end SupportTorques;

  class SignConventions
   "Sign Conventions"
   extends Modelica.Icons.Information;

  annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>

<p>
The variables of a component of this library can be accessed in the
usual way. However, since most of these variables are basically elements
of <b>vectors</b>, i.e., have a direction, the question arises how the
signs of variables shall be interpreted. The basic idea is explained
at hand of the following figure:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/drive2.png\" ALT=\"drive2\">

<p>
In the figure, three identical drive trains are shown. The only
difference is that the gear of the middle drive train and the
gear as well as the right inertia of the lower drive train
are horizontally flipped with regards to the upper drive train.
The signs of variables are now interpreted in the following way:
Due to the 1-dimensional nature of the model, all components are
basically connected together along one line (more complicated
cases are discussed below). First, one has to define
a <b>positive</b> direction of this line, called <b>axis of rotation</b>.
In the top part of the figure this is characterized by an arrow
defined as <code>axis of rotation</code>. The simple rule is now:
If a variable of a component is positive and can be interpreted as
the element of a vector (e.g., torque or angular velocity vector), the
corresponding vector is directed into the positive direction
of the axis of rotation. In the following figure, the right-most
inertias of the figure above are displayed with the positive
vector direction displayed according to this rule:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/drive3.png\" ALT=\"drive3\">

<p>
The cut-torques <code>J2.flange_a.tau, J4.flange_a.tau, J6.flange_b.tau</code>
of the right inertias are all identical and are directed into the
direction of rotation if the values are positive. Similiarily,
the angular velocities <code>J2.w, J4.w, J6.w</code> of the right inertias
are all identical and are also directed into the
direction of rotation if the values are positive. Some special
cases are shown in the next figure:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/drive4.png\" ALT=\"drive4\">

<p>
In the upper part of the figure, two variants of the connection of an
external torque and an inertia are shown. In both cases, a positive
signal input into the torque component accelerates the inertias
<code>inertia1, inertia2</code> into the positive axis of rotation,
i.e., the angular accelerations <code>inertia1.a, inertia2.a</code>
are positive and are directed along the \"axis of rotation\" arrow.
In the lower part of the figure the connection of inertias with
a planetary gear is shown. Note, that the three flanges of the
planetary gearbox are located along the axis of rotation and that
the axis direction determines the positive rotation along these
flanges. As a result, the positive rotation for <code>inertia4, inertia6</code>
is as indicated with the additional grey arrows.
</p>
</HTML>"));
  end SignConventions;

  class UserDefinedComponents
   "User Defined Components"
   extends Modelica.Icons.Information;

  annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>
<p>
In this section some hints are given to define your own
1-dimensional rotational components which are compatible with the
elements of this package.
It is convenient to define a new
component by inheritance from one of the following base classes,
which are defined in sublibrary Interfaces:
</p>
<table BORDER=1 CELLSPACING=0 CELLPADDING=2>
<tr><th>Name</th><th>Description</th></tr>
<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialCompliant\">PartialCompliant</a>
  </td>
  <td valign=\"top\">Compliant connection of two rotational 1-dim. flanges
                   (used for force laws such as a spring or a damper).</td>
</tr>

<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates\">PartialCompliantWithRelativeStates</a>
  </td>
  <td valign=\"top\"> Same as \"PartialCompliant\", but relative angle and relative speed are
                    defined as preferred states. Use this partial model if the force law
                    needs anyway the relative speed. The advantage is that it is usually better
                    to use relative angles between drive train components
                    as states, especially, if the angle is not limited (e.g., as for drive trains
                    in vehicles).
</td>
</tr>

<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2\">PartialElementaryTwoFlangesAndSupport2</a>
</td>
  <td valign=\"top\"> Partial model for a 1-dim. rotational gear consisting of the flange of
                    an input shaft, the flange of an output shaft and the support.
  </td>
</tr>

<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialTorque\">PartialTorque</a>
</td>
  <td valign=\"top\"> Partial model of a torque acting at the flange (accelerates the flange).
  </td>
</tr>

<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges\">PartialTwoFlanges</a>
</td>
  <td valign=\"top\">General connection of two rotational 1-dim. flanges.
  </td>
</tr>

<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialAbsoluteSensor\">PartialAbsoluteSensor</a>
</td>
  <td valign=\"top\">Measure absolute flange variables.
  </td>
</tr>

<tr>
  <td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialRelativeSensor\">PartialRelativeSensor</a>
</td>
  <td valign=\"top\">Measure relative flange variables.
  </td>
</tr>
</table>

<p>
The difference between these base classes are the auxiliary
variables defined in the model and the relations between
the flange variables already defined in the base class.
For example, in model <b>PartialCompliant</b> there is no
support flange, whereas in model
<b>PartialElementaryTwoFlangesAndSupport2</b>
there is a support flange.
</p>
<p>
The equations of a mechanical component are vector equations, i.e.,
they need to be expressed in a common coordinate system.
Therefore, for a component a <b>local axis of rotation</b> has to be
defined. All vector quantities, such as cut-torques or angular
velocities have to be expressed according to this definition.
Examples for such a definition are given in the following figure
for an inertia component and a planetary gearbox:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/driveAxis.png\" ALT=\"driveAxis\">

<p>
As can be seen, all vectors are directed into the direction
of the rotation axis. The angles in the flanges are defined
correspondingly. For example, the angle <code>sun.phi</code> in the
flange of the sun wheel of the planetary gearbox is positive,
if rotated in mathematical positive direction (= counter clock
wise) along the axis of rotation.
</p>
<p>
On first view, one may assume that the selected local
coordinate system has an influence on the usage of the
component. But this is not the case, as shown in the next figure:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/inertias.png\" ALT=\"inertias\">

<p>
In the figure the <b>local</b> axes of rotation of the components
are shown. The connection of two inertias in the left and in the
right part of the figure are completely equivalent, i.e., the right
part is just a different drawing of the left part. This is due to the
fact, that by a connection, the two local coordinate systems are
made identical and the (automatically) generated connection equations
(= angles are identical, cut-torques sum-up to zero) are also
expressed in this common coordinate system. Therefore, even if in
the left figure it seems to be that the angular velocity vector of
<code>J2</code> goes from right to left, in reality it goes from
left to right as shown in the right part of the figure, where the
local coordinate systems are drawn such that they are aligned.
Note, that the simple rule stated in section 4 (Sign conventions)
also determines that
the angular velocity of <code>J2</code> in the left part of the
figure is directed from left to right.
</p>
<p>
To summarize, the local coordinate system selected for a component
is just necessary, in order that the equations of this component
are expressed correctly. The selection of the coordinate system
is arbitrary and has no influence on the usage of the component.
Especially, the actual direction of, e.g., a cut-torque is most
easily determined by the rule of section 4. A more strict determination
by aligning coordinate systems and then using the vector direction
of the local coordinate systems, often requires a re-drawing of the
diagram and is therefore less convenient to use.
</p>
</HTML>"));
  end UserDefinedComponents;

  class RequirementsForSimulationTool
   "Requirements for Simulation Tools"
   extends Modelica.Icons.Information;

  annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>

<p>
This library is designed in a fully object oriented way in order that
components can be connected together in every meaningful combination
(e.g., direct connection of two springs or two inertias).
As a consequence, most models lead to a system of
differential-algebraic equations of <b>index 3</b> (= constraint
equations have to be differentiated twice in order to arrive at
a state space representation) and the Modelica translator or
the simulator has to cope with this system representation.
According to our present knowledge, this requires that the
Modelica translator is able to symbolically differentiate equations
(otherwise it is e.g., not possible to provide consistent initial
conditions; even if consistent initial conditions are present, most
numerical DAE integrators can cope at most with index 2 DAEs).
</p>
<p>
The elements of this library can be connected together in an
arbitrary way. However, difficulties may occur, if the elements which can <b>lock</b> the
<b>relative motion</b> between two flanges are connected <b>rigidly</b>
together such that essentially the <b>same relative motion</b> can be locked.
The reason is
that the cut-torque in the locked phase is not uniquely defined if the
elements are locked at the same time instant (i.e., there does not exist a
unique solution) and some simulation systems may not be
able to handle this situation, since this leads to a singularity during
simulation. Currently, this type of problem can occur with the
Coulomb friction elements <b>BearingFriction, Clutch, Brake, LossyGear</b> when
the elements become stuck:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/driveConnections3.png\" ALT=\"driveConnections3\">

<p>
In the figure above two typical situations are shown: In the upper part of
the figure, the series connection of rigidly attached BearingFriction and
Clutch components are shown. This does not hurt, because the BearingFriction
element can lock the relative motion between the element and the housing,
whereas the clutch element can lock the relative motion between the two
connected flanges. Contrary, the drive train in the lower part of the figure
may give rise to simulation problems, because the BearingFriction element
and the Brake element can lock the relative motion between a flange and
the housing and these flanges are rigidly connected together, i.e.,
essentially the same relative motion can be locked. These difficulties
may be solved by either introducing a compliance between these flanges
or by combining the BearingFriction and Brake element into
one component and resolving the ambiguity of the frictional torque in the
stuck mode. A tool may handle this situation also <b>automatically</b>,
by picking one solution of the infinitely many, e.g., the one where
the difference to the value of the previous time instant is as small
as possible.
</p>

</HTML>"));
  end RequirementsForSimulationTool;

  class Contact
   "Contact"
   extends Modelica.Icons.Contact;

  annotation(Documentation(info="<html>
<dl>
<dt><b>Library Officer</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> <br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e.V. (DLR)<br>
    Institut f&uuml;r Robotik und Mechatronik (DLR-RM)<br>
    Abteilung Systemdynamik und Regelungstechnik<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br><br>
</dl>

<p>
<b>Contributors to this library:</b>
</p>

<ul>
<li> <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> (DLR-RM)</li>
<li> Christian Schweiger (DLR-RM, until 2006).</li>
<li> <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
     Technical Consulting &amp; Electrical Engineering<br>
     A-3423 St.Andrae-Woerdern, Austria<br>
     email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a></li>
</ul>

</html>
"));
  end Contact;

 annotation(__Dymola_DocumentationClass=true,Documentation(info="<HTML>
<p>
Library <b>Rotational</b> is a <b>free</b> Modelica package providing
1-dimensional, rotational mechanical components to model in a convenient way
drive trains with frictional losses.
</p>

</HTML>"));
 end UsersGuide;

 package Examples
  "Demonstration examples of the components of this package"
  extends Modelica.Icons.ExamplesPackage;

  model First
   "First example: simple drive train"
   extends Modelica.Icons.Example;

   import SI = Modelica.SIunits;

  // components of First
   parameter Modelica.SIunits.Torque amplitude=10 "Amplitude of driving torque";
   parameter SI.Frequency freqHz=5 "Frequency of driving torque";
   parameter SI.Inertia Jmotor(min=0)=0.1 "Motor inertia";
   parameter SI.Inertia Jload(min=0)=2 "Load inertia";
   parameter Real ratio=10 "Gear ratio";
   parameter Real damping=10 "Damping in bearing of gear";
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{38,-48},{54,-32}},rotation=0)));
   Rotational.Sources.Torque torque(useSupport=true) annotation(Placement(transformation(extent={{-68,-8},{-52,8}},rotation=0)));
   Rotational.Components.Inertia inertia1(J=Jmotor) annotation(Placement(transformation(extent={{-38,-8},{-22,8}},rotation=0)));
   Rotational.Components.IdealGear idealGear(ratio=ratio,useSupport=true) annotation(Placement(transformation(extent={{-8,-8},{8,8}},rotation=0)));
   Rotational.Components.Inertia inertia2(J=2,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{22,-8},{38,8}},rotation=0)));
   Rotational.Components.Spring spring(c=1.e4,phi_rel(fixed=true)) annotation(Placement(transformation(extent={{52,-8},{68,8}},rotation=0)));
   Rotational.Components.Inertia inertia3(J=Jload,w(fixed=true)) annotation(Placement(transformation(extent={{82,-8},{98,8}},rotation=0)));
   Rotational.Components.Damper damper(d=damping) annotation(Placement(transformation(origin={46,-22},extent={{-8,-8},{8,8}},rotation=270)));
   Modelica.Blocks.Sources.Sine sine(amplitude=amplitude,freqHz=freqHz) annotation(Placement(transformation(extent={{-98,-8},{-82,8}},rotation=0)));

  // algorithms and equations of First
  equation
   connect(inertia1.flange_b,idealGear.flange_a) annotation(Line(points={{-22,0},{-8,0}},color={0,0,0}));
   connect(idealGear.flange_b,inertia2.flange_a) annotation(Line(points={{8,0},{22,0}},color={0,0,0}));
   connect(inertia2.flange_b,spring.flange_a) annotation(Line(points={{38,0},{52,0}},color={0,0,0}));
   connect(spring.flange_b,inertia3.flange_a) annotation(Line(points={{68,0},{82,0}},color={0,0,0}));
   connect(damper.flange_a,inertia2.flange_b) annotation(Line(points={{46,-14},{46,0},{38,0}},color={0,0,0}));
   connect(damper.flange_b,fixed.flange) annotation(Line(points={{46,-30},{46,-40}},color={0,0,0}));
   connect(sine.y,torque.tau) annotation(Line(points={{-81.2,0},{-69.6,0}},color={0,0,127}));
   connect(torque.support,fixed.flange) annotation(Line(points={{-60,-8},{-60,-40},{46,-40}},color={0,0,0}));
   connect(idealGear.support,fixed.flange) annotation(Line(points={{0,-8},{0,-40},{46,-40}},color={0,0,0}));
   connect(torque.flange,inertia1.flange_a) annotation(Line(points={{-52,0},{-38,0}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>The drive train consists of a motor inertia which is driven by
a sine-wave motor torque. Via a gearbox the rotational energy is
transmitted to a load inertia. Elasticity in the gearbox is modeled
by a spring element. A linear damper is used to model the
damping in the gearbox bearing.</p>
<p>Note, that a force component (like the damper of this example)
which is acting between a shaft and the housing has to be fixed
in the housing on one side via component Fixed.</p>
<p>Simulate for 1 second and plot the following variables:<br>
   angular velocities of inertias inertia2 and 3: inertia2.w, inertia3.w</p>

</html>"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),experiment(StopTime=1.0,Interval=0.001));
  end First;

  model FirstGrounded
   "First example: simple drive train with grounded elments"
   extends Modelica.Icons.Example;

   import SI = Modelica.SIunits;

  // components of FirstGrounded
   parameter Modelica.SIunits.Torque amplitude=10 "Amplitude of driving torque";
   parameter SI.Frequency freqHz=5 "Frequency of driving torque";
   parameter SI.Inertia Jmotor(min=0)=0.1 "Motor inertia";
   parameter SI.Inertia Jload(min=0)=2 "Load inertia";
   parameter Real ratio=10 "Gear ratio";
   parameter Real damping=10 "Damping in bearing of gear";
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{38,-48},{54,-32}},rotation=0)));
   Rotational.Sources.Torque torque(useSupport=false) annotation(Placement(transformation(extent={{-68,-8},{-52,8}},rotation=0)));
   Rotational.Components.Inertia inertia1(J=Jmotor) annotation(Placement(transformation(extent={{-38,-8},{-22,8}},rotation=0)));
   Rotational.Components.IdealGear idealGear(ratio=ratio,useSupport=false) annotation(Placement(transformation(extent={{-8,-8},{8,8}},rotation=0)));
   Rotational.Components.Inertia inertia2(J=2,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{22,-8},{38,8}},rotation=0)));
   Rotational.Components.Spring spring(c=1.e4,phi_rel(fixed=true)) annotation(Placement(transformation(extent={{52,-8},{68,8}},rotation=0)));
   Rotational.Components.Inertia inertia3(J=Jload,w(fixed=true)) annotation(Placement(transformation(extent={{82,-8},{98,8}},rotation=0)));
   Rotational.Components.Damper damper(d=damping) annotation(Placement(transformation(origin={46,-22},extent={{-8,-8},{8,8}},rotation=270)));
   Modelica.Blocks.Sources.Sine sine(amplitude=amplitude,freqHz=freqHz) annotation(Placement(transformation(extent={{-98,-8},{-82,8}},rotation=0)));

  // algorithms and equations of FirstGrounded
  equation
   connect(inertia1.flange_b,idealGear.flange_a) annotation(Line(points={{-22,0},{-8,0}},color={0,0,0}));
   connect(idealGear.flange_b,inertia2.flange_a) annotation(Line(points={{8,0},{22,0}},color={0,0,0}));
   connect(inertia2.flange_b,spring.flange_a) annotation(Line(points={{38,0},{52,0}},color={0,0,0}));
   connect(spring.flange_b,inertia3.flange_a) annotation(Line(points={{68,0},{82,0}},color={0,0,0}));
   connect(damper.flange_a,inertia2.flange_b) annotation(Line(points={{46,-14},{46,0},{38,0}},color={0,0,0}));
   connect(damper.flange_b,fixed.flange) annotation(Line(points={{46,-30},{46,-40}},color={0,0,0}));
   connect(sine.y,torque.tau) annotation(Line(points={{-81.2,0},{-69.6,0}},color={0,0,127}));
   connect(torque.flange,inertia1.flange_a) annotation(Line(points={{-52,0},{-38,0}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>The drive train consists of a motor inertia which is driven by
a sine-wave motor torque. Via a gearbox the rotational energy is
transmitted to a load inertia. Elasticity in the gearbox is modeled
by a spring element. A linear damper is used to model the
damping in the gearbox bearing.</p>
<p>Note, that a force component (like the damper of this example)
which is acting between a shaft and the housing has to be fixed
in the housing on one side via component Fixed.</p>
<p>Simulate for 1 second and plot the following variables:<br>
   angular velocities of inertias inertia2 and 3: inertia2.w, inertia3.w</p>

</HTML>"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),experiment(StopTime=1.0,Interval=0.001));
  end FirstGrounded;

  model Friction
   "Drive train with clutch and brake"
   extends Modelica.Icons.Example;

   import Modelica.Constants.pi;
   import SI = Modelica.SIunits;

  // components of Friction
   parameter SI.Time startTime=0.5 "Start time of step";
   output SI.Torque tMotor=torque.tau "Driving torque of inertia3";
   output SI.Torque tClutch=clutch.tau "Friction torque of clutch";
   output SI.Torque tBrake=brake.tau "Friction torque of brake";
   output SI.Torque tSpring=spring.tau "Spring torque";
   Rotational.Sources.Torque torque(useSupport=true) annotation(Placement(transformation(extent={{-90,-10},{-70,10}},rotation=0)));
   Rotational.Components.Inertia inertia3(J=1,phi(start=0,fixed=true,displayUnit="deg"),w(start=100,fixed=true,displayUnit="rad/s")) annotation(Placement(transformation(extent={{-60,-10},{-40,10}},rotation=0)));
   Rotational.Components.Clutch clutch(fn_max=160) annotation(Placement(transformation(extent={{-30,-10},{-10,10}},rotation=0)));
   Rotational.Components.Inertia inertia2(J=0.05,phi(start=0,fixed=true),w(start=90,fixed=true)) annotation(Placement(transformation(extent={{0,-10},{20,10}},rotation=0)));
   Rotational.Components.SpringDamper spring(c=160,d=1) annotation(Placement(transformation(extent={{30,-10},{50,10}},rotation=0)));
   Rotational.Components.Inertia inertia1(J=1,phi(start=0,fixed=true),w(start=90,fixed=true)) annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Rotational.Components.Brake brake(fn_max=1600,useSupport=true) annotation(Placement(transformation(extent={{60,-10},{80,10}},rotation=0)));
   Modelica.Blocks.Sources.Constant const(k=1) annotation(Placement(transformation(origin={-25,35},extent={{-5,-5},{15,15}},rotation=270)));
   Modelica.Blocks.Sources.Step step(startTime=startTime) annotation(Placement(transformation(origin={65,35},extent={{-5,-5},{15,15}},rotation=270)));
   Modelica.Blocks.Sources.Step step2(height=-1,offset=1,startTime=startTime) annotation(Placement(transformation(extent={{-160,-30},{-140,-10}},rotation=0)));
   Modelica.Blocks.Sources.Sine sine(amplitude=200,freqHz=50/(pi)) annotation(Placement(transformation(extent={{-160,10},{-140,30}},rotation=0)));
   Modelica.Blocks.Math.Product product annotation(Placement(transformation(extent={{-120,-10},{-100,10}},rotation=0)));
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{-10,-30},{10,-10}},rotation=0)));

  // algorithms and equations of Friction
  equation
   connect(torque.flange,inertia3.flange_a) annotation(Line(points={{-70,0},{-70,0},{-60,0}},color={0,0,0}));
   connect(inertia3.flange_b,clutch.flange_a) annotation(Line(points={{-40,0},{-30,0}},color={0,0,0}));
   connect(clutch.flange_b,inertia2.flange_a) annotation(Line(points={{-10,0},{0,0}},color={0,0,0}));
   connect(inertia2.flange_b,spring.flange_a) annotation(Line(points={{20,0},{30,0}},color={0,0,0}));
   connect(spring.flange_b,brake.flange_a) annotation(Line(points={{50,0},{60,0}},color={0,0,0}));
   connect(brake.flange_b,inertia1.flange_a) annotation(Line(points={{80,0},{80,0},{90,0}},color={0,0,0}));
   connect(sine.y,product.u1) annotation(Line(points={{-139,20},{-130,20},{-130,6},{-122,6}},color={0,0,127}));
   connect(step2.y,product.u2) annotation(Line(points={{-139,-20},{-130,-20},{-130,-6},{-126,-6},{-122,-6}},color={0,0,127}));
   connect(product.y,torque.tau) annotation(Line(points={{-99,0},{-99,0},{-92,0}},color={0,0,127}));
   connect(const.y,clutch.f_normalized) annotation(Line(points={{-20,19},{-20,12.75},{-20,11}},color={0,0,127}));
   connect(step.y,brake.f_normalized) annotation(Line(points={{70,19},{70,16},{70,11}},color={0,0,127}));
   connect(torque.support,fixed.flange) annotation(Line(points={{-80,-10},{-80,-20},{0,-20}},color={0,0,0}));
   connect(brake.support,fixed.flange) annotation(Line(points={{70,-10},{70,-20},{0,-20}},color={0,0,0}));

  annotation(Documentation(info="<html>
<p>This drive train contains a frictional <b>clutch</b> and a <b>brake</b>.
Simulate the system for 1 second using the following initial
values (defined already in the model):</p>
<pre>   inertia1.w =  90 (or brake.w)
   inertia2.w =  90
   inertia3.w = 100
</pre>
<p>Plot the output signals</p>
<pre>   tMotor      Torque of motor
   tClutch     Torque in clutch
   tBrake      Torque in brake
   tSpring     Torque in spring
</pre>
<p>as well as the absolute angular velocities of the three inertia components
(inertia1.w, inertia2.w, inertia3.w).</p>

</HTML>"),Diagram(coordinateSystem(initialScale=0.1,preserveAspectRatio=true,extent={{-180,-100},{120,100}},grid={2,2}),graphics),experiment(StopTime=3.0,Interval=0.001));
  end Friction;

  model CoupledClutches
   "Drive train with 3 dynamically coupled clutches"
   extends Modelica.Icons.Example;

   import SI = Modelica.SIunits;

  // components of CoupledClutches
   parameter SI.Frequency freqHz=0.2 "Frequency of sine function to invoke clutch1";
   parameter SI.Time T2=0.4 "Time when clutch2 is invoked";
   parameter SI.Time T3=0.9 "Time when clutch3 is invoked";
   Rotational.Components.Inertia J1(J=1,phi(fixed=true,start=0),w(start=10,fixed=true)) annotation(Placement(transformation(extent={{-70,-10},{-50,10}},rotation=0)));
   Rotational.Sources.Torque torque(useSupport=true) annotation(Placement(transformation(extent={{-100,-10},{-80,10}},rotation=0)));
   Rotational.Components.Clutch clutch1(peak=1.1,fn_max=20) annotation(Placement(transformation(extent={{-40,-10},{-20,10}},rotation=0)));
   Modelica.Blocks.Sources.Sine sin1(amplitude=10,freqHz=5) annotation(Placement(transformation(extent={{-130,-10},{-110,10}},rotation=0)));
   Modelica.Blocks.Sources.Step step1(startTime=T2) annotation(Placement(transformation(origin={25,35},extent={{-5,-5},{15,15}},rotation=270)));
   Rotational.Components.Inertia J2(J=1,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=0)));
   Rotational.Components.Clutch clutch2(peak=1.1,fn_max=20) annotation(Placement(transformation(extent={{20,-10},{40,10}},rotation=0)));
   Rotational.Components.Inertia J3(J=1,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{50,-10},{70,10}},rotation=0)));
   Rotational.Components.Clutch clutch3(peak=1.1,fn_max=20) annotation(Placement(transformation(extent={{80,-10},{100,10}},rotation=0)));
   Rotational.Components.Inertia J4(J=1,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{110,-10},{130,10}},rotation=0)));
   Modelica.Blocks.Sources.Sine sin2(amplitude=1,freqHz=freqHz,phase=1.57) annotation(Placement(transformation(origin={-35,35},extent={{-5,-5},{15,15}},rotation=270)));
   Modelica.Blocks.Sources.Step step2(startTime=T3) annotation(Placement(transformation(origin={85,35},extent={{-5,-5},{15,15}},rotation=270)));
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{-100,-30},{-80,-10}},rotation=0)));

  // algorithms and equations of CoupledClutches
  equation
   connect(torque.flange,J1.flange_a) annotation(Line(points={{-80,0},{-70,0}},color={0,0,0}));
   connect(J1.flange_b,clutch1.flange_a) annotation(Line(points={{-50,0},{-40,0}},color={0,0,0}));
   connect(clutch1.flange_b,J2.flange_a) annotation(Line(points={{-20,0},{-10,0}},color={0,0,0}));
   connect(J2.flange_b,clutch2.flange_a) annotation(Line(points={{10,0},{10,0},{20,0}},color={0,0,0}));
   connect(clutch2.flange_b,J3.flange_a) annotation(Line(points={{40,0},{50,0}},color={0,0,0}));
   connect(J3.flange_b,clutch3.flange_a) annotation(Line(points={{70,0},{80,0}},color={0,0,0}));
   connect(clutch3.flange_b,J4.flange_a) annotation(Line(points={{100,0},{110,0}},color={0,0,0}));
   connect(sin1.y,torque.tau) annotation(Line(points={{-109,0},{-102,0}},color={0,0,127}));
   connect(sin2.y,clutch1.f_normalized) annotation(Line(points={{-30,19},{-30,19},{-30,11}},color={0,0,127}));
   connect(step1.y,clutch2.f_normalized) annotation(Line(points={{30,19},{30,19},{30,10},{30,11}},color={0,0,127}));
   connect(step2.y,clutch3.f_normalized) annotation(Line(points={{90,19},{90,19},{90,11}},color={0,0,127}));
   connect(fixed.flange,torque.support) annotation(Line(points={{-90,-20},{-90,-11},{-90,-10}},color={0,0,0}));

  annotation(Documentation(info="<html>
<p>This example demonstrates how variable structure
drive trains are handeled. The drive train consists
of 4 inertias and 3 clutches, where the clutches
are controlled by input signals. The system has
2^3=8 different configurations and 3^3 = 27
different states (every clutch may be in forward
sliding, backward sliding or locked mode when the
relative angular velocity is zero). By invoking the
clutches at different time instances, the switching
of the configurations can be studied.</p>
<p>Simulate the system for 1.2 seconds with the
following initial values:<br>
J1.w = 10.</p>
<p>Plot the following variables:<br>
angular velocities of inertias (J1.w, J2.w, J3.w,
J4.w), frictional torques of clutches (clutchX.tau),
frictional mode of clutches (clutchX.mode) where
mode = -1/0/+1 means backward sliding,
locked, forward sliding.</p>

</HTML>"),__Dymola_Commands(file="modelica://Modelica/Resources/Scripts/Dymola/Mechanics/Rotational/CoupledClutches.mos"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-140,-80},{140,80}},grid={2,2}),graphics),experiment(StopTime=1.5,Interval=0.001));
  end CoupledClutches;

  model LossyGearDemo1
   "Example to show that gear efficiency may lead to stuck motion"
   extends Modelica.Icons.Example;

   import SI = Modelica.SIunits;

  // components of LossyGearDemo1
   SI.Power PowerLoss=gear.flange_a.tau*der(gear.flange_a.phi)+gear.flange_b.tau*der(gear.flange_b.phi) "Power lost in the gear";
   Rotational.Components.LossyGear gear(ratio=2,lossTable=[0, 0.5, 0.5, 0, 0],useSupport=true) annotation(Placement(transformation(extent={{-10,0},{10,20}},rotation=0)));
   Rotational.Components.Inertia Inertia1(J=1) annotation(Placement(transformation(extent={{-40,0},{-20,20}},rotation=0)));
   Rotational.Components.Inertia Inertia2(J=1.5,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{20,0},{40,20}},rotation=0)));
   Rotational.Sources.Torque torque1(useSupport=true) annotation(Placement(transformation(extent={{-70,0},{-50,20}},rotation=0)));
   Rotational.Sources.Torque torque2(useSupport=true) annotation(Placement(transformation(extent={{70,0},{50,20}},rotation=0)));
   Modelica.Blocks.Sources.Sine DriveSine(amplitude=10,freqHz=1) annotation(Placement(transformation(extent={{-100,0},{-80,20}},rotation=0)));
   Modelica.Blocks.Sources.Ramp load(height=5,duration=2,offset=-10) annotation(Placement(transformation(extent={{100,0},{80,20}},rotation=0)));
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{-10,-30},{10,-10}},rotation=0)));

  // algorithms and equations of LossyGearDemo1
  equation
   connect(Inertia1.flange_b,gear.flange_a) annotation(Line(points={{-20,10},{-10,10}},color={0,0,0}));
   connect(gear.flange_b,Inertia2.flange_a) annotation(Line(points={{10,10},{20,10}},color={0,0,0}));
   connect(torque1.flange,Inertia1.flange_a) annotation(Line(points={{-50,10},{-40,10}},color={0,0,0}));
   connect(torque2.flange,Inertia2.flange_b) annotation(Line(points={{50,10},{40,10}},color={0,0,0}));
   connect(DriveSine.y,torque1.tau) annotation(Line(points={{-79,10},{-72,10}},color={0,0,127}));
   connect(load.y,torque2.tau) annotation(Line(points={{79,10},{72,10}},color={0,0,127}));
   connect(fixed.flange,gear.support) annotation(Line(points={{0,-20},{0,0}},color={0,0,0}));
   connect(fixed.flange,torque1.support) annotation(Line(points={{0,-20},{-60,-20},{-60,0}},color={0,0,0}));
   connect(fixed.flange,torque2.support) annotation(Line(points={{0,-20},{60,-20},{60,0}},color={0,0,0}));

  annotation(Documentation(info="<html>
<p>
This model contains two inertias which are connected by an ideal
gear where the friction between the teeth of the gear is modeled in
a physical meaningful way (friction may lead to stuck mode which
locks the motion of the gear). The friction is defined by an
efficiency factor (= 0.5) for forward and backward driving condition leading
to a torque dependent friction loss. Simulate for about 0.5 seconds.
The friction in the gear will take all modes
(forward and backward rolling, as well as stuck).
</p>
<p>
You may plot:
</p>
<pre>
Inertia1.w,
Inertia2.w : angular velocities of inertias
powerLoss  : power lost in the gear
gear.mode  :  1 = forward rolling
              0 = stuck (w=0)
             -1 = backward rolling
</pre>
</HTML>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-80},{100,80}}),graphics),experiment(StopTime=0.5,Interval=0.001));
  end LossyGearDemo1;

  model LossyGearDemo2
   "Example to show combination of LossyGear and BearingFriction"
   extends Modelica.Icons.Example;

   import SI = Modelica.SIunits;

  // components of LossyGearDemo2
   SI.Power PowerLoss=gear.flange_a.tau*der(gear.flange_a.phi)+gear.flange_b.tau*der(gear.flange_b.phi) "Power lost in the gear";
   Rotational.Components.LossyGear gear(ratio=2,lossTable=[0, 0.5, 0.5, 0, 0],useSupport=true) annotation(Placement(transformation(extent={{-20,0},{0,20}},rotation=0)));
   Rotational.Components.Inertia Inertia1(J=1) annotation(Placement(transformation(extent={{-50,0},{-30,20}},rotation=0)));
   Rotational.Components.Inertia Inertia2(J=1.5,phi(fixed=true,start=0),w(fixed=true)) annotation(Placement(transformation(extent={{10,0},{30,20}},rotation=0)));
   Rotational.Sources.Torque torque1(useSupport=true) annotation(Placement(transformation(extent={{-110,0},{-90,20}},rotation=0)));
   Rotational.Sources.Torque torque2(useSupport=true) annotation(Placement(transformation(extent={{60,0},{40,20}},rotation=0)));
   Modelica.Blocks.Sources.Sine DriveSine(amplitude=10,freqHz=1) annotation(Placement(transformation(extent={{-140,0},{-120,20}},rotation=0)));
   Modelica.Blocks.Sources.Ramp load(height=5,duration=2,offset=-10) annotation(Placement(transformation(extent={{90,0},{70,20}},rotation=0)));
   Rotational.Components.BearingFriction bearingFriction(tau_pos=[0, 0.5; 1, 1],useSupport=true) annotation(Placement(transformation(extent={{-80,0},{-60,20}},rotation=0)));
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{-20,-30},{0,-10}},rotation=0)));

  // algorithms and equations of LossyGearDemo2
  equation
   connect(torque2.flange,Inertia2.flange_b) annotation(Line(points={{40,10},{30,10}},color={0,0,0}));
   connect(Inertia2.flange_a,gear.flange_b) annotation(Line(points={{10,10},{0,10}},color={0,0,0}));
   connect(gear.flange_a,Inertia1.flange_b) annotation(Line(points={{-20,10},{-30,10}},color={0,0,0}));
   connect(Inertia1.flange_a,bearingFriction.flange_b) annotation(Line(points={{-50,10},{-60,10}},color={0,0,0}));
   connect(bearingFriction.flange_a,torque1.flange) annotation(Line(points={{-80,10},{-80,10},{-90,10}},color={0,0,0}));
   connect(DriveSine.y,torque1.tau) annotation(Line(points={{-119,10},{-119,10},{-112,10}},color={0,0,127}));
   connect(load.y,torque2.tau) annotation(Line(points={{69,10},{62,10}},color={0,0,127}));
   connect(gear.support,fixed.flange) annotation(Line(points={{-10,0},{-10,-20}},color={0,0,0}));
   connect(fixed.flange,torque2.support) annotation(Line(points={{-10,-20},{50,-20},{50,0}},color={0,0,0}));
   connect(fixed.flange,bearingFriction.support) annotation(Line(points={{-10,-20},{-70,-20},{-70,0}},color={0,0,0}));
   connect(torque1.support,fixed.flange) annotation(Line(points={{-100,0},{-100,-20},{-10,-20}},color={0,0,0}));

  annotation(Documentation(info="<html>
<p>
This model contains bearing friction and gear friction (= efficiency).
If both friction models are stuck, there is no unique solution.
Still a reliable Modelica simulator, such as Dymola, should
be able to handle this situation.
</p>
<p>
Simulate for about 0.5 seconds. The friction elements are
in all modes (forward and backward rolling, as well as stuck).
</p>
<p>
You may plot:
</p>
<pre>
Inertia1.w,
Inertia2.w          : angular velocities of inertias
powerLoss           : power lost in the gear
bearingFriction.mode:  1 = forward rolling
                       0 = stuck (w=0)
                      -1 = backward rolling
gear.mode           :  1 = forward rolling
                       0 = stuck (w=0)
                      -1 = backward rolling
</pre>
<p>Note: This combination of LossyGear and BearingFriction is not recommended to use,
as component LossyGear includes the functionality of component BearingFriction
(only <i>peak</i> not supported).</p>
</HTML>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-140,-80},{100,80}}),graphics),experiment(StopTime=0.5,Interval=0.001));
  end LossyGearDemo2;

  model LossyGearDemo3
   "Example that failed in the previous version of the LossyGear version"
   extends Modelica.Icons.Example;

   import SI = Modelica.SIunits;

  // components of LossyGearDemo3
   Modelica.Mechanics.Rotational.Components.LossyGear gear(ratio=1,lossTable=[0, 0.25, 0.25, 0.625, 2.5],useSupport=false) annotation(Placement(transformation(extent={{-10,0},{10,20}},rotation=0)));
   Modelica.Mechanics.Rotational.Components.Inertia Inertia1(w(start=10),J=0.001) annotation(Placement(transformation(extent={{-40,0},{-20,20}},rotation=0)));
   Modelica.Mechanics.Rotational.Sources.Torque torque1(useSupport=false) annotation(Placement(transformation(extent={{-68,0},{-48,20}},rotation=0)));
   Modelica.Mechanics.Rotational.Sources.Torque torque2(useSupport=false) annotation(Placement(transformation(extent={{68,0},{48,20}},rotation=0)));
   Modelica.Blocks.Sources.Step step(height=0) annotation(Placement(transformation(extent={{-100,0},{-80,20}},rotation=0)));
   Modelica.Blocks.Sources.Step step1(startTime=0.5,height=1,offset=0) annotation(Placement(transformation(origin={90,10},extent={{-10,-10},{10,10}},rotation=180)));
   Modelica.Mechanics.Rotational.Components.Inertia Inertia2(J=0.001,phi(fixed=true,start=0),w(start=10,fixed=true)) annotation(Placement(transformation(extent={{20,0},{40,20}},rotation=0)));

  // algorithms and equations of LossyGearDemo3
  equation
   connect(Inertia1.flange_b,gear.flange_a) annotation(Line(points={{-20,10},{-16,10},{-10,10}},color={0,0,0}));
   connect(torque1.flange,Inertia1.flange_a) annotation(Line(points={{-48,10},{-40,10}},color={0,0,0}));
   connect(step.y,torque1.tau) annotation(Line(points={{-79,10},{-70,10}},color={0,0,127}));
   connect(gear.flange_b,Inertia2.flange_a) annotation(Line(points={{10,10},{20,10}},color={0,0,0}));
   connect(Inertia2.flange_b,torque2.flange) annotation(Line(points={{40,10},{48,10}},color={0,0,0}));
   connect(step1.y,torque2.tau) annotation(Line(points={{79,10},{74.5,10},{74.5,10},{70,10}},color={0,0,127},smooth=Smooth.None));

  annotation(Diagram(graphics),Documentation(info="<html>
<p>
This example demonstrates a situation where the driving side of the
LossyGear model is not obvious.
The version of LossyGear up to version 3.1 of package Modelica failed in this case
(no convergence of the event iteration).
</p>
</html>"),experiment(StopTime=1.0,Interval=0.001));
  end LossyGearDemo3;

  model ElasticBearing
   "Example to show possible usage of support flange"
   extends Modelica.Icons.Example;

  // components of ElasticBearing
   Rotational.Components.Inertia shaft(phi(fixed=true,start=0),w(fixed=true),J=1) annotation(Placement(transformation(extent={{-20,40},{0,60}},rotation=0)));
   Rotational.Components.Inertia load(J=50,w(fixed=true)) annotation(Placement(transformation(extent={{70,40},{90,60}},rotation=0)));
   Rotational.Components.Spring spring(c=1e3,phi_rel(fixed=true)) annotation(Placement(transformation(extent={{40,40},{60,60}},rotation=0)));
   Rotational.Components.Fixed fixed annotation(Placement(transformation(extent={{10,-70},{30,-50}},rotation=0)));
   Rotational.Components.SpringDamper springDamper(c=1e5,d=5,phi_rel(fixed=true),w_rel(fixed=true)) annotation(Placement(transformation(origin={20,-30},extent={{-10,-10},{10,10}},rotation=90)));
   Rotational.Sources.Torque torque(useSupport=true) annotation(Placement(transformation(extent={{-50,40},{-30,60}},rotation=0)));
   Modelica.Blocks.Sources.Ramp ramp(duration=5,height=100) annotation(Placement(transformation(extent={{-90,40},{-70,60}},rotation=0)));
   Rotational.Components.IdealGear idealGear(ratio=3,useSupport=true) annotation(Placement(transformation(extent={{10,40},{30,60}},rotation=0)));
   Rotational.Components.Inertia housing(J=5) annotation(Placement(transformation(origin={20,10},extent={{-10,-10},{10,10}},rotation=90)));

  // algorithms and equations of ElasticBearing
  equation
   connect(torque.flange,shaft.flange_a) annotation(Line(points={{-30,50},{-20,50}},color={0,0,0}));
   connect(spring.flange_b,load.flange_a) annotation(Line(points={{60,50},{70,50}},color={0,0,0}));
   connect(springDamper.flange_a,fixed.flange) annotation(Line(points={{20,-40},{20,-56},{20,-60}},color={0,0,0}));
   connect(shaft.flange_b,idealGear.flange_a) annotation(Line(points={{0,50},{10,50}},color={0,0,0}));
   connect(idealGear.flange_b,spring.flange_a) annotation(Line(points={{30,50},{40,50}},color={0,0,0}));
   connect(idealGear.support,housing.flange_b) annotation(Line(points={{20,40},{20,20}},color={0,0,0}));
   connect(housing.flange_a,springDamper.flange_b) annotation(Line(points={{20,0},{20,-20}},color={0,0,0}));
   connect(ramp.y,torque.tau) annotation(Line(points={{-69,50},{-69,50},{-52,50}},color={0,0,127}));
   connect(fixed.flange,torque.support) annotation(Line(points={{20,-60},{-40,-60},{-40,40}},color={0,0,0}));

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Documentation(info="<html>
<p>
This model demonstrates the usage of the bearing flange.
The gearbox is not connected rigidly to the ground, but by
a spring-damper-system. This allows examination of the gearbox
housing dynamics.</p>
<p>
Simulate for about 10 seconds and plot the angular velocities of the inertias <code>housing.w</code>,
<code>shaft.w</code> and <code>load.w</code>.</p>
</html>"),experiment(StopTime=10,Interval=0.01));
  end ElasticBearing;

  model Backlash
   "Example to demonstrate backlash"
   extends Modelica.Icons.Example;

  // components of Backlash
   Rotational.Components.Fixed fixed1 annotation(Placement(transformation(extent={{-50,50},{-30,70}})));
   Rotational.Components.SpringDamper springDamper(c=20E3,d=50,phi_nominal=1) annotation(Placement(transformation(extent={{-20,50},{0,70}})));
   Rotational.Components.Inertia inertia1(J=5,w(fixed=true,start=0),phi(fixed=true,displayUnit="deg",start=1.570796326794897)) annotation(Placement(transformation(extent={{20,50},{40,70}})));
   Rotational.Components.Fixed fixed2 annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
   Rotational.Components.ElastoBacklash elastoBacklash(c=20E3,d=50,b(displayUnit="deg")=0.7853981633974483,phi_nominal=1) annotation(Placement(transformation(extent={{-20,-50},{0,-30}})));
   Rotational.Components.Inertia inertia2(J=5,w(fixed=true,start=0),phi(fixed=true,start=1.570796326794897,displayUnit="deg")) annotation(Placement(transformation(extent={{20,-50},{40,-30}})));

  // algorithms and equations of Backlash
  equation
   connect(springDamper.flange_b,inertia1.flange_a) annotation(Line(points={{0,60},{20,60}},color={0,0,0},smooth=Smooth.None));
   connect(elastoBacklash.flange_b,inertia2.flange_a) annotation(Line(points={{0,-40},{20,-40}},color={0,0,0},smooth=Smooth.None));
   connect(fixed1.flange,springDamper.flange_a) annotation(Line(points={{-40,60},{-20,60}},color={0,0,0},smooth=Smooth.None));
   connect(fixed2.flange,elastoBacklash.flange_a) annotation(Line(points={{-40,-40},{-20,-40}},color={0,0,0},smooth=Smooth.None));

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Documentation(info="<html>
<p>
This model demonstrates the effect of a backlash on eigenfrequency, and
also that the damping torque does not lead to unphysical pulling torques
(since the ElastoBacklash model takes care of it).
</p>
</html>"),experiment(StopTime=1.0,Interval=0.001));
  end Backlash;

  model RollingWheel
   "Demonstrate coupling Rotational - Translational"
   extends Modelica.Icons.Example;

  // components of RollingWheel
   Rotational.Components.IdealRollingWheel idealRollingWheel(radius=1) annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
   Rotational.Components.Inertia inertia(J=1) annotation(Placement(transformation(extent={{-40,-10},{-20,10}})));
   Rotational.Sources.TorqueStep torqueStep(stepTorque=10,offsetTorque=0,startTime=0.1,useSupport=false) annotation(Placement(transformation(extent={{-70,-10},{-50,10}})));
   Translational.Components.Mass mass(L=0,m=1) annotation(Placement(transformation(extent={{20,-10},{40,10}})));
   Translational.Sources.QuadraticSpeedDependentForce quadraticSpeedDependentForce(f_nominal=-10,ForceDirection=false,v_nominal=5) annotation(Placement(transformation(extent={{72,-10},{52,10}})));

  // algorithms and equations of RollingWheel
  equation
   connect(torqueStep.flange,inertia.flange_a) annotation(Line(points={{-50,0},{-40,0}},color={0,0,0},smooth=Smooth.None));
   connect(inertia.flange_b,idealRollingWheel.flangeR) annotation(Line(points={{-20,0},{-10,0}},color={0,0,0},smooth=Smooth.None));
   connect(idealRollingWheel.flangeT,mass.flange_a) annotation(Line(points={{10,0},{20,0}},color={0,127,0},smooth=Smooth.None));
   connect(quadraticSpeedDependentForce.flange,mass.flange_b) annotation(Line(points={{52,0},{40,0}},color={0,127,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>
This model demonstrates the coupling between rotational and translational components:<br>
A torque (step) accelerates both the inertia (of the wheel) and the mass (of the vehicle).<br>
Du to a speed dependent force (like driving resistance), we find an eqilibrium at 5 m/s after approx. 5 s.
</p>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),experiment(StopTime=5.0,Interval=0.001));
  end RollingWheel;

  model HeatLosses
   "Demonstrate the modeling of heat losses"
   extends Modelica.Icons.Example;

  // components of HeatLosses
   Blocks.Sources.Sine sine(freqHz=5,amplitude=20) annotation(Placement(transformation(extent={{-100,20},{-80,40}})));
   Sources.Torque torque annotation(Placement(transformation(extent={{-70,20},{-50,40}})));
   Components.Inertia inertia1(J=2,phi(fixed=true,start=0),w(fixed=true,start=0)) annotation(Placement(transformation(extent={{-40,20},{-20,40}})));
   Components.Damper damper(useHeatPort=true,d=10) annotation(Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,origin={-20,10})));
   Components.Fixed fixed annotation(Placement(transformation(extent={{-30,-20},{-10,0}})));
   Thermal.HeatTransfer.Components.Convection convection annotation(Placement(transformation(extent={{20,-20},{40,-40}})));
   Thermal.HeatTransfer.Celsius.FixedTemperature TAmbient(T=25) "Ambient temperature" annotation(Placement(transformation(extent={{68,-40},{48,-20}})));
   Blocks.Sources.Constant const(k=20) annotation(Placement(transformation(extent={{0,-70},{20,-50}})));
   Components.SpringDamper springDamper(c=1e4,d=20,useHeatPort=true) annotation(Placement(transformation(extent={{-10,20},{10,40}})));
   Components.Inertia inertia2(J=2,phi(fixed=true,start=0),w(fixed=true,start=0)) annotation(Placement(transformation(extent={{20,20},{40,40}})));
   Components.ElastoBacklash elastoBacklash(c=1e5,d=100,useHeatPort=true,b(displayUnit="rad")=0.001) annotation(Placement(transformation(extent={{50,20},{70,40}})));
   Components.Inertia inertia3(J=2,phi(fixed=true,start=0),w(fixed=true,start=0)) annotation(Placement(transformation(extent={{80,20},{100,40}})));
   Components.BearingFriction bearingFriction(useHeatPort=true) annotation(Placement(transformation(extent={{110,20},{130,40}})));
   Components.Spring spring3(c=1e4) annotation(Placement(transformation(extent={{-70,70},{-50,90}})));
   Components.Inertia inertia4(J=2,phi(fixed=true,start=0),w(fixed=true,start=0)) annotation(Placement(transformation(extent={{-40,70},{-20,90}})));
   Components.LossyGear lossyGear(ratio=2,lossTable=[0, 0.8, 0.8, 1, 1; 1, 0.7, 0.7, 2, 2],useHeatPort=true) annotation(Placement(transformation(extent={{-10,70},{10,90}})));
   Components.Clutch clutch(useHeatPort=true,fn_max=10,phi_rel(fixed=true),w_rel(fixed=true)) annotation(Placement(transformation(extent={{20,70},{40,90}})));
   Components.Inertia inertia5(J=2) annotation(Placement(transformation(extent={{50,70},{70,90}})));
   Blocks.Sources.Sine sine2(freqHz=0.2,amplitude=1) annotation(Placement(transformation(extent={{0,110},{20,130}})));
   Components.Inertia inertia6(J=2) annotation(Placement(transformation(extent={{110,70},{130,90}})));
   Components.OneWayClutch oneWayClutch(phi_rel(fixed=true),w_rel(fixed=true),startForward(fixed=true),stuck(fixed=true),fn_max=1,useHeatPort=true) annotation(Placement(transformation(extent={{80,70},{100,90}})));
   Components.Brake brake(fn_max=2,useHeatPort=true) annotation(Placement(transformation(extent={{140,70},{160,90}})));

  // algorithms and equations of HeatLosses
  equation
   connect(sine.y,torque.tau) annotation(Line(points={{-79,30},{-72,30}},color={0,0,127},smooth=Smooth.None));
   connect(torque.flange,inertia1.flange_a) annotation(Line(points={{-50,30},{-40,30}},color={0,0,0},smooth=Smooth.None));
   connect(inertia1.flange_b,damper.flange_b) annotation(Line(points={{-20,30},{-20,25},{-20,20},{-20,20}},color={0,0,0},smooth=Smooth.None));
   connect(damper.flange_a,fixed.flange) annotation(Line(points={{-20,1.77636e-015},{-20,-5},{-20,-5},{-20,-10}},color={0,0,0},smooth=Smooth.None));
   connect(damper.heatPort,convection.solid) annotation(Line(points={{-30,3.55271e-015},{-30,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));
   connect(TAmbient.port,convection.fluid) annotation(Line(points={{48,-30},{40,-30}},color={191,0,0},smooth=Smooth.None));
   connect(const.y,convection.Gc) annotation(Line(points={{21,-60},{30,-60},{30,-40}},color={0,0,127},smooth=Smooth.None));
   connect(inertia1.flange_b,springDamper.flange_a) annotation(Line(points={{-20,30},{-10,30}},color={0,0,0},smooth=Smooth.None));
   connect(springDamper.heatPort,convection.solid) annotation(Line(points={{-10,20},{-10,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));
   connect(springDamper.flange_b,inertia2.flange_a) annotation(Line(points={{10,30},{20,30}},color={0,0,0},smooth=Smooth.None));
   connect(elastoBacklash.flange_a,inertia2.flange_b) annotation(Line(points={{50,30},{40,30}},color={0,0,0},smooth=Smooth.None));
   connect(elastoBacklash.heatPort,convection.solid) annotation(Line(points={{50,20},{50,0},{-10,0},{-10,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));
   connect(elastoBacklash.flange_b,inertia3.flange_a) annotation(Line(points={{70,30},{80,30}},color={0,0,0},smooth=Smooth.None));
   connect(inertia3.flange_b,bearingFriction.flange_a) annotation(Line(points={{100,30},{110,30}},color={0,0,0},smooth=Smooth.None));
   connect(convection.solid,bearingFriction.heatPort) annotation(Line(points={{20,-30},{-10,-30},{-10,0},{110,0},{110,20}},color={191,0,0},smooth=Smooth.None));
   connect(spring3.flange_b,inertia4.flange_a) annotation(Line(points={{-50,80},{-40,80}},color={0,0,0},smooth=Smooth.None));
   connect(bearingFriction.flange_b,spring3.flange_a) annotation(Line(points={{130,30},{130,48},{-70,48},{-70,80}},color={0,0,0},smooth=Smooth.None));
   connect(inertia4.flange_b,lossyGear.flange_a) annotation(Line(points={{-20,80},{-10,80}},color={0,0,0},smooth=Smooth.None));
   connect(lossyGear.heatPort,convection.solid) annotation(Line(points={{-10,70},{-10,60},{140,60},{140,0},{-10,0},{-10,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));
   connect(lossyGear.flange_b,clutch.flange_a) annotation(Line(points={{10,80},{20,80}},color={0,0,0},smooth=Smooth.None));
   connect(clutch.heatPort,convection.solid) annotation(Line(points={{20,70},{20,60},{140,60},{140,0},{-10,0},{-10,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));
   connect(clutch.flange_b,inertia5.flange_a) annotation(Line(points={{40,80},{50,80}},color={0,0,0},smooth=Smooth.None));
   connect(sine2.y,clutch.f_normalized) annotation(Line(points={{21,120},{30,120},{30,91}},color={0,0,127},smooth=Smooth.None));
   connect(inertia5.flange_b,oneWayClutch.flange_a) annotation(Line(points={{70,80},{80,80}},color={0,0,0},smooth=Smooth.None));
   connect(oneWayClutch.flange_b,inertia6.flange_a) annotation(Line(points={{100,80},{110,80}},color={0,0,0},smooth=Smooth.None));
   connect(sine2.y,oneWayClutch.f_normalized) annotation(Line(points={{21,120},{90,120},{90,91}},color={0,0,127},smooth=Smooth.None));
   connect(inertia6.flange_b,brake.flange_a) annotation(Line(points={{130,80},{140,80}},color={0,0,0},smooth=Smooth.None));
   connect(sine2.y,brake.f_normalized) annotation(Line(points={{21,120},{150,120},{150,91}},color={0,0,127},smooth=Smooth.None));
   connect(oneWayClutch.heatPort,convection.solid) annotation(Line(points={{80,70},{80,60},{140,60},{140,0},{-10,0},{-10,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));
   connect(brake.heatPort,convection.solid) annotation(Line(points={{140,70},{140,0},{-10,0},{-10,-30},{20,-30}},color={191,0,0},smooth=Smooth.None));

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{180,140}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}})),Documentation(info="<html>
<p>
This model demonstrates how to model the dissipated power of a drive train,
by enabling the heatPort of all components and connecting these heatPorts via
a convection element to the environment. The total heat flow generated by the
elements of the drive train and transported to the environment
is present in variable convection.fluid.
</p>
</html>"),experiment(StopTime=1.0,Interval=0.0001));
  end HeatLosses;

  model SimpleGearShift
   "Simple Gearshift"
   extends Modelica.Icons.Example;

  // components of SimpleGearShift
   output Modelica.SIunits.AngularVelocity wEngine=engine.w "Speed of engine";
   output Modelica.SIunits.AngularVelocity wLoad=load.w "Speed of load";
   output Real gearRatio=wLoad/(max(wEngine,1E-6)) "gear ratio load/engine";
   Modelica.Mechanics.Rotational.Sources.TorqueStep torqueStep(offsetTorque=0,startTime=0.5,stepTorque=20) annotation(Placement(transformation(extent={{-80,-20},{-60,0}})));
   Modelica.Mechanics.Rotational.Components.Inertia engine(J=1) annotation(Placement(transformation(extent={{-50,-20},{-30,0}})));
   Modelica.Mechanics.Rotational.Components.IdealPlanetary idealPlanetary(ratio=75/(50)) annotation(Placement(transformation(extent={{-10,0},{10,-20}})));
   Modelica.Mechanics.Rotational.Components.Inertia load(J=10) annotation(Placement(transformation(extent={{30,-20},{50,0}})));
   Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque quadraticSpeedDependentTorque(w_nominal(displayUnit="rpm")=10.471975511966,tau_nominal=-20) annotation(Placement(transformation(extent={{80,-20},{60,0}})));
   Modelica.Mechanics.Rotational.Components.Clutch clutch(cgeo=2,fn_max=100) annotation(Placement(transformation(extent={{-10,10},{10,30}})));
   Modelica.Mechanics.Rotational.Components.Brake brake(cgeo=2,fn_max=100) annotation(Placement(transformation(extent={{20,10},{40,30}})));
   Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent={{-10,50},{10,70}})));
   Modelica.Blocks.Sources.Constant const1(k=1) annotation(Placement(transformation(extent={{-40,50},{-20,70}})));
   Modelica.Blocks.Sources.Ramp ramp(height=1,offset=0,startTime=2,duration=0.1) annotation(Placement(transformation(extent={{-60,30},{-40,50}})));

  // algorithms and equations of SimpleGearShift
  equation
   connect(torqueStep.flange,engine.flange_a) annotation(Line(points={{-60,-10},{-50,-10}},color={0,0,0},smooth=Smooth.None));
   connect(quadraticSpeedDependentTorque.flange,load.flange_b) annotation(Line(points={{60,-10},{50,-10}},color={0,0,0},smooth=Smooth.None));
   connect(feedback.y,brake.f_normalized) annotation(Line(points={{9,60},{30,60},{30,31}},color={0,0,127},smooth=Smooth.None));
   connect(engine.flange_b,idealPlanetary.sun) annotation(Line(points={{-30,-10},{-10,-10}},color={0,0,0},smooth=Smooth.None));
   connect(idealPlanetary.sun,clutch.flange_a) annotation(Line(points={{-10,-10},{-10,20}},color={0,0,0},smooth=Smooth.None));
   connect(idealPlanetary.ring,clutch.flange_b) annotation(Line(points={{10,-10},{10,20}},color={0,0,0},smooth=Smooth.None));
   connect(idealPlanetary.ring,brake.flange_a) annotation(Line(points={{10,-10},{20,-10},{20,20}},color={0,0,0},smooth=Smooth.None));
   connect(idealPlanetary.carrier,load.flange_a) annotation(Line(points={{-10,-14},{-20,-14},{-20,-30},{30,-30},{30,-10}},color={0,0,0},smooth=Smooth.None));
   connect(const1.y,feedback.u1) annotation(Line(points={{-19,60},{-8,60}},color={0,0,127},smooth=Smooth.None));
   connect(feedback.u2,clutch.f_normalized) annotation(Line(points={{0,52},{0,31}},color={0,0,127},smooth=Smooth.None));
   connect(ramp.y,clutch.f_normalized) annotation(Line(points={{-39,40},{0,40},{0,31}},color={0,0,127},smooth=Smooth.None));

  annotation(Diagram(graphics),experiment(StopTime=5,Interval=0.01),Documentation(info="<html>
<p>This model shows how an automatic gear shift is built up from a planetary gear, a brake and a clutch. </p>
<ul>
<li>In the beginning, the clutch is free and the brake fixes the ring of the planetary. Thus we obtain a gearRatio = 1/(1 + planetary.ratio).</li>
<li>At time = 2 s, the brake frees the ring of the planetary, whereas the clutch blocks the ring and the sun. Thus we obtain a gearRatio = 1.</li>
</ul>
</html>"));
  end SimpleGearShift;

 annotation(Documentation(info="<html>
<p>
This package contains example models to demonstrate the usage of the
Modelica.Mechanics.Rotational package. Open the models and
simulate them according to the provided description in the models.
</p>

</HTML>
"));
 end Examples;

 package Components
  "Components for 1D rotational mechanical drive trains"
  extends Modelica.Icons.Package;

  model Fixed
   "Flange fixed in housing at a given angle"

  // components of Fixed
   parameter SI.Angle phi0=0 "Fixed offset angle of housing";
   Interfaces.Flange_b flange "(right) flange fixed in housing" annotation(Placement(transformation(extent={{10,-10},{-10,10}},rotation=0)));

  // algorithms and equations of Fixed
  equation
   flange.phi = phi0;

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{-150,-90},{150,-130}},lineColor={0,0,255},textString="%name"),Line(points={{-80,-40},{80,-40}},color={0,0,0}),Line(points={{80,-40},{40,-80}},color={0,0,0}),Line(points={{40,-40},{0,-80}},color={0,0,0}),Line(points={{0,-40},{-40,-80}},color={0,0,0}),Line(points={{-40,-40},{-80,-80}},color={0,0,0}),Line(points={{0,-40},{0,-10}},color={0,0,0})}),Documentation(info="<html>
<p>
The <b>flange</b> of a 1D rotational mechanical system is <b>fixed</b>
at an angle phi0 in the <b>housing</b>. May be used:
</p>
<ul>
<li> to connect a compliant element, such as a spring or a damper,
     between an inertia or gearbox component and the housing.
<li> to fix a rigid element, such as an inertia, with a specific
     angle to the housing.
</ul>

</HTML>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Line(points={{-80,-40},{80,-40}},color={0,0,0}),Line(points={{80,-40},{40,-80}},color={0,0,0}),Line(points={{40,-40},{0,-80}},color={0,0,0}),Line(points={{0,-40},{-40,-80}},color={0,0,0}),Line(points={{-40,-40},{-80,-80}},color={0,0,0}),Line(points={{0,-40},{0,-4}},color={0,0,0})}));
  end Fixed;

  model Inertia
   "1D-rotational component with inertia"

   import SI = Modelica.SIunits;

  // locally defined classes in Inertia
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Inertia
   Modelica.SIunits.AngularVelocity w(stateSelect=stateSelect) "Absolute angular velocity of component (= der(phi))" annotation(Dialog(group="Initialization",showStartAttribute=true));
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter StateSelect stateSelect=StateSelect.default "Priority to use phi and w as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   Modelica.SIunits.AngularAcceleration a "Absolute angular acceleration of component (= der(w))" annotation(Dialog(group="Initialization",showStartAttribute=true));
   Modelica.SIunits.Angle phi(stateSelect=stateSelect) "Absolute rotation angle of component" annotation(Dialog(group="Initialization",showStartAttribute=true));
   parameter Modelica.SIunits.Inertia J(min=0,start=1) "Moment of inertia";

  // algorithms and equations of Inertia
  equation
   phi = _famefault_flange_a.port_b.phi;
   phi = _famefault_flange_b.port_b.phi;
   w = der(phi);
   a = der(w);
   J*a = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Rotational component with <b>inertia</b> and two rigidly connected flanges.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,10},{-50,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{50,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-80,-25},{-60,-25}},color={0,0,0}),Line(points={{60,-25},{80,-25}},color={0,0,0}),Line(points={{-70,-25},{-70,-70}},color={0,0,0}),Line(points={{70,-25},{70,-70}},color={0,0,0}),Line(points={{-80,25},{-60,25}},color={0,0,0}),Line(points={{60,25},{80,25}},color={0,0,0}),Line(points={{-70,45},{-70,25}},color={0,0,0}),Line(points={{70,45},{70,25}},color={0,0,0}),Line(points={{-70,-70},{70,-70}},color={0,0,0}),Rectangle(extent={{-50,50},{50,-50}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-150,100},{150,60}},textString="%name",lineColor={0,0,255}),Text(extent={{-150,-80},{150,-120}},lineColor={0,0,0},textString="J=%J")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end Inertia;

  model Disc
   "1-dim. rotational rigid component without inertia, where right flange is rotated by a fixed angle with respect to left flange"

   import SI = Modelica.SIunits;

  // locally defined classes in Disc
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Disc
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.SIunits.Angle phi "Absolute rotation angle of component";
   parameter Modelica.SIunits.Angle deltaPhi=0 "Fixed rotation of left flange with respect to right flange (= flange_b.phi - flange_a.phi)";

  // algorithms and equations of Disc
  equation
   _famefault_flange_a.port_b.phi = phi-deltaPhi/(2);
   _famefault_flange_b.port_b.phi = phi+deltaPhi/(2);
   0 = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Rotational component with two rigidly connected flanges without <b>inertia</b>.
The right flange is rotated by the fixed angle \"deltaPhi\" with respect to the left
flange.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,10},{99,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-10,50},{10,-50}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-150,100},{150,60}},textString="%name",lineColor={0,0,255}),Rectangle(extent={{-30,50},{-10,10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{10,-10},{30,-50}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-160,-62},{160,-87}},lineColor={0,0,0},textString="deltaPhi = %deltaPhi")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end Disc;

  model Spring
   "Linear 1D rotational spring"

  // locally defined classes in Spring
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

   model _famefaults_c
    extends FAME.Parametric.BaseParametricFault(amount=0.0);

   // locally defined classes in _famefaults_c

    type Modes = enumeration(Nominal, Fatigue);

   // components of _famefaults_c
    parameter Modes mode=Modes.Nominal;

   // algorithms and equations of _famefaults_c
   equation
    if mode==Modes.Fatigue then
     y = u*(1-amount);
    else
     y = u;
    end if;
   end _famefaults_c;

  // components of Spring
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter Modelica.SIunits.RotationalSpringConstant c(final min=0,start=1.0e5) "Spring constant";
   _famefaults_c _famefault_c(u=c);
   Modelica.SIunits.Angle phi_rel(start=0) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
   parameter Modelica.SIunits.Angle phi_rel0=0 "Unstretched spring angle";

  // algorithms and equations of Spring
  equation
   tau = _famefault_c.y*(phi_rel-phi_rel0);
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   _famefault_flange_b.port_b.tau = tau;
   _famefault_flange_a.port_b.tau = -tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
A <b>linear 1D rotational spring</b>. The component can be connected either
between two inertias/gears to describe the shaft elasticity, or between
a inertia/gear and the housing (component Fixed), to describe
a coupling of the element with the housing via a spring.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,80},{150,40}},textString="%name",lineColor={0,0,255}),Text(extent={{-150,-40},{150,-80}},lineColor={0,0,0},textString="c=%c"),Line(points={{-100,0},{-58,0},{-43,-30},{-13,30},{17,-30},{47,30},{62,0},{100,0}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-68,0},{-68,65}},color={128,128,128}),Line(points={{72,0},{72,65}},color={128,128,128}),Line(points={{-68,60},{72,60}},color={128,128,128}),Polygon(points={{62,63},{72,60},{62,57},{62,63}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{-22,62},{18,87}},lineColor={0,0,255},textString="phi_rel"),Line(points={{-96,0},{-60,0},{-42,-32},{-12,30},{18,-30},{48,28},{62,0},{96,0}},color={0,0,255})}));
  end Spring;

  model Damper
   "Linear 1D rotational damper"

  // locally defined classes in Damper
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Damper
   parameter Modelica.SIunits.RotationalDampingConstant d(final min=0,start=0) "Damping constant";
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=phi_nominal) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
   parameter Modelica.SIunits.Angle phi_nominal(displayUnit="rad")=1e-4 "Nominal value of phi_rel (used for scaling)" annotation(Dialog(tab="Advanced"));
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity (= der(phi_rel))";
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration (= der(w_rel))";
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";

  // algorithms and equations of Damper
  equation
   tau = d*w_rel;
   lossPower = tau*w_rel;
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   _famefault_flange_b.port_b.tau = tau;
   _famefault_flange_a.port_b.tau = -tau;
   connect(heatPort,_famefault_heatPort.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
<b>Linear, velocity dependent damper</b> element. It can be either connected
between an inertia or gear and the housing (component Fixed), or
between two inertia/gear elements.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-90,0},{-60,0}},color={0,0,0}),Line(points={{-60,-30},{-60,30}},color={0,0,0}),Line(points={{-60,-30},{60,-30}},color={0,0,0}),Line(points={{-60,30},{60,30}},color={0,0,0}),Rectangle(extent={{-60,30},{30,-30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{30,0},{90,0}},color={0,0,0}),Text(extent={{-150,80},{150,40}},textString="%name",lineColor={0,0,255}),Text(extent={{-150,-50},{150,-90}},lineColor={0,0,0},textString="d=%d"),Line(visible=useHeatPort,points={{-100,-100},{-100,-40},{-20,-40},{-20,0}},color={191,0,0},smooth=Smooth.None,pattern=LinePattern.Dot)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-96,0},{-60,0}},color={0,0,0}),Line(points={{-60,-30},{-60,30}},color={0,0,0}),Line(points={{-60,-30},{60,-30}},color={0,0,0}),Line(points={{-60,30},{60,30}},color={0,0,0}),Rectangle(extent={{-60,30},{30,-30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{30,0},{96,0}},color={0,0,0}),Line(points={{-68,0},{-68,65}},color={128,128,128}),Text(extent={{-40,66},{33,85}},lineColor={0,0,255},textString="phi_rel"),Line(points={{-68,60},{72,60}},color={128,128,128}),Line(points={{72,0},{72,65}},color={128,128,128}),Polygon(points={{62,63},{72,60},{62,57},{62,63}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid)}));
  end Damper;

  model SpringDamper
   "Linear 1D rotational spring and damper in parallel"

   import SI = Modelica.SIunits;

  // locally defined classes in SpringDamper
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;

   model _famefaults_c
    extends FAME.Parametric.BaseParametricFault(amount=0.0);

   // locally defined classes in _famefaults_c

    type Modes = enumeration(Nominal, Fatigue);

   // components of _famefaults_c
    parameter Modes mode=Modes.Nominal;

   // algorithms and equations of _famefaults_c
   equation
    if mode==Modes.Fatigue then
     y = u*(1-amount);
    else
     y = u;
    end if;
   end _famefaults_c;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of SpringDamper
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   parameter Modelica.SIunits.RotationalDampingConstant d(final min=0,start=0) "Damping constant";
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   parameter Modelica.SIunits.RotationalSpringConstant c(final min=0,start=1.0e5) "Spring constant";
   _famefaults_c _famefault_c(u=c);
   parameter Modelica.SIunits.Angle phi_rel0=0 "Unstretched spring angle";
   parameter Modelica.SIunits.Angle phi_nominal(displayUnit="rad")=1e-4 "Nominal value of phi_rel (used for scaling)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity (= der(phi_rel))";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration (= der(w_rel))";
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=phi_nominal) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
  protected
   Modelica.SIunits.Torque tau_c "Spring torque";
   Modelica.SIunits.Torque tau_d "Damping torque";

  // algorithms and equations of SpringDamper
  equation
   tau_c = _famefault_c.y*(phi_rel-phi_rel0);
   tau_d = d*w_rel;
   tau = tau_c+tau_d;
   lossPower = tau_d*w_rel;
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   _famefault_flange_b.port_b.tau = tau;
   _famefault_flange_a.port_b.tau = -tau;
   connect(heatPort,_famefault_heatPort.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
A <b>spring</b> and <b>damper</b> element <b>connected in parallel</b>.
The component can be
connected either between two inertias/gears to describe the shaft elasticity
and damping, or between an inertia/gear and the housing (component Fixed),
to describe a coupling of the element with the housing via a spring/damper.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-80,40},{-60,40},{-45,10},{-15,70},{15,10},{45,70},{60,40},{80,40}},color={0,0,0}),Line(points={{-80,40},{-80,-40}},color={0,0,0}),Line(points={{-80,-40},{-50,-40}},color={0,0,0}),Rectangle(extent={{-50,-10},{40,-70}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{-50,-10},{70,-10}},color={0,0,0}),Line(points={{-50,-70},{70,-70}},color={0,0,0}),Line(points={{40,-40},{80,-40}},color={0,0,0}),Line(points={{80,40},{80,-40}},color={0,0,0}),Line(points={{-90,0},{-80,0}},color={0,0,0}),Line(points={{80,0},{90,0}},color={0,0,0}),Text(extent={{-150,-144},{150,-104}},lineColor={0,0,0},textString="d=%d"),Text(extent={{-190,110},{190,70}},lineColor={0,0,255},textString="%name"),Text(extent={{-150,-108},{150,-68}},lineColor={0,0,0},textString="c=%c"),Line(visible=useHeatPort,points={{-100,-100},{-100,-55},{-5,-55}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-80,32},{-58,32},{-43,2},{-13,62},{17,2},{47,62},{62,32},{80,32}},color={0,0,0},thickness=0.5),Line(points={{-68,32},{-68,97}},color={128,128,128}),Line(points={{72,32},{72,97}},color={128,128,128}),Line(points={{-68,92},{72,92}},color={128,128,128}),Polygon(points={{62,95},{72,92},{62,89},{62,95}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{-44,79},{29,91}},lineColor={0,0,255},textString="phi_rel"),Rectangle(extent={{-50,-20},{40,-80}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{-50,-80},{68,-80}},color={0,0,0}),Line(points={{-50,-20},{68,-20}},color={0,0,0}),Line(points={{40,-50},{80,-50}},color={0,0,0}),Line(points={{-80,-50},{-50,-50}},color={0,0,0}),Line(points={{-80,32},{-80,-50}},color={0,0,0}),Line(points={{80,32},{80,-50}},color={0,0,0}),Line(points={{-96,0},{-80,0}},color={0,0,0}),Line(points={{96,0},{80,0}},color={0,0,0})}));
  end SpringDamper;

  model ElastoBacklash
   "Backlash connected in series to linear spring and damper (backlash is modeled with elasticity)"

   import SI = Modelica.SIunits;

  // locally defined classes in ElastoBacklash
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of ElastoBacklash
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   parameter Modelica.SIunits.RotationalDampingConstant d(final min=0,start=0) "Damping constant";
   parameter Modelica.SIunits.Angle b(final min=0)=0 "Total backlash";
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   parameter Modelica.SIunits.RotationalSpringConstant c(final min=Modelica.Constants.small,start=1.0e5) "Spring constant (c > 0 required)";
   parameter Modelica.SIunits.Angle phi_rel0=0 "Unstretched spring angle";
   parameter Modelica.SIunits.Angle phi_nominal(displayUnit="rad")=1e-4 "Nominal value of phi_rel (used for scaling)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity (= der(phi_rel))";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration (= der(w_rel))";
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=phi_nominal) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
  protected
   Modelica.SIunits.Angle phi_diff=phi_rel-phi_rel0;
   Modelica.SIunits.Torque tau_c;
   Modelica.SIunits.Torque tau_d;
   constant Modelica.SIunits.Angle bEps=1e-10 "Minimum backlash";
   final parameter Modelica.SIunits.Angle bMax=b/(2) "Backlash in range bMin <= phi_rel - phi_rel0 <= bMax";
   final parameter Modelica.SIunits.Angle bMin=-bMax "Backlash in range bMin <= phi_rel - phi_rel0 <= bMax";

  // algorithms and equations of ElastoBacklash
  equation
   if initial() then
    tau_c = (if phi_diff>(1.5*bMax) then c*(phi_diff-bMax) else (if phi_diff<(1.5*bMin) then c*(phi_diff-bMin) else c/(3)*phi_diff));
    tau_d = d*w_rel;
    tau = tau_c+tau_d;
    lossPower = tau_d*w_rel;
   else
    tau_c = (if abs(b)<=bEps then c*phi_diff else (if phi_diff>bMax then c*(phi_diff-bMax) else (if phi_diff<bMin then c*(phi_diff-bMin) else 0)));
    tau_d = d*w_rel;
    tau = (if abs(b)<=bEps then tau_c+tau_d else (if phi_diff>bMax then smooth(0,noEvent((if (tau_c+tau_d)<=0 then 0 else tau_c+min(tau_c,tau_d)))) else (if phi_diff<bMin then smooth(0,noEvent((if (tau_c+tau_d)>=0 then 0 else tau_c+max(tau_c,tau_d)))) else 0)));
    lossPower = (if abs(b)<=bEps then tau_d*w_rel else (if phi_diff>bMax then smooth(0,noEvent((if (tau_c+tau_d)<=0 then 0 else min(tau_c,tau_d)*w_rel))) else (if phi_diff<bMin then smooth(0,noEvent((if (tau_c+tau_d)>=0 then 0 else max(tau_c,tau_d)*w_rel))) else 0)));
   end if;
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   _famefault_flange_b.port_b.tau = tau;
   _famefault_flange_a.port_b.tau = -tau;
   connect(heatPort,_famefault_heatPort.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
This element consists of a <b>backlash</b> element <b>connected in series</b>
to a <b>spring</b> and <b>damper</b> element which are <b>connected in parallel</b>.
The spring constant shall be non-zero, otherwise the component cannot be used.
</p>

<p>
In combination with components IdealGear, the ElastoBacklash model
can be used to model a gear box with backlash, elasticity and damping.
</p>

<p>
During initialization, the backlash characteristic is replaced by a continuous
approximation in the backlash region, in order to reduce problems during
initialization, especially for inverse models.
</p>

<p>
If the backlash b is smaller as 1e-10 rad (especially, if b=0),
then the backlash is ignored and the component reduces to a spring/damper
element in parallel.
</p>

<p>
In the backlash region (-b/2 &le; flange_b.phi - flange_a.phi - phi_rel0 &le; b/2) no torque
is exerted (flange_b.tau = 0). Outside of this region, contact is present and
the contact torque is basically computed with a linear
spring/damper characteristic:
</p>

<pre>
   desiredContactTorque = c*phi_contact + d*<b>der</b>(phi_contact)

            phi_contact = phi_rel - phi_rel0 - b/2 <b>if</b> phi_rel - phi_rel0 &gt;  b/2
                        = phi_rel - phi_rel0 + b/2 <b>if</b> phi_rel - phi_rel0 &lt; -b/2

            phi_rel     = flange_b.phi - flange_a.phi;
</pre>

<p>
This torque characteristic leads to the following difficulties:
</p>

<ol>
<li> If the damper torque becomes larger as the spring torque and with opposite sign,
     the contact torque would be \"pulling/sticking\" which is unphysical, since during
     contact only pushing torques can occur.</li>

<li> When contact occurs with a non-zero relative speed (which is the usual
     situation), the damping torque has a non-zero value and therefore the contact
     torque changes discontinuously at phi_rel = phi_rel0. Again, this is not physical
     because the torque can only change continuously. (Note, this component is not an
     idealized model where a steep characteristic is approximated by a discontinuity,
     but it shall model the steep characteristic.)</li>
</ol>

<p>
In the literature there are several proposals to fix problem (2). However, there
seems to be no proposal to avoid sticking. For this reason, the most simple
approach is used in the ElastoBacklash model, to fix both problems by slight changes
to the linear spring/damper characteristic:
</p>

<pre>
    // Torque characteristic when phi_rel > phi_rel0
    <b>if</b> phi_rel - phi_rel0 &lt; b/2 <b>then</b>
       tau_c = 0;          // spring torque
       tau_d = 0;          // damper torque
       flange_b.tau = 0;
    <b>else</b>
       tau_c = c*(phi_rel - phi_rel0);    // spring torque
       tau_d = d*<b>der</b>(phi_rel);            // damper torque
       flange_b.tau = <b>if</b> tau_c + tau_d &le; 0 <b>then</b> 0 <b>else</b> tau_c + <b>min</b>( tau_c, tau_d );
    <b>end if</b>;
</pre>

<p>
Note, when sticking would occur (tau_c + tau_d &le; 0), then the contact torque
is explicitly set to zero. The \"min(tau_c, tau_d)\" part in the if-expression,
limits the damping torque when it is pushing. This means that at the start of
the contact (phi_rel - phi_rel0 = b/2), the damping torque is zero and is continuous.
The effect of both modifications is that the absolute value of the damping torque
is always limited by the absolute value of the spring torque: |tau_d| &le; |tau_c|.
</p>

<p>
In the next figure, a typical simulation with the ElastoBacklash model is shown
(<a href=\"modelica://Modelica.Mechanics.Rotational.Examples.Backlash\">Examples.Backlash</a>)
where the different effects are visualized:
</p>

<ol>
<li> Curve 1 (elastoBacklash1.tau) is the unmodified contact torque, i.e., the linear spring/damper
     characteristic. A pulling/sticking torque is present at the end of the contact.</li>
<li> Curve 2 (elastoBacklash2.tau) is the contact torque, where the torque is explicitly set to
     zero when pulling/sticking occurs. The contact torque is discontinuous at begin of
     contact.</li>
<li> Curve 3 (elastoBacklash3.tau) is the ElastoBacklash model of this library. No discontinuity and no
     pulling/sticking occurs.</li>
</ol>

<img src=\"modelica://Modelica/Resources/Images/Rotational/elastoBacklash1.png\">

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-80,32},{-58,32},{-48,0},{-34,61},{-20,0},{-8,60},{0,30},{20,30}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Rectangle(extent={{-60,-10},{-10,-50}},lineColor={0,0,0},pattern=LinePattern.Solid,lineThickness=0.25,fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{-60,-50},{0,-50}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{-60,-10},{0,-10}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{-10,-30},{20,-30}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{-80,-30},{-60,-30}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{-80,32},{-80,-30}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{20,30},{20,-30}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{-90,0},{-80,0}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{90,0},{80,0}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{20,0},{60,0},{60,-30}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Line(points={{40,-12},{40,-40},{80,-40},{80,0}},color={0,0,0},pattern=LinePattern.Solid,thickness=0.25,arrow={Arrow.None,Arrow.None}),Text(extent={{-150,-130},{150,-90}},lineColor={0,0,0},textString="b=%b"),Text(extent={{-150,100},{150,60}},lineColor={0,0,255},textString="%name"),Text(extent={{-152,-92},{148,-52}},lineColor={0,0,0},textString="c=%c"),Line(visible=useHeatPort,points={{-100,-100},{-100,-43},{-34,-43}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-80,32},{-58,32},{-48,0},{-34,60},{-20,0},{-8,60},{0,30},{20,30}},color={0,0,0},thickness=0.5),Line(points={{-68,32},{-68,97}},color={128,128,128}),Line(points={{80,0},{80,96}},color={128,128,128}),Line(points={{-68,92},{72,92}},color={128,128,128}),Polygon(points={{70,95},{80,92},{70,89},{70,95}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{-34,77},{40,90}},lineColor={128,128,128},textString="phi_rel"),Rectangle(extent={{-60,-20},{-10,-80}},lineColor={0,0,0},lineThickness=0.5,fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{-52,-80},{0,-80}},color={0,0,0},thickness=0.5),Line(points={{-52,-20},{0,-20}},color={0,0,0},thickness=0.5),Line(points={{-10,-50},{20,-50}},color={0,0,0},thickness=0.5),Line(points={{-80,-50},{-60,-50}},color={0,0,0},thickness=0.5),Line(points={{-80,32},{-80,-50}},color={0,0,0},thickness=0.5),Line(points={{20,30},{20,-50}},color={0,0,0},thickness=0.5),Line(points={{-96,0},{-80,0}},color={0,0,0}),Line(points={{96,0},{80,0}},color={0,0,0},thickness=0.5),Line(points={{20,0},{60,0},{60,-30}},color={0,0,0},thickness=0.5),Line(points={{40,-12},{40,-40},{80,-40},{80,0}},color={0,0,0},thickness=0.5),Line(points={{30,0},{30,64}},color={128,128,128}),Line(points={{30,60},{80,60}},color={128,128,128}),Polygon(points={{70,63},{80,60},{70,57},{70,63}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{39,60},{68,46}},lineColor={160,160,164},textString="b")}));
  end ElastoBacklash;

  model BearingFriction
   "Coulomb friction in bearings "

  // locally defined classes in BearingFriction
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of BearingFriction
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   parameter Real peak(final min=1)=1 "peak*tau_pos[1,2] = Maximum friction torque for w==0";
   constant Integer Unknown=3 "Value of mode is not known";
   constant Integer Stuck=0 "w_rel = 0 (forward sliding, locked or backward sliding)";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.AngularVelocity w_small=1.0e10 "Relative angular velocity near to zero if jumps due to a reinit(..) of the velocity can occur (set to low value only if such impulses can occur)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   constant Integer Free=2 "Element is not active";
   Integer mode(final min=Backward,final max=Unknown,start=Unknown,fixed=true);
   constant Integer Forward=1 "w_rel > 0 (forward sliding)";
   Boolean free "true, if frictional element is not active";
   Boolean startForward(start=false,fixed=true) "true, if w_rel=0 and start of forward sliding";
   parameter Real tau_pos[:,2]=[0, 1] "[w,tau] Positive sliding friction characteristic (w>=0)";
   Modelica.SIunits.AngularVelocity w_relfric "Relative angular velocity between frictional surfaces";
   constant Integer Backward=-1 "w_rel < 0 (backward sliding)";
   Modelica.SIunits.Torque tau0_max "Maximum friction torque for w=0 and locked";
   Modelica.SIunits.Angle phi "Angle between shaft flanges (flange_a, flange_b) and support";
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange_a.tau-flange_b.tau)) if useSupport;
   Modelica.SIunits.AngularAcceleration a "Absolute angular acceleration of flange_a and flange_b";
   Modelica.SIunits.AngularAcceleration a_relfric "Relative angular acceleration between frictional surfaces";
   Modelica.SIunits.Torque tau0 "Friction torque for w=0 and forward sliding";
   Modelica.SIunits.AngularVelocity w "Absolute angular velocity of flange_a and flange_b";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Real sa(final unit="1") "Path parameter of friction characteristic tau = f(a_relfric)";
   Modelica.SIunits.Torque tau "Friction torque";
   Boolean startBackward(start=false,fixed=true) "true, if w_rel=0 and start of backward sliding";
   Boolean locked(start=false) "true, if w_rel=0 and not sliding";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
   constant Modelica.SIunits.AngularAcceleration unitAngularAcceleration=1 annotation(HideResult=true);
   constant Modelica.SIunits.Torque unitTorque=1 annotation(HideResult=true);

  // algorithms and equations of BearingFriction
  equation
   tau0 = Modelica.Math.tempInterpol1(0,tau_pos,2);
   tau0_max = peak*tau0;
   free = false;
   phi = _famefault_flange_a.port_b.phi-phi_support;
   _famefault_flange_b.port_b.phi = _famefault_flange_a.port_b.phi;
   w = der(phi);
   a = der(w);
   w_relfric = w;
   a_relfric = a;
   _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau-tau = 0;
   tau = (if locked then sa*unitTorque else (if startForward then Modelica.Math.tempInterpol1(w,tau_pos,2) else (if startBackward then -Modelica.Math.tempInterpol1(-w,tau_pos,2) else (if pre(mode)==Forward then Modelica.Math.tempInterpol1(w,tau_pos,2) else -Modelica.Math.tempInterpol1(-w,tau_pos,2)))));
   lossPower = tau*w_relfric;
   if not useSupport then
    phi_support = 0;
   end if;
   startForward = (((pre(mode)==Stuck) and ((sa>(tau0_max/(unitTorque))) or (pre(startForward) and (sa>(tau0/(unitTorque)))))) or ((pre(mode)==Backward) and (w_relfric>w_small))) or (initial() and (w_relfric>0));
   startBackward = (((pre(mode)==Stuck) and ((sa<((-tau0_max)/(unitTorque))) or (pre(startBackward) and (sa<((-tau0)/(unitTorque)))))) or ((pre(mode)==Forward) and (w_relfric<-w_small))) or (initial() and (w_relfric<0));
   locked = not free and not (((pre(mode)==Forward) or startForward) or (pre(mode)==Backward)) or startBackward;
   a_relfric/(unitAngularAcceleration) = (if locked then 0 else (if free then sa else (if startForward then sa-tau0_max/(unitTorque) else (if startBackward then sa+tau0_max/(unitTorque) else (if pre(mode)==Forward then sa-tau0_max/(unitTorque) else sa+tau0_max/(unitTorque))))));
   mode = (if free then Free else (if (((pre(mode)==Forward) or (pre(mode)==Free)) or startForward) and (w_relfric>0) then Forward else (if (((pre(mode)==Backward) or (pre(mode)==Free)) or startBackward) and (w_relfric<0) then Backward else Stuck)));
   connect(heatPort,_famefault_heatPort.port_a);
   connect(support,_famefault_support.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
This element describes <b>Coulomb friction</b> in <b>bearings</b>,
i.e., a frictional torque acting between a flange and the housing.
The positive sliding friction torque \"tau\" has to be defined
by table \"tau_pos\" as function of the absolute angular velocity \"w\".
E.g.
<p>
<pre>
       w | tau
      ---+-----
       0 |   0
       1 |   2
       2 |   5
       3 |   8
</pre>
<p>
gives the following table:
</p>
<pre>
   tau_pos = [0, 0; 1, 2; 2, 5; 3, 8];
</pre>
<p>
Currently, only linear interpolation in the table is supported.
Outside of the table, extrapolation through the last
two table entries is used. It is assumed that the negative
sliding friction force has the same characteristic with negative
values. Friction is modelled in the following way:
</p>
<p>
When the absolute angular velocity \"w\" is not zero, the friction torque
is a function of w and of a constant normal force. This dependency
is defined via table tau_pos and can be determined by measurements,
e.g., by driving the gear with constant velocity and measuring the
needed motor torque (= friction torque).
</p>
<p>
When the absolute angular velocity becomes zero, the elements
connected by the friction element become stuck, i.e., the absolute
angle remains constant. In this phase the friction torque is
calculated from a torque balance due to the requirement, that
the absolute acceleration shall be zero.  The elements begin
to slide when the friction torque exceeds a threshold value,
called the maximum static friction torque, computed via:
</p>
<pre>
   maximum_static_friction = <b>peak</b> * sliding_friction(w=0)  (<b>peak</b> >= 1)
</pre>
<p>
This procedure is implemented in a \"clean\" way by state events and
leads to continuous/discrete systems of equations if friction elements
are dynamically coupled which have to be solved by appropriate
numerical methods. The method is described in:
</p>
<dl>
<dt>Otter M., Elmqvist H., and Mattsson S.E. (1999):
<dd><b>Hybrid Modeling in Modelica based on the Synchronous
    Data Flow Principle</b>. CACSD'99, Aug. 22.-26, Hawaii.
</dl>
<p>
More precise friction models take into account the elasticity of the
material when the two elements are \"stuck\", as well as other effects,
like hysteresis. This has the advantage that the friction element can
be completely described by a differential equation without events. The
drawback is that the system becomes stiff (about 10-20 times slower
simulation) and that more material constants have to be supplied which
requires more sophisticated identification. For more details, see the
following references, especially (Armstrong and Canudas de Witt 1996):
</p>
<dl>
<dt>Armstrong B. (1991):
<dd><b>Control of Machines with Friction</b>. Kluwer Academic
    Press, Boston MA.<br><br>
<dt>Armstrong B., and Canudas de Wit C. (1996):
<dd><b>Friction Modeling and Compensation.</b>
    The Control Handbook, edited by W.S.Levine, CRC Press,
    pp. 1369-1382.<br><br>
<dt>Canudas de Wit C., Olsson H., Astroem K.J., and Lischinsky P. (1995):
<dd><b>A new model for control of systems with friction.</b>
    IEEE Transactions on Automatic Control, Vol. 40, No. 3, pp. 419-425.<br><br>
</dl>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-60,-10},{60,-60}},lineColor={0,0,0}),Rectangle(extent={{-60,-10},{60,-25}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-60,-45},{60,-61}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-50,-18},{50,-50}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{60,-60},{60,-70},{75,-70},{75,-80},{-75,-80},{-75,-70},{-60,-70},{-60,-60},{60,-60}},lineColor={0,0,0},fillColor={160,160,164},fillPattern=FillPattern.Solid),Line(points={{-75,-10},{-75,-70}},color={0,0,0}),Line(points={{75,-10},{75,-70}},color={0,0,0}),Rectangle(extent={{-60,60},{60,10}},lineColor={0,0,0}),Rectangle(extent={{-60,60},{60,45}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-60,25},{60,10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-50,51},{50,19}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-75,70},{-75,10}},color={0,0,0}),Polygon(points={{60,60},{60,70},{75,70},{75,80},{-75,80},{-75,70},{-60,70},{-60,60},{60,60}},lineColor={0,0,0},fillColor={160,160,164},fillPattern=FillPattern.Solid),Line(points={{75,70},{75,10}},color={0,0,0}),Text(extent={{-150,130},{150,90}},textString="%name",lineColor={0,0,255}),Line(points={{0,-80},{0,-100}},color={0,0,0},smooth=Smooth.None),Line(visible=useHeatPort,points={{-100,-100},{-100,-35},{2,-35}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end BearingFriction;

  model Brake
   "Brake based on Coulomb friction "

  // locally defined classes in Brake
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;

   model _famefaults_mue_pos
    extends FAME.Parametric.BaseParametricFault(amount=0.0);

   // locally defined classes in _famefaults_mue_pos

    type Modes = enumeration(Nominal, Slip);

   // components of _famefaults_mue_pos
    parameter Modes mode=Modes.Nominal;

   // algorithms and equations of _famefaults_mue_pos
   equation
    if mode==Modes.Slip then
     y = u*{{1,0},{0,1-amount}};
    else
     y = u;
    end if;
   end _famefaults_mue_pos;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Brake
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   parameter Real peak(final min=1)=1 "peak*mue_pos[1,2] = maximum value of mue for w_rel==0";
   constant Integer Unknown=3 "Value of mode is not known";
   constant Integer Stuck=0 "w_rel = 0 (forward sliding, locked or backward sliding)";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.AngularVelocity w_small=1.0e10 "Relative angular velocity near to zero if jumps due to a reinit(..) of the velocity can occur (set to low value only if such impulses can occur)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   constant Integer Free=2 "Element is not active";
   Integer mode(final min=Backward,final max=Unknown,start=Unknown,fixed=true);
   constant Integer Forward=1 "w_rel > 0 (forward sliding)";
   Modelica.Blocks.Interfaces.RealInput f_normalized "Normalized force signal 0..1 (normal force = fn_max*f_normalized; brake is active if > 0)" annotation(Placement(transformation(origin={0,110},extent={{20,-20},{-20,20}},rotation=90)));
   Boolean free "true, if frictional element is not active";
   Boolean startForward(start=false,fixed=true) "true, if w_rel=0 and start of forward sliding";
   Modelica.SIunits.AngularVelocity w_relfric "Relative angular velocity between frictional surfaces";
   constant Integer Backward=-1 "w_rel < 0 (backward sliding)";
   Modelica.SIunits.Torque tau0_max "Maximum friction torque for w=0 and locked";
   Modelica.SIunits.Force fn "Normal force (=fn_max*f_normalized)";
   Modelica.SIunits.Angle phi "Angle between shaft flanges (flange_a, flange_b) and support";
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange_a.tau-flange_b.tau)) if useSupport;
   Modelica.SIunits.AngularAcceleration a "Absolute angular acceleration of flange_a and flange_b";
   Modelica.SIunits.AngularAcceleration a_relfric "Relative angular acceleration between frictional surfaces";
   Modelica.SIunits.Torque tau0 "Friction torque for w=0 and forward sliding";
   parameter Real cgeo(final min=0)=1 "Geometry constant containing friction distribution assumption";
   Modelica.SIunits.AngularVelocity w "Absolute angular velocity of flange_a and flange_b";
   Real mue0 "Friction coefficient for w=0 and forward sliding";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   parameter Modelica.SIunits.Force fn_max(final min=0,start=1) "Maximum normal force";
   parameter Real mue_pos[:,2]=[0, 0.5] "[w,mue] positive sliding friction coefficient (w_rel>=0)";
   _famefaults_mue_pos _famefault_mue_pos(u=mue_pos,redeclare type ParamType = Real[size(mue_pos,1),2]);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Real sa(final unit="1") "Path parameter of friction characteristic tau = f(a_relfric)";
   Modelica.SIunits.Torque tau "Brake friction torqu";
   Boolean startBackward(start=false,fixed=true) "true, if w_rel=0 and start of backward sliding";
   Boolean locked(start=false) "true, if w_rel=0 and not sliding";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
   constant Modelica.SIunits.AngularAcceleration unitAngularAcceleration=1 annotation(HideResult=true);
   constant Modelica.SIunits.Torque unitTorque=1 annotation(HideResult=true);

  // algorithms and equations of Brake
  equation
   mue0 = Modelica.Math.tempInterpol1(0,_famefault_mue_pos.y,2);
   phi = _famefault_flange_a.port_b.phi-phi_support;
   _famefault_flange_b.port_b.phi = _famefault_flange_a.port_b.phi;
   w = der(phi);
   a = der(w);
   w_relfric = w;
   a_relfric = a;
   _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau-tau = 0;
   fn = fn_max*f_normalized;
   tau0 = mue0*cgeo*fn;
   tau0_max = peak*tau0;
   free = fn<=0;
   tau = (if locked then sa*unitTorque else (if free then 0 else cgeo*fn*(if startForward then Modelica.Math.tempInterpol1(w,_famefault_mue_pos.y,2) else (if startBackward then -Modelica.Math.tempInterpol1(-w,_famefault_mue_pos.y,2) else (if pre(mode)==Forward then Modelica.Math.tempInterpol1(w,_famefault_mue_pos.y,2) else -Modelica.Math.tempInterpol1(-w,_famefault_mue_pos.y,2))))));
   lossPower = tau*w_relfric;
   if not useSupport then
    phi_support = 0;
   end if;
   startForward = (((pre(mode)==Stuck) and ((sa>(tau0_max/(unitTorque))) or (pre(startForward) and (sa>(tau0/(unitTorque)))))) or ((pre(mode)==Backward) and (w_relfric>w_small))) or (initial() and (w_relfric>0));
   startBackward = (((pre(mode)==Stuck) and ((sa<((-tau0_max)/(unitTorque))) or (pre(startBackward) and (sa<((-tau0)/(unitTorque)))))) or ((pre(mode)==Forward) and (w_relfric<-w_small))) or (initial() and (w_relfric<0));
   locked = not free and not (((pre(mode)==Forward) or startForward) or (pre(mode)==Backward)) or startBackward;
   a_relfric/(unitAngularAcceleration) = (if locked then 0 else (if free then sa else (if startForward then sa-tau0_max/(unitTorque) else (if startBackward then sa+tau0_max/(unitTorque) else (if pre(mode)==Forward then sa-tau0_max/(unitTorque) else sa+tau0_max/(unitTorque))))));
   mode = (if free then Free else (if (((pre(mode)==Forward) or (pre(mode)==Free)) or startForward) and (w_relfric>0) then Forward else (if (((pre(mode)==Backward) or (pre(mode)==Free)) or startBackward) and (w_relfric<0) then Backward else Stuck)));
   connect(heatPort,_famefault_heatPort.port_a);
   connect(support,_famefault_support.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Polygon(points={{-37,-55},{-37,-90},{37,-90},{37,-55},{33,-55},{33,-86},{-33,-86},{-33,-55},{-37,-55}},lineColor={192,192,192},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,10},{-20,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-20,60},{20,-60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{20,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Polygon(points={{40,-40},{70,-30},{70,-50},{40,-40}},lineColor={0,0,127},fillColor={0,0,127},fillPattern=FillPattern.Solid),Rectangle(extent={{30,-25},{40,-55}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Polygon(points={{-40,-40},{-70,-30},{-70,-50},{-40,-40}},lineColor={0,0,127},fillColor={0,0,127},fillPattern=FillPattern.Solid),Rectangle(extent={{-40,-25},{-30,-55}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{0,90},{80,70},{80,-40},{70,-40}},color={0,0,127}),Line(points={{0,90},{-80,70},{-80,-40},{-70,-40}},color={0,0,127}),Text(extent={{-150,-180},{150,-140}},textString="%name",lineColor={0,0,255}),Line(visible=useHeatPort,points={{-100,-98},{-100,-70},{0,-70},{0,-40}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Documentation(info="<html>
<p>
This component models a <b>brake</b>, i.e., a component where a frictional
torque is acting between the housing and a flange and a controlled normal
force presses the flange to the housing in order to increase friction.
The normal force fn has to be provided as input signal f_normalized in a normalized form
(0 &le; f_normalized &le; 1),
fn = fn_max*f_normalized, where fn_max has to be provided as parameter.
Friction in the brake is modelled in the following way:
</p>
<p>
When the absolute angular velocity \"w\" is not zero, the friction torque
is a function of the velocity dependent friction coefficient  mue(w) , of
the normal force \"fn\", and of a geometry constant \"cgeo\" which takes into
account the geometry of the device and the assumptions on the friction
distributions:
</p>
<pre>
        frictional_torque = <b>cgeo</b> * <b>mue</b>(w) * <b>fn</b>
</pre>
<p>
   Typical values of coefficients of friction:
</p>
<pre>
      dry operation   :  <b>mue</b> = 0.2 .. 0.4
      operating in oil:  <b>mue</b> = 0.05 .. 0.1
</pre>
<p>
   When plates are pressed together, where  <b>ri</b>  is the inner radius,
   <b>ro</b> is the outer radius and <b>N</b> is the number of friction interfaces,
   the geometry constant is calculated in the following way under the
   assumption of a uniform rate of wear at the interfaces:
</p>
<pre>
         <b>cgeo</b> = <b>N</b>*(<b>r0</b> + <b>ri</b>)/2
</pre>
<p>
    The positive part of the friction characteristic <b>mue</b>(w),
    w >= 0, is defined via table mue_pos (first column = w,
    second column = mue). Currently, only linear interpolation in
    the table is supported.
</p>
<p>
   When the absolute angular velocity becomes zero, the elements
   connected by the friction element become stuck, i.e., the absolute
   angle remains constant. In this phase the friction torque is
   calculated from a torque balance due to the requirement, that
   the absolute acceleration shall be zero.  The elements begin
   to slide when the friction torque exceeds a threshold value,
   called the  maximum static friction torque, computed via:
</p>
<pre>
       frictional_torque = <b>peak</b> * <b>cgeo</b> * <b>mue</b>(w=0) * <b>fn</b>   (<b>peak</b> >= 1)
</pre>
<p>
This procedure is implemented in a \"clean\" way by state events and
leads to continuous/discrete systems of equations if friction elements
are dynamically coupled. The method is described in:
</p>
<dl>
<dt>Otter M., Elmqvist H., and Mattsson S.E. (1999):
<dd><b>Hybrid Modeling in Modelica based on the Synchronous
    Data Flow Principle</b>. CACSD'99, Aug. 22.-26, Hawaii.
</dl>
<p>
More precise friction models take into account the elasticity of the
material when the two elements are \"stuck\", as well as other effects,
like hysteresis. This has the advantage that the friction element can
be completely described by a differential equation without events. The
drawback is that the system becomes stiff (about 10-20 times slower
simulation) and that more material constants have to be supplied which
requires more sophisticated identification. For more details, see the
following references, especially (Armstrong and Canudas de Witt 1996):
</p>
<dl>
<dt>Armstrong B. (1991):
<dd><b>Control of Machines with Friction</b>. Kluwer Academic
    Press, Boston MA.<br><br>
<dt>Armstrong B., and Canudas de Wit C. (1996):
<dd><b>Friction Modeling and Compensation.</b>
    The Control Handbook, edited by W.S.Levine, CRC Press,
    pp. 1369-1382.<br><br>
<dt>Canudas de Wit C., Olsson H., Astroem K.J., and Lischinsky P. (1995):
<dd><b>A new model for control of systems with friction.</b>
    IEEE Transactions on Automatic Control, Vol. 40, No. 3, pp. 419-425.<br><br>
</dl>

</HTML>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end Brake;

  model Clutch
   "Clutch based on Coulomb friction"

  // locally defined classes in Clutch
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;

   model _famefaults_mue_pos
    extends FAME.Parametric.BaseParametricFault(amount=0.0);

   // locally defined classes in _famefaults_mue_pos

    type Modes = enumeration(Nominal, Slip);

   // components of _famefaults_mue_pos
    parameter Modes mode=Modes.Nominal;

   // algorithms and equations of _famefaults_mue_pos
   equation
    if mode==Modes.Slip then
     y = u*{{1,0},{0,1-amount}};
    else
     y = u;
    end if;
   end _famefaults_mue_pos;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Clutch
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   parameter Real peak(final min=1)=1 "peak*mue_pos[1,2] = maximum value of mue for w_rel==0";
   constant Integer Unknown=3 "Value of mode is not known";
   constant Integer Stuck=0 "w_rel = 0 (forward sliding, locked or backward sliding)";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.AngularVelocity w_small=1.0e10 "Relative angular velocity near to zero if jumps due to a reinit(..) of the velocity can occur (set to low value only if such impulses can occur)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration (= der(w_rel))";
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   constant Integer Free=2 "Element is not active";
   Integer mode(final min=Backward,final max=Unknown,start=Unknown,fixed=true);
   constant Integer Forward=1 "w_rel > 0 (forward sliding)";
   Modelica.Blocks.Interfaces.RealInput f_normalized "Normalized force signal 0..1 (normal force = fn_max*f_normalized; clutch is engaged if > 0)" annotation(Placement(transformation(origin={0,110},extent={{20,-20},{-20,20}},rotation=90)));
   Boolean free "true, if frictional element is not active";
   Boolean startForward(start=false,fixed=true) "true, if w_rel=0 and start of forward sliding";
   Modelica.SIunits.AngularVelocity w_relfric "Relative angular velocity between frictional surfaces";
   constant Integer Backward=-1 "w_rel < 0 (backward sliding)";
   Modelica.SIunits.Torque tau0_max "Maximum friction torque for w=0 and locked";
   Modelica.SIunits.Force fn "Normal force (fn=fn_max*f_normalized)";
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   parameter Modelica.SIunits.Angle phi_nominal(displayUnit="rad")=1e-4 "Nominal value of phi_rel (used for scaling)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity (= der(phi_rel))";
   Modelica.SIunits.AngularAcceleration a_relfric "Relative angular acceleration between frictional surfaces";
   Modelica.SIunits.Torque tau0 "Friction torque for w=0 and forward sliding";
   parameter Real cgeo(final min=0)=1 "Geometry constant containing friction distribution assumption";
   Real mue0 "Friction coefficient for w=0 and forward sliding";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   parameter Modelica.SIunits.Force fn_max(final min=0,start=1) "Maximum normal force";
   parameter Real mue_pos[:,2]=[0, 0.5] "[w,mue] positive sliding friction coefficient (w_rel>=0)";
   _famefaults_mue_pos _famefault_mue_pos(u=mue_pos,redeclare type ParamType = Real[size(mue_pos,1),2]);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=phi_nominal) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Real sa(final unit="1") "Path parameter of friction characteristic tau = f(a_relfric)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
   Boolean startBackward(start=false,fixed=true) "true, if w_rel=0 and start of backward sliding";
   Boolean locked(start=false) "true, if w_rel=0 and not sliding";
  protected
   constant Modelica.SIunits.AngularAcceleration unitAngularAcceleration=1 annotation(HideResult=true);
   constant Modelica.SIunits.Torque unitTorque=1 annotation(HideResult=true);

  // algorithms and equations of Clutch
  equation
   mue0 = Modelica.Math.tempInterpol1(0,_famefault_mue_pos.y,2);
   w_relfric = w_rel;
   a_relfric = a_rel;
   fn = fn_max*f_normalized;
   free = fn<=0;
   tau0 = mue0*cgeo*fn;
   tau0_max = peak*tau0;
   tau = (if locked then sa*unitTorque else (if free then 0 else cgeo*fn*(if startForward then Modelica.Math.tempInterpol1(w_rel,_famefault_mue_pos.y,2) else (if startBackward then -Modelica.Math.tempInterpol1(-w_rel,_famefault_mue_pos.y,2) else (if pre(mode)==Forward then Modelica.Math.tempInterpol1(w_rel,_famefault_mue_pos.y,2) else -Modelica.Math.tempInterpol1(-w_rel,_famefault_mue_pos.y,2))))));
   lossPower = tau*w_relfric;
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   _famefault_flange_b.port_b.tau = tau;
   _famefault_flange_a.port_b.tau = -tau;
   startForward = (((pre(mode)==Stuck) and ((sa>(tau0_max/(unitTorque))) or (pre(startForward) and (sa>(tau0/(unitTorque)))))) or ((pre(mode)==Backward) and (w_relfric>w_small))) or (initial() and (w_relfric>0));
   startBackward = (((pre(mode)==Stuck) and ((sa<((-tau0_max)/(unitTorque))) or (pre(startBackward) and (sa<((-tau0)/(unitTorque)))))) or ((pre(mode)==Forward) and (w_relfric<-w_small))) or (initial() and (w_relfric<0));
   locked = not free and not (((pre(mode)==Forward) or startForward) or (pre(mode)==Backward)) or startBackward;
   a_relfric/(unitAngularAcceleration) = (if locked then 0 else (if free then sa else (if startForward then sa-tau0_max/(unitTorque) else (if startBackward then sa+tau0_max/(unitTorque) else (if pre(mode)==Forward then sa-tau0_max/(unitTorque) else sa+tau0_max/(unitTorque))))));
   mode = (if free then Free else (if (((pre(mode)==Forward) or (pre(mode)==Free)) or startForward) and (w_relfric>0) then Forward else (if (((pre(mode)==Backward) or (pre(mode)==Free)) or startBackward) and (w_relfric<0) then Backward else Stuck)));
   connect(heatPort,_famefault_heatPort.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,-110},{150,-70}},textString="%name",lineColor={0,0,255}),Line(visible=useHeatPort,points={{-100,-100},{-100,-40},{0,-40}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Documentation(info="<html>
<p>
This component models a <b>clutch</b>, i.e., a component with
two flanges where friction is present between the two flanges
and these flanges are pressed together via a normal force.
The normal force fn has to be provided as input signal f_normalized in a normalized form
(0 &le; f_normalized &le; 1),
fn = fn_max*f_normalized, where fn_max has to be provided as parameter. Friction in the
clutch is modelled in the following way:
</p>
<p>
When the relative angular velocity is not zero, the friction torque is a
function of the velocity dependent friction coefficient  mue(w_rel) , of
the normal force \"fn\", and of a geometry constant \"cgeo\" which takes into
account the geometry of the device and the assumptions on the friction
distributions:
</p>
<pre>
        frictional_torque = <b>cgeo</b> * <b>mue</b>(w_rel) * <b>fn</b>
</pre>
<p>
   Typical values of coefficients of friction:
</p>
<pre>
      dry operation   :  <b>mue</b> = 0.2 .. 0.4
      operating in oil:  <b>mue</b> = 0.05 .. 0.1
</pre>
<p>
   When plates are pressed together, where  <b>ri</b>  is the inner radius,
   <b>ro</b> is the outer radius and <b>N</b> is the number of friction interfaces,
   the geometry constant is calculated in the following way under the
   assumption of a uniform rate of wear at the interfaces:
</p>
<pre>
         <b>cgeo</b> = <b>N</b>*(<b>r0</b> + <b>ri</b>)/2
</pre>
<p>
    The positive part of the friction characteristic <b>mue</b>(w_rel),
    w_rel >= 0, is defined via table mue_pos (first column = w_rel,
    second column = mue). Currently, only linear interpolation in
    the table is supported.
</p>
<p>
   When the relative angular velocity becomes zero, the elements
   connected by the friction element become stuck, i.e., the relative
   angle remains constant. In this phase the friction torque is
   calculated from a torque balance due to the requirement, that
   the relative acceleration shall be zero.  The elements begin
   to slide when the friction torque exceeds a threshold value,
   called the  maximum static friction torque, computed via:
</p>
<pre>
       frictional_torque = <b>peak</b> * <b>cgeo</b> * <b>mue</b>(w_rel=0) * <b>fn</b>   (<b>peak</b> >= 1)
</pre>
<p>
This procedure is implemented in a \"clean\" way by state events and
leads to continuous/discrete systems of equations if friction elements
are dynamically coupled. The method is described in:
</p>
<dl>
<dt>Otter M., Elmqvist H., and Mattsson S.E. (1999):
<dd><b>Hybrid Modeling in Modelica based on the Synchronous
    Data Flow Principle</b>. CACSD'99, Aug. 22.-26, Hawaii.
</dl>
<p>
More precise friction models take into account the elasticity of the
material when the two elements are \"stuck\", as well as other effects,
like hysteresis. This has the advantage that the friction element can
be completely described by a differential equation without events. The
drawback is that the system becomes stiff (about 10-20 times slower
simulation) and that more material constants have to be supplied which
requires more sophisticated identification. For more details, see the
following references, especially (Armstrong and Canudas de Witt 1996):
</p>
<dl>
<dt>Armstrong B. (1991):
<dd><b>Control of Machines with Friction</b>. Kluwer Academic
    Press, Boston MA.<br><br>
<dt>Armstrong B., and Canudas de Wit C. (1996):
<dd><b>Friction Modeling and Compensation.</b>
    The Control Handbook, edited by W.S.Levine, CRC Press,
    pp. 1369-1382.<br><br>
<dt>Canudas de Wit C., Olsson H., Astroem K.J., and Lischinsky P. (1995):
<dd><b>A new model for control of systems with friction.</b>
    IEEE Transactions on Automatic Control, Vol. 40, No. 3, pp. 419-425.<br><br>
</dl>
<br>

</HTML>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end Clutch;

  model OneWayClutch
   "Series connection of freewheel and clutch"

  // locally defined classes in OneWayClutch
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of OneWayClutch
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   parameter Real peak(final min=1)=1 "peak*mue_pos[1,2] = maximum value of mue for w_rel==0";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.AngularVelocity w_small=1e10 "Relative angular velocity near to zero if jumps due to a reinit(..) of the velocity can occur (set to low value only if such impulses can occur)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration (= der(w_rel))";
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   Modelica.Blocks.Interfaces.RealInput f_normalized "Normalized force signal 0..1 (normal force = fn_max*f_normalized; clutch is engaged if > 0)" annotation(Placement(transformation(origin={0,110},extent={{20,-20},{-20,20}},rotation=90)));
   Boolean startForward(start=false) "true, if w_rel=0 and start of forward sliding or w_rel > w_small";
   Boolean stuck(start=false) "w_rel=0 (locked or start forward sliding)";
   Modelica.SIunits.Force fn "Normal force (fn=fn_max*inPort.signal)";
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   parameter Modelica.SIunits.Angle phi_nominal(displayUnit="rad")=1e-4 "Nominal value of phi_rel (used for scaling)" annotation(Dialog(tab="Advanced"));
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity (= der(phi_rel))";
   parameter Real cgeo(final min=0)=1 "Geometry constant containing friction distribution assumption";
   Real u "Normalized force input signal (0..1)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   parameter Real mue_pos[:,2]=[0, 0.5] "[w,mue] positive sliding friction coefficient (w_rel>=0)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter Modelica.SIunits.Force fn_max(final min=0,start=1) "Maximum normal force";
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=phi_nominal) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
   Boolean locked(start=false) "true, if w_rel=0 and not sliding";
  protected
   Boolean free "true, if frictional element is not active";
   Modelica.SIunits.Torque tau0_max "Maximum friction torque for w=0 and locked";
   constant Real eps0=1.0e-4 "Relative hysteresis epsilon";
   constant Modelica.SIunits.AngularAcceleration unitAngularAcceleration=1;
   Modelica.SIunits.Torque tau0 "Friction torque for w=0 and sliding";
   constant Modelica.SIunits.Torque unitTorque=1;
   Real mue0 "Friction coefficient for w=0 and sliding";
   Real sa(final unit="1") "Path parameter of tau = f(a_rel) Friction characteristic";
   parameter Real peak2=max([peak, 1+eps0]);
   Modelica.SIunits.Torque tau0_max_low "Lowest value for tau0_max";

  // algorithms and equations of OneWayClutch
  equation
   mue0 = Modelica.Math.tempInterpol1(0,mue_pos,2);
   tau0_max_low = eps0*mue0*cgeo*fn_max;
   u = f_normalized;
   free = u<=0;
   fn = (if free then 0 else fn_max*u);
   tau0 = mue0*cgeo*fn;
   tau0_max = (if free then tau0_max_low else peak2*tau0);
   startForward = (pre(stuck) and (((sa>(tau0_max/(unitTorque))) or (pre(startForward) and (sa>(tau0/(unitTorque))))) or (w_rel>w_small))) or (initial() and (w_rel>0));
   locked = pre(stuck) and not startForward;
   a_rel = unitAngularAcceleration*(if locked then 0 else sa-tau0/(unitTorque));
   tau = (if locked then sa*unitTorque else (if free then 0 else cgeo*fn*Modelica.Math.tempInterpol1(w_rel,mue_pos,2)));
   stuck = locked or (w_rel<=0);
   lossPower = (if stuck then 0 else tau*w_rel);
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   _famefault_flange_b.port_b.tau = tau;
   _famefault_flange_a.port_b.tau = -tau;
   connect(heatPort,_famefault_heatPort.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,-110},{150,-70}},textString="%name",lineColor={0,0,255}),Polygon(points={{-10,30},{50,0},{-10,-30},{-10,30}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(visible=useHeatPort,points={{-100,-99},{-100,-40},{0,-40}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Documentation(info="<html>
<p>
This component models a <b>one-way clutch</b>, i.e., a component with
two flanges where friction is present between the two flanges
and these flanges are pressed together via a normal force. These
flanges maybe sliding with respect to each other
Parallel connection of ClutchCombi and of FreeWheel.
                     The element is introduced to resolve the ambiguity
                     of the constraint torques of the elements.
<p>
A one-way-clutch is an element where a clutch is connected in parallel
to a free wheel. This special element is provided, because such
a parallel connection introduces an ambiguity into the model
(the constraint torques are not uniquely defined when both
elements are stuck) and this element resolves it by introducing
<b>one</b> constraint torque and not two.
</p>
<p>
Note, initial values have to be chosen for the model, such that the
relative speed of the one-way-clutch >= 0. Otherwise, the configuration
is physically not possible and an error occurs.
</p>
<p>
The normal force fn has to be provided as input signal f_normalized in a normalized form
(0 &le; f_normalized &le; 1),
fn = fn_max*f_normalized, where fn_max has to be provided as parameter. Friction in the
clutch is modelled in the following way:
</p>
<p>
When the relative angular velocity is positive, the friction torque is a
function of the velocity dependent friction coefficient  mue(w_rel) , of
the normal force \"fn\", and of a geometry constant \"cgeo\" which takes into
account the geometry of the device and the assumptions on the friction
distributions:
</p>
<pre>
        frictional_torque = <b>cgeo</b> * <b>mue</b>(w_rel) * <b>fn</b>
</pre>
<p>
   Typical values of coefficients of friction:
</p>
<pre>
      dry operation   :  <b>mue</b> = 0.2 .. 0.4
      operating in oil:  <b>mue</b> = 0.05 .. 0.1
</pre>
<p>
   When plates are pressed together, where  <b>ri</b>  is the inner radius,
   <b>ro</b> is the outer radius and <b>N</b> is the number of friction interfaces,
   the geometry constant is calculated in the following way under the
   assumption of a uniform rate of wear at the interfaces:
</p>
<pre>
         <b>cgeo</b> = <b>N</b>*(<b>r0</b> + <b>ri</b>)/2
</pre>
<p>
    The positive part of the friction characteristic <b>mue</b>(w_rel),
    w_rel >= 0, is defined via table mue_pos (first column = w_rel,
    second column = mue). Currently, only linear interpolation in
    the table is supported.
</p>
<p>
   When the relative angular velocity becomes zero, the elements
   connected by the friction element become stuck, i.e., the relative
   angle remains constant. In this phase the friction torque is
   calculated from a torque balance due to the requirement, that
   the relative acceleration shall be zero.  The elements begin
   to slide when the friction torque exceeds a threshold value,
   called the  maximum static friction torque, computed via:
</p>
<pre>
       frictional_torque = <b>peak</b> * <b>cgeo</b> * <b>mue</b>(w_rel=0) * <b>fn</b>   (<b>peak</b> >= 1)
</pre>
<p>
This procedure is implemented in a \"clean\" way by state events and
leads to continuous/discrete systems of equations if friction elements
are dynamically coupled. The method is described in:
</p>
<dl>
<dt>Otter M., Elmqvist H., and Mattsson S.E. (1999):
<dd><b>Hybrid Modeling in Modelica based on the Synchronous
    Data Flow Principle</b>. CACSD'99, Aug. 22.-26, Hawaii.
</dl>

</HTML>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end OneWayClutch;

  model IdealGear
   "Ideal gear without inertia"

  // locally defined classes in IdealGear
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of IdealGear
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange_a.tau-flange_b.tau)) if useSupport;
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter Real ratio(start=1) "Transmission ratio (flange_a.phi/flange_b.phi)";
   Modelica.SIunits.Angle phi_a "Angle between left shaft flange and support";
   Modelica.SIunits.Angle phi_b "Angle between right shaft flange and support";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of IdealGear
  equation
   phi_a = _famefault_flange_a.port_b.phi-phi_support;
   phi_b = _famefault_flange_b.port_b.phi-phi_support;
   phi_a = ratio*phi_b;
   0 = ratio*_famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   if not useSupport then
    phi_support = 0;
   end if;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(support,_famefault_support.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
This element characterices any type of gear box which is fixed in the
ground and which has one driving shaft and one driven shaft.
The gear is <b>ideal</b>, i.e., it does not have inertia, elasticity, damping
or backlash. If these effects have to be considered, the gear has to be
connected to other elements in an appropriate way.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-153,145},{147,105}},lineColor={0,0,255},textString="%name"),Text(extent={{-146,-49},{154,-79}},lineColor={0,0,0},textString="ratio=%ratio")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end IdealGear;

  model LossyGear
   "Gear with mesh efficiency and bearing friction (stuck/rolling possible)"

  // locally defined classes in LossyGear
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_heatPort = FAME.Dampers.ThermalWithoutConnectEquations;

  // components of LossyGear
   Modelica.SIunits.Torque tauLoss "Torque loss due to friction in the gear teeth and in the bearings";
   Real quadrant2_p;
   Real quadrant4;
   constant Integer Unknown=3 "Value of mode is not known";
   Modelica.SIunits.Torque tauLossMin_m "Torque loss for negative speed";
   constant Integer Stuck=0 "w_a = 0 (forward rolling, locked or backward rolling)";
   Real quadrant3;
   Real quadrant2;
   Real quadrant1;
   Modelica.SIunits.Power lossPower "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
   constant Integer Free=2 "Element is not active";
   Real quadrant1_p;
   constant Integer Forward=1 "w_a > 0 (forward rolling)";
   Boolean startForward(start=false) "true, if starting to roll forward";
   constant Integer Backward=-1 "w_a < 0 (backward rolling)";
   Real tau_eta "Torque that determines the driving side (= if forwardSliding then flange_a.tau-tau_bf_a else if backwardSliding then flange_a.tau+tau_bf_a else flange_a.tau)";
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange_a.tau-flange_b.tau)) if useSupport;
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.SIunits.Torque tauLossMax "Torque loss for positive speed";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter Real ratio(start=1) "Transmission ratio (flange_a.phi/flange_b.phi)";
   Real sa(final unit="1") "Path parameter for acceleration and torque loss";
   Modelica.SIunits.AngularVelocity w_a "Angular velocity of flange_a with respect to support";
   Boolean locked(start=false) "true, if gear is locked";
   Modelica.SIunits.Torque tauLossMin "Torque loss for negative speed";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort() if useHeatPort "Optional port to which dissipated losses are transported in form of heat" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.ThermalWithoutConnectEquations _famefault_heatPort(amount=0.0,port_b(final Q_flow=-lossPower)) if useHeatPort;
   Modelica.SIunits.Angle phi_a "Angle between left shaft flange and support";
   parameter Boolean useHeatPort=false "=true, if heatPort is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.SIunits.Angle phi_b "Angle between right shaft flange and support";
   Integer mode(final min=Backward,final max=Unknown,start=Free,fixed=true);
   Modelica.SIunits.Torque tauLossMax_p "Torque loss for positive speed";
   Real interpolation_result[1,size(lossTable,2)-1];
   parameter Real lossTable[:,5]=[0, 1, 1, 0, 0] "Array for mesh efficiencies and bearing friction depending on speed";
   Boolean tau_etaPos(start=true) "true, if torque tau_eta is not negative";
   Real quadrant4_m;
   Modelica.SIunits.AngularAcceleration a_a "Angular acceleration of flange_a with respect to support";
   Real tau_bf2;
   Real tau_bf1;
   Boolean ideal "true, if losses are neglected";
   Real eta_mf2;
   Boolean tau_aPos(start=true) "Only for backwards compatibility (was previously: true, if torque of flange_a is not negative)";
   Modelica.SIunits.Torque tau_eta_m "tau_eta assuming negative omega";
   Real eta_mf1;
   Modelica.SIunits.Torque tau_eta_p "tau_eta assuming positive omega";
   Boolean startBackward(start=false) "true, if starting to roll backward";
   Real quadrant3_m;
   Real tau_bf_a "Bearing friction torque on flange_a side";
  protected
   parameter Real tau_bf2_0=abs(interpolation_result_0[1,4]);
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
   parameter Real tau_bf1_0=abs(interpolation_result_0[1,3]);
   parameter Real tau_bf_a_0=(if Modelica.Math.isEqual(eta_mf1_0,1.0,Modelica.Constants.eps) and Modelica.Math.isEqual(eta_mf2_0,1.0,Modelica.Constants.eps) then tau_bf1_0/(2) else (tau_bf1_0-tau_bf2_0)/(eta_mf1_0-1.0/(eta_mf2_0)));
   parameter Real eta_mf2_0=interpolation_result_0[1,2];
   parameter Real eta_mf1_0=interpolation_result_0[1,1];
   constant Modelica.SIunits.AngularAcceleration unitAngularAcceleration=1;
   constant Modelica.SIunits.Torque unitTorque=1;
   parameter Real interpolation_result_0[1,size(lossTable,2)-1]=Modelica.Math.tempInterpol2(0,lossTable,{2,3,4,5});

  // algorithms and equations of LossyGear
  equation
   assert(abs(ratio)>0,"Error in initialization of LossyGear: ratio may not be zero");
   ideal = Modelica.Math.Matrices.isEqual(lossTable,[0, 1, 1, 0, 0],Modelica.Constants.eps);
   interpolation_result = (if ideal then [1, 1, 0, 0] else Modelica.Math.tempInterpol2(noEvent(abs(w_a)),lossTable,{2,3,4,5}));
   eta_mf1 = interpolation_result[1,1];
   eta_mf2 = interpolation_result[1,2];
   tau_bf1 = noEvent(abs(interpolation_result[1,3]));
   tau_bf2 = noEvent(abs(interpolation_result[1,4]));
   if Modelica.Math.isEqual(eta_mf1,1.0,Modelica.Constants.eps) and Modelica.Math.isEqual(eta_mf2,1.0,Modelica.Constants.eps) then
    tau_bf_a = tau_bf1/(2);
   else
    tau_bf_a = (tau_bf1-tau_bf2)/(eta_mf1-1.0/(eta_mf2));
   end if;
   phi_a = _famefault_flange_a.port_b.phi-phi_support;
   phi_b = _famefault_flange_b.port_b.phi-phi_support;
   phi_a = ratio*phi_b;
   0 = _famefault_flange_b.port_b.tau+ratio*(_famefault_flange_a.port_b.tau-tauLoss);
   w_a = der(phi_a);
   a_a = der(w_a);
   tau_eta_p = _famefault_flange_a.port_b.tau-tau_bf_a_0;
   tau_eta_m = _famefault_flange_a.port_b.tau+tau_bf_a_0;
   quadrant1_p = (1-eta_mf1_0)*_famefault_flange_a.port_b.tau+tau_bf1_0;
   quadrant2_p = (1-1/(eta_mf2_0))*_famefault_flange_a.port_b.tau+tau_bf2_0;
   tauLossMax_p = (if noEvent(tau_eta_p>0) then quadrant1_p else quadrant2_p);
   quadrant4_m = (1-1/(eta_mf2_0))*_famefault_flange_a.port_b.tau-tau_bf2_0;
   quadrant3_m = (1-eta_mf1_0)*_famefault_flange_a.port_b.tau-tau_bf1_0;
   tauLossMin_m = (if noEvent(tau_eta_m>0) then quadrant4_m else quadrant3_m);
   quadrant1 = (1-eta_mf1)*_famefault_flange_a.port_b.tau+tau_bf1;
   quadrant2 = (1-1/(eta_mf2))*_famefault_flange_a.port_b.tau+tau_bf2;
   quadrant4 = (1-1/(eta_mf2))*_famefault_flange_a.port_b.tau-tau_bf2;
   quadrant3 = (1-eta_mf1)*_famefault_flange_a.port_b.tau-tau_bf1;
   tau_eta = (if ideal then _famefault_flange_a.port_b.tau else (if locked then _famefault_flange_a.port_b.tau else (if startForward or (pre(mode)==Forward) then _famefault_flange_a.port_b.tau-tau_bf_a else _famefault_flange_a.port_b.tau+tau_bf_a)));
   tau_etaPos = tau_eta>=0;
   tau_aPos = tau_etaPos;
   tauLossMax = (if tau_etaPos then quadrant1 else quadrant2);
   tauLossMin = (if tau_etaPos then quadrant4 else quadrant3);
   startForward = ((pre(mode)==Stuck) and (sa>(tauLossMax_p/(unitTorque)))) or (initial() and (w_a>0));
   startBackward = ((pre(mode)==Stuck) and (sa<(tauLossMin_m/(unitTorque)))) or (initial() and (w_a<0));
   locked = not (((ideal or (pre(mode)==Forward)) or startForward) or (pre(mode)==Backward)) or startBackward;
   tauLoss = (if ideal then 0 else (if locked then sa*unitTorque else (if startForward or (pre(mode)==Forward) then tauLossMax else tauLossMin)));
   a_a = unitAngularAcceleration*(if locked then 0 else sa-tauLoss/(unitTorque));
   mode = (if ideal then Free else (if ((pre(mode)==Forward) or startForward) and (w_a>0) then Forward else (if ((pre(mode)==Backward) or startBackward) and (w_a<0) then Backward else Stuck)));
   lossPower = tauLoss*w_a;
   if not useSupport then
    phi_support = 0;
   end if;
   connect(support,_famefault_support.port_a);
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);
   connect(heatPort,_famefault_heatPort.port_a);

  annotation(Documentation(info="<HTML>
<p>
This component models the gear ratio and the <b>losses</b> of
a standard gear box in a <b>reliable</b> way including the stuck phases
that may occur at zero speed. The gear boxes that can
be handeled are fixed in the ground or on a moving support, have one input and one
output shaft, and are essentially described by the equations:
</p>
<blockquote><pre>
             flange_a.phi  = i*flange_b.phi;
-(flange_b.tau - tau_bf_b) = i*eta_mf*(flange_a.tau - tau_bf_a);

// or        -flange_b.tau = i*eta_mf*(flange_a.tau - tau_bf_a - tau_bf_b/(i*eta_mf));
</pre></blockquote>
<p>
where
</p>

<ul>
<li> <b>i</b> is the constant <b>gear ratio</b>, </li>

<li> <b>eta_mf</b> = eta_mf(w_a) is the <b>mesh efficiency</b> due to the
     friction between the teeth of the gear wheels, </li>

<li> <b>tau_bf_a</b> = tau_bf_a(w_a) is the <b>bearing friction torque</b>
     on the flange_a side,</li>

<li> <b>tau_bf_b</b> = tau_bf_b(w_a) is the <b>bearing friction torque</b>
     on the flange_b side, and</li>

<li><b>w_a</b> = der(flange_a.phi) is the speed of flange_a</li>
</ul>

<p>
The loss terms \"eta_mf\", \"tau_bf_a\" and \"tau_bf_b\" are functions of the
<i>absolute value</i> of the input shaft speed w_a and of the energy
flow direction. They are defined by parameter <b>lossTable[:,5]
</b> where the columns of this table have the following
meaning:
</p>

<table BORDER=1 CELLSPACING=0 CELLPADDING=2>
  <tbody>
    <tr>
      <td valign=\"top\">|w_a|</td>
      <td valign=\"top\">eta_mf1</td>
      <td valign=\"top\">eta_mf2</td>
      <td valign=\"top\">|tau_bf1|</td>
      <td valign=\"top\">|tau_bf2|</td>
    </tr>
    <tr>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
    </tr>
    <tr>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
      <td align=\"center\">...</td>
    </tr>
  </tbody>
</table>

<p>with</p>
<table BORDER=1 CELLSPACING=0 CELLPADDING=2>
  <tbody>
    <tr>
      <td valign=\"top\">|w_a|</td>
      <td valign=\"top\">Absolute value of angular velocity of input shaft flange_a</td>
    </tr>
    <tr>
      <td valign=\"top\">eta_mf1</td>
      <td valign=\"top\">Mesh efficiency in case that flange_a is driving</td>
    </tr>
    <tr>
      <td valign=\"top\">eta_mf2</td>
      <td valign=\"top\">Mesh efficiency in case that flange_b is driving</td>
    </tr>
    <tr>
      <td valign=\"top\">|tau_bf1|</td>
      <td valign=\"top\"> Absolute resultant bearing friction torque with respect to flange_a
                        in case that flange_a is driving<br>
                        (= |tau_bf_a*eta_mf1 + tau_bf_b/i|)
                        </td>
    </tr>
    <tr>
      <td valign=\"top\">|tau_bf2|</td>
      <td valign=\"top\"> Absolute resultant bearing friction torque with respect to flange_a
                        in case that flange_b is driving<br>
                        (= |tau_bf_a/eta_mf2 + tau_bf_b/i|)
                        </td>
    </tr>
  </tbody>
</table>
<p>
With these variables, the mesh efficiency and the bearing friction
are formally defined as:
</p>

<blockquote><pre>
<b>if</b> (flange_a.tau - tau_bf_a)*w_a &gt; 0 <b>or</b>
   (flange_a.tau - tau_bf_a) == 0 <b>and</b> w_a &gt; 0 <b>then</b>
   eta_mf := eta_mf1
   tau_bf := tau_bf1
<b>elseif</b> (flange_a.tau - tau_bf_a)*w_a &lt; 0 <b>or</b>
       (flange_a.tau - tau_bf_a) == 0 <b>and</b> w_a &lt; 0 <b>then</b>
   eta_mf := 1/eta_mf2
   tau_bf := tau_bf2
<b>else</b> // w_a == 0
   eta_mf and tau_bf are computed such that <b>der</b>(w_a) = 0
<b>end if</b>;
-flange_b.tau = i*(eta_mf*flange_a.tau - tau_bf);
</pre></blockquote>

<p>
Note, that the losses are modeled in a physically meaningful way taking
into account that at zero speed the movement may be locked due
to the friction in the gear teeth and/or in the bearings.
Due to this important property, this component can be used in
situations where the combination of the components
Modelica.Mechanics.Rotational.IdealGear and
Modelica.Mechanics.Rotational.GearEfficiency will fail because,
e.g., chattering occurs when using the
Modelica.Mechanics.Rotational.GearEfficiency model.
</p>

<h4>Acknowledgement:</h4>
<ul>
<li> The essential idea to model efficiency
     in this way is from Christoph Pelchen, ZF Friedrichshafen.</li>
<li> The article (Pelchen et.al. 2002), see Literature below,
     and the first implementation of LossyGear (up to version 3.1 of package Modelica)
     contained a bug leading to a non-converging solution in cases where the
     driving side is not obvious.
     This was pointed out by Christian Bertsch and Max Westenkirchner, Bosch,
     and Christian Bertsch proposed a concrete solution how to fix this
     bug, see Literature below.</li>
</ul>

<h4>Literature</h4>

<ul>
<li>Pelchen C.,
<a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Schweiger C.</a>,
and <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Otter M.</a>:
&quot;<a href=\"http://www.modelica.org/Conference2002/papers/p33_Pelchen.pdf\">Modeling
and Simulating the Efficiency of Gearboxes and of Planetary Gearboxes</A>,&quot; in
<I>Proceedings of the 2nd International Modelica Conference, Oberpfaffenhofen, Germany,</I>
pp. 257-266, The Modelica Association and Institute of Robotics and Mechatronics,
Deutsches Zentrum f&uuml;r Luft- und Raumfahrt e. V., March 18-19, 2002.</li>

<li>Bertsch C. (2009):
&quot;<a href=\"modelica://Modelica/Resources/Documentation/Mechanics/Lossy-Gear-Bug_Solution.pdf\">Problem
with model LossyGear and a proposed solution</a>&quot;,
Ticket <a href=\"http://trac.modelica.org/Modelica/ticket/108\">#108</a>,
Sept. 11, 2009.</li>
</ul>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Polygon(points={{-109,40},{-80,40},{-80,80},{-90,80},{-70,100},{-50,80},{-60,80},{-60,20},{-109,20},{-109,40}},lineColor={0,0,0},fillColor={255,0,0},fillPattern=FillPattern.Solid),Line(points={{-80,20},{-60,20}},color={0,0,0}),Text(extent={{-148,145},{152,105}},lineColor={0,0,255},textString="%name"),Text(extent={{-145,-49},{155,-79}},lineColor={0,0,0},textString="ratio=%ratio"),Line(visible=useHeatPort,points={{-100,-100},{-100,-30},{0,-30},{0,0}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end LossyGear;

  model IdealPlanetary
   "Ideal planetary gear box"

  // locally defined classes in IdealPlanetary
      model _famefaults_ring = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_carrier = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_sun = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of IdealPlanetary
   Modelica.Mechanics.Rotational.Interfaces.Flange_b ring "Flange of ring shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_ring(amount=0.0);
   parameter Real ratio(start=100/(50)) "Number of ring_teeth/sun_teeth (e.g., ratio=100/50)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a carrier "Flange of carrier shaft" annotation(Placement(transformation(extent={{-110,30},{-90,50}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_carrier(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_a sun "Flange of sun shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_sun(amount=0.0);

  // algorithms and equations of IdealPlanetary
  equation
   (1+ratio)*_famefault_carrier.port_b.phi = _famefault_sun.port_b.phi+ratio*_famefault_ring.port_b.phi;
   _famefault_ring.port_b.tau = ratio*_famefault_sun.port_b.tau;
   _famefault_carrier.port_b.tau = (-(1+ratio))*_famefault_sun.port_b.tau;
   connect(ring,_famefault_ring.port_a);
   connect(carrier,_famefault_carrier.port_a);
   connect(sun,_famefault_sun.port_a);

  annotation(Documentation(info="<HTML>
<p>
The IdealPlanetary gear box is an ideal gear without inertia,
elasticity, damping or backlash consisting
of an inner <b>sun</b> wheel, an outer <b>ring</b> wheel and a
<b>planet</b> wheel located between sun and ring wheel. The bearing
of the planet wheel shaft is fixed in the planet <b>carrier</b>.
The component can be connected to other elements at the
sun, ring and/or carrier flanges. It is not possible to connect
to the planet wheel. If inertia shall not be neglected,
the sun, ring and carrier inertias can be easily added by attaching
inertias (= model Inertia) to the corresponding connectors.
The inertias of the planet wheels are always neglected.
</p>
<p>
The icon of the planetary gear signals that the sun and carrier
flanges are on the left side and the ring flange is on the right side
of the gear box. However, this component is generic and is valid
independantly how the flanges are actually placed (e.g., sun wheel
may be placed on the right side instead on the left side in reality).
</p>
<p>
The ideal planetary gearbox is uniquely defined by the ratio
of the number of ring teeth zr with respect to the number of
sun teeth zs. For example, if there are 100 ring teeth and
50 sun teeth then ratio = zr/zs = 2. The number of planet teeth
zp has to fulfill the following relationship:
</p>
<pre>
   <b>zp := (zr - zs) / 2</b>
</pre>
<p>
Therefore, in the above example zp = 25 is required.
</p>
<p>
According to the overall convention, the positive direction of all
vectors, especially the absolute angular velocities and cut-torques
in the flanges, are along the axis vector displayed in the icon.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{50,100},{10,-100}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-10,45},{-50,85}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-10,30},{-50,-30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-50,10},{-100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{100,10},{50,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{50,100},{-50,105}},lineColor={160,160,164},fillColor={160,160,164},fillPattern=FillPattern.Solid),Rectangle(extent={{50,-100},{-50,-105}},lineColor={160,160,164},fillColor={160,160,164},fillPattern=FillPattern.Solid),Rectangle(extent={{-80,70},{-50,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-90,40},{-70,40}},color={0,0,0}),Line(points={{-80,50},{-60,50}},color={0,0,0}),Line(points={{-70,50},{-70,40}},color={0,0,0}),Line(points={{-80,80},{-59,80}},color={0,0,0}),Line(points={{-70,100},{-70,80}},color={0,0,0}),Text(extent={{-150,150},{150,110}},textString="%name",lineColor={0,0,255}),Text(extent={{-150,-110},{150,-150}},lineColor={0,0,0},textString="ratio=%ratio")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{50,100},{10,-100}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-10,45},{-50,85}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-10,30},{-50,-30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-50,10},{-100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{100,10},{50,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{50,100},{-50,105}},lineColor={160,160,164},fillColor={160,160,164},fillPattern=FillPattern.Solid),Rectangle(extent={{50,-100},{-50,-105}},lineColor={160,160,164},fillColor={160,160,164},fillPattern=FillPattern.Solid),Rectangle(extent={{-80,70},{-50,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-90,40},{-70,40}},color={0,0,0}),Line(points={{-80,50},{-60,50}},color={0,0,0}),Line(points={{-70,50},{-70,40}},color={0,0,0}),Line(points={{-80,80},{-59,80}},color={0,0,0}),Line(points={{-70,90},{-70,80}},color={0,0,0}),Line(points={{-26,-42},{-32,-2}},pattern=LinePattern.Dot,color={0,0,255}),Line(points={{36,-26},{64,-60}},pattern=LinePattern.Dot,color={0,0,255}),Text(extent={{58,-66},{98,-78}},textString="ring gear",lineColor={0,0,255}),Text(extent={{-112,111},{-56,87}},textString="planet carrier ",lineColor={0,0,255}),Text(extent={{-47,-42},{-3,-56}},textString="sun gear",lineColor={0,0,255}),Polygon(points={{58,130},{28,140},{28,120},{58,130}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Line(points={{-52,130},{28,130}},color={0,0,0}),Line(points={{-92,93},{-70,80}},pattern=LinePattern.Dot,color={0,0,255}),Polygon(points={{-7,-86},{-27,-81},{-27,-91},{-7,-86}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Line(points={{-97,-86},{-26,-86}},color={128,128,128}),Text(extent={{-96,-71},{-28,-84}},lineColor={128,128,128},textString="rotation axis")}));
  end IdealPlanetary;

  model Gearbox
   "Realistic model of a gearbox (based on LossyGear)"
   extends Modelica.Mechanics.Rotational.Icons.Gearbox;
   extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlangesAndSupport;
   extends Modelica.Thermal.HeatTransfer.Interfaces.PartialConditionalHeatPort(final T=293.15);

  // components of Gearbox
   parameter Real ratio(start=1) "Transmission ratio (flange_a.phi/flange_b.phi)";
   parameter Real lossTable[:,5]=[0, 1, 1, 0, 0] "Array for mesh efficiencies and bearing friction depending on speed (see docu of LossyGear)";
   parameter SI.RotationalSpringConstant c(final min=Modelica.Constants.small,start=1.0e5) "Gear elasticity (spring constant)";
   parameter SI.RotationalDampingConstant d(final min=0,start=0) "(relative) gear damping";
   parameter SI.Angle b(final min=0)=0 "Total backlash";
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=1e-4)=flange_b.phi-lossyGear.flange_b.phi "Relative rotation angle over gear elasticity (= flange_b.phi - lossyGear.flange_b.phi)";
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect)=der(phi_rel) "Relative angular velocity over gear elasticity (= der(phi_rel))";
   Modelica.SIunits.AngularAcceleration a_rel(start=0)=der(w_rel) "Relative angular acceleration over gear elasticity (= der(w_rel))";
   Rotational.Components.LossyGear lossyGear(final ratio=ratio,final lossTable=lossTable,final useSupport=true,final useHeatPort=true) annotation(Placement(transformation(extent={{-60,-20},{-20,20}},rotation=0)));
   Rotational.Components.ElastoBacklash elastoBacklash(final b=b,final c=c,final phi_rel0=0,final d=d,final useHeatPort=true) annotation(Placement(transformation(extent={{20,-20},{60,20}},rotation=0)));

  // algorithms and equations of Gearbox
  equation
   connect(flange_a,lossyGear.flange_a) annotation(Line(points={{-100,0},{-90,0},{-90,1.77636e-015},{-80,1.77636e-015},{-80,0},{-60,0}},color={0,0,0}));
   connect(lossyGear.flange_b,elastoBacklash.flange_a) annotation(Line(points={{-20,0},{-10,0},{-10,2.4425e-015},{0,2.4425e-015},{0,0},{20,0}},color={0,0,0}));
   connect(elastoBacklash.flange_b,flange_b) annotation(Line(points={{60,0},{70,0},{70,1.77636e-015},{80,1.77636e-015},{80,0},{100,0}},color={0,0,0}));
   connect(elastoBacklash.heatPort,internalHeatPort) annotation(Line(points={{20,-20},{20,-60},{-100,-60},{-100,-80}},color={191,0,0},smooth=Smooth.None));
   connect(lossyGear.heatPort,internalHeatPort) annotation(Line(points={{-60,-20},{-60,-60},{-100,-60},{-100,-80}},color={191,0,0},smooth=Smooth.None));
   connect(lossyGear.support,internalSupport) annotation(Line(points={{-40,-20},{-40,-40},{0,-40},{0,-80}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>This component models the essential effects of a gearbox, in
particular</p>
<ul>
  <li>in component <b>lossyGear</b></li>
    <ul>
      <li>gear <b>efficiency</b> due to friction between the teeth</li>
      <li><b>bearing friction</b></li>
    </ul>
  <li>in component <b>elastoBacklash</b></li>
    <ul>
      <li>gear <b>elasticity</b></li>
      <li><b>damping</b></li>
      <li><b>backlash</b></li>
    </ul>
</ul>
<p>The inertia of the gear wheels is not modeled. If necessary,
inertia has to be taken into account by connecting components of
model Inertia to the left and/or the right flange of component
Gearbox.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Text(extent={{-150,150},{150,110}},lineColor={0,0,255},textString="%name"),Text(extent={{-150,70},{150,100}},lineColor={0,0,0},textString="ratio=%ratio, c=%c"),Line(visible=useHeatPort,points={{-100,-100},{-100,-30},{0,-30}},color={191,0,0},pattern=LinePattern.Dot,smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics));
  end Gearbox;

  model IdealGearR2T
   "Gearbox transforming rotational into translational motion"

  // locally defined classes in IdealGearR2T
      model _famefaults_supportR = FAME.Dampers.RotationalWithConnectEquations;
      model _famefaults_flangeR = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_supportT = FAME.Dampers.TranslationalWithConnectEquations;
      model _famefaults_flangeT = FAME.Dampers.TranslationalWithoutConnectEquations;

  // components of IdealGearR2T
   Modelica.Mechanics.Rotational.Interfaces.Support supportR if useSupportR "Rotational support/housing of component" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}},rotation=0),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.RotationalWithConnectEquations _famefault_supportR(amount=0.0) if useSupportR;
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flangeR "Flange of rotational shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flangeR(amount=0.0);
   Modelica.Mechanics.Translational.Interfaces.Support supportT if useSupportT "Translational support/housing of component" annotation(Placement(transformation(extent={{110,-110},{90,-90}},rotation=0),iconTransformation(extent={{90,-110},{110,-90}})));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_supportT(amount=0.0) if useSupportT;
   parameter Real ratio(final unit="rad/m",start=1) "Transmission ratio (flange_a.phi/flange_b.s)";
   Modelica.Mechanics.Translational.Interfaces.Flange_b flangeT "Flange of translational rod" annotation(Placement(transformation(extent={{90,10},{110,-10}},rotation=0)));
   FAME.Dampers.TranslationalWithoutConnectEquations _famefault_flangeT(amount=0.0);
   parameter Boolean useSupportR=false "= true, if rotational support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Boolean useSupportT=false "= true, if translational support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
  protected
   Modelica.Mechanics.Translational.Interfaces.InternalSupport internalSupportT(f=-flangeT.f) annotation(Placement(transformation(extent={{90,-90},{110,-70}})));
   Modelica.Mechanics.Translational.Components.Fixed fixedT if not useSupportT annotation(Placement(transformation(extent={{70,-90},{90,-70}})));
   Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalSupportR(tau=-flangeR.tau) annotation(Placement(transformation(extent={{-110,-90},{-90,-70}})));
   Modelica.Mechanics.Rotational.Components.Fixed fixedR if not useSupportR annotation(Placement(transformation(extent={{-90,-90},{-70,-70}})));

  // algorithms and equations of IdealGearR2T
  equation
   _famefault_flangeR.port_b.phi-internalSupportR.phi = ratio*(_famefault_flangeT.port_b.s-internalSupportT.s);
   0 = ratio*_famefault_flangeR.port_b.tau+_famefault_flangeT.port_b.f;
   connect(internalSupportR.flange,_famefault_supportR.port_b) annotation(Line(points={{-100,-80},{-100,-100}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupportR.flange,fixedR.flange) annotation(Line(points={{-100,-80},{-80,-80}},color={0,0,0},smooth=Smooth.None));
   connect(fixedT.flange,internalSupportT.flange) annotation(Line(points={{80,-80},{100,-80}},color={0,127,0},smooth=Smooth.None));
   connect(internalSupportT.flange,_famefault_supportT.port_b) annotation(Line(points={{100,-80},{100,-100}},color={0,127,0},smooth=Smooth.None));
   connect(supportR,_famefault_supportR.port_a);
   connect(flangeR,_famefault_flangeR.port_a);
   connect(supportT,_famefault_supportT.port_a);
   connect(flangeT,_famefault_flangeT.port_a);

  annotation(Documentation(info="<html>
This is an ideal mass- and inertialess gearbox which transforms a
1D-rotational into a 1D-translational motion. If elasticity, damping
or backlash has to be considered, this ideal gearbox has to be
connected with corresponding elements.
This component defines the kinematic constraint:
</p>

<pre>
  (flangeR.phi - internalSupportR.phi) = ratio*(flangeT.s - internalSupportT.s);
</pre>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Ellipse(extent={{-70,40},{10,-40}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-40,10},{-20,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,10},{-70,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-150,125},{150,85}},lineColor={0,0,255},textString="%name"),Polygon(points={{-74,-60},{-54,-40},{-34,-60},{-14,-40},{6,-60},{26,-40},{46,-60},{66,-40},{86,-60},{-74,-60}},lineColor={0,0,0},fillColor={160,160,164},fillPattern=FillPattern.Solid),Rectangle(extent={{95,-10},{106,-60}},lineColor={0,0,0},fillColor={160,160,164},fillPattern=FillPattern.Solid),Rectangle(extent={{-74,-60},{106,-80}},lineColor={0,0,0},fillColor={160,160,164},fillPattern=FillPattern.Solid),Text(extent={{-150,80},{150,50}},lineColor={0,0,0},textString="ratio=%ratio"),Line(points={{-100,15},{-80,15}},color={0,0,0},smooth=Smooth.None),Line(points={{-100,-16},{-80,-16}},color={0,0,0},smooth=Smooth.None),Line(points={{-100,-16},{-100,-100}},color={0,0,0},smooth=Smooth.None),Line(points={{100,-80},{100,-100}},color={0,0,0},smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end IdealGearR2T;

  model IdealRollingWheel
   "Simple 1-dim. model of an ideal rolling wheel without inertia"

  // locally defined classes in IdealRollingWheel
      model _famefaults_supportR = FAME.Dampers.RotationalWithConnectEquations;
      model _famefaults_flangeR = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_supportT = FAME.Dampers.TranslationalWithConnectEquations;
      model _famefaults_flangeT = FAME.Dampers.TranslationalWithoutConnectEquations;

  // components of IdealRollingWheel
   Modelica.Mechanics.Rotational.Interfaces.Support supportR if useSupportR "Rotational support/housing of component" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}},rotation=0),iconTransformation(extent={{-110,-110},{-90,-90}})));
   FAME.Dampers.RotationalWithConnectEquations _famefault_supportR(amount=0.0) if useSupportR;
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flangeR "Flange of rotational shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flangeR(amount=0.0);
   Modelica.Mechanics.Translational.Interfaces.Support supportT if useSupportT "Translational support/housing of component" annotation(Placement(transformation(extent={{110,-110},{90,-90}},rotation=0),iconTransformation(extent={{90,-110},{110,-90}})));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_supportT(amount=0.0) if useSupportT;
   Modelica.Mechanics.Translational.Interfaces.Flange_b flangeT "Flange of translational rod" annotation(Placement(transformation(extent={{90,10},{110,-10}},rotation=0)));
   FAME.Dampers.TranslationalWithoutConnectEquations _famefault_flangeT(amount=0.0);
   parameter Boolean useSupportR=false "= true, if rotational support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.Distance radius(start=0.3) "Wheel radius";
   parameter Boolean useSupportT=false "= true, if translational support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
  protected
   Modelica.Mechanics.Translational.Interfaces.InternalSupport internalSupportT(f=-flangeT.f) annotation(Placement(transformation(extent={{90,-90},{110,-70}})));
   Modelica.Mechanics.Translational.Components.Fixed fixedT if not useSupportT annotation(Placement(transformation(extent={{70,-90},{90,-70}})));
   Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalSupportR(tau=-flangeR.tau) annotation(Placement(transformation(extent={{-110,-90},{-90,-70}})));
   Modelica.Mechanics.Rotational.Components.Fixed fixedR if not useSupportR annotation(Placement(transformation(extent={{-90,-90},{-70,-70}})));

  // algorithms and equations of IdealRollingWheel
  equation
   (_famefault_flangeR.port_b.phi-internalSupportR.phi)*radius = _famefault_flangeT.port_b.s-internalSupportT.s;
   0 = radius*_famefault_flangeT.port_b.f+_famefault_flangeR.port_b.tau;
   connect(internalSupportR.flange,_famefault_supportR.port_b) annotation(Line(points={{-100,-80},{-100,-100}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupportR.flange,fixedR.flange) annotation(Line(points={{-100,-80},{-80,-80}},color={0,0,0},smooth=Smooth.None));
   connect(fixedT.flange,internalSupportT.flange) annotation(Line(points={{80,-80},{100,-80}},color={0,127,0},smooth=Smooth.None));
   connect(internalSupportT.flange,_famefault_supportT.port_b) annotation(Line(points={{100,-80},{100,-100}},color={0,127,0},smooth=Smooth.None));
   connect(supportR,_famefault_supportR.port_a);
   connect(flangeR,_famefault_flangeR.port_a);
   connect(supportT,_famefault_supportT.port_a);
   connect(flangeT,_famefault_flangeT.port_a);

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,10},{-46,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Ellipse(extent={{-50,80},{10,-80}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={160,160,164}),Rectangle(extent={{-20,80},{12,-80}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={160,160,164}),Ellipse(extent={{-16,80},{44,-80}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={160,160,164}),Ellipse(extent={{-2,52},{34,-52}},lineColor={192,192,192},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{12,10},{20,-10}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Rectangle(extent={{16,10},{60,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Ellipse(extent={{56,10},{64,-10}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Text(extent={{-150,130},{150,90}},textString="%name",lineColor={0,0,255}),Polygon(points={{80,10},{80,26},{60,26},{60,20},{70,20},{70,-20},{60,-20},{60,-26},{80,-26},{80,-10},{90,-10},{90,10},{80,10}},lineColor={0,127,0},fillColor={0,127,0},fillPattern=FillPattern.Solid),Line(points={{-100,-20},{-60,-20}},color={0,0,0},smooth=Smooth.None),Line(points={{-100,-20},{-100,-100}},color={0,0,0},smooth=Smooth.None),Line(points={{-100,20},{-60,20}},color={0,0,0},smooth=Smooth.None),Line(points={{100,-90},{-40,-90}},color={0,127,0},smooth=Smooth.None),Line(points={{70,-26},{70,-50},{100,-50},{100,-100}},color={0,127,0},smooth=Smooth.None)}),Documentation(info="<html>
<p>
A simple kinematic model of a rolling wheel which has no inertia and
no rolling resistance. This component defines the kinematic constraint:
</p>

<pre>
   (flangeR.phi - internalSupportR.phi)*wheelRadius = (flangeT.s - internalSupportT.s);
</pre>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end IdealRollingWheel;

  model InitializeFlange
   "Initializes a flange with pre-defined angle, speed and angular acceleration (usually, this is reference data from a control bus)"
   extends Modelica.Blocks.Interfaces.BlockIcon;

  // locally defined classes in InitializeFlange

  // components of InitializeFlange
   parameter Boolean use_phi_start=true "= true, if initial angle is defined by input phi_start, otherwise not initialized";
   parameter Boolean use_w_start=true "= true, if initial speed is defined by input w_start, otherwise not initialized";
   parameter Boolean use_a_start=true "= true, if initial angular acceleration is defined by input a_start, otherwise not initialized";
   parameter StateSelect stateSelect=StateSelect.default "Priority to use flange angle and speed as states";
   Modelica.Blocks.Interfaces.RealInput phi_start if use_phi_start "Initial angle of flange" annotation(Placement(transformation(extent={{-140,60},{-100,100}},rotation=0),iconTransformation(extent={{-140,60},{-100,100}})));
   Modelica.Blocks.Interfaces.RealInput w_start if use_w_start "Initial speed of flange" annotation(Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
   Modelica.Blocks.Interfaces.RealInput a_start if use_a_start "Initial angular acceleration of flange" annotation(Placement(transformation(extent={{-140,-100},{-100,-60}},rotation=0),iconTransformation(extent={{-140,-100},{-100,-60}})));
   Interfaces.Flange_b flange "Flange that is initialized" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Modelica.SIunits.Angle phi_flange(stateSelect=stateSelect)=flange.phi "Flange angle";
   Modelica.SIunits.AngularVelocity w_flange(stateSelect=stateSelect)=der(phi_flange) "= der(phi_flange)";
  protected

   encapsulated model Set_phi_start
    "Set phi_start"
    extends Modelica.Blocks.Interfaces.BlockIcon;

    import Modelica;

   // components of Set_phi_start
    Modelica.Blocks.Interfaces.RealInput phi_start "Start angle" annotation(HideResult=true,Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));

   // algorithms and equations of Set_phi_start
   initial equation
    flange.phi = phi_start;
   equation
    flange.tau = 0;
   end Set_phi_start;

   encapsulated model Set_w_start
    "Set w_start"
    extends Modelica.Blocks.Interfaces.BlockIcon;

    import Modelica;

   // components of Set_w_start
    Modelica.Blocks.Interfaces.RealInput w_start "Start angular velocity" annotation(HideResult=true,Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));

   // algorithms and equations of Set_w_start
   initial equation
    der(flange.phi) = w_start;
   equation
    flange.tau = 0;
   end Set_w_start;

   encapsulated model Set_a_start
    "Set a_start"
    extends Modelica.Blocks.Interfaces.BlockIcon;

    import Modelica;

   // components of Set_a_start
    Modelica.Blocks.Interfaces.RealInput a_start "Start angular acceleration" annotation(HideResult=true,Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange(phi(stateSelect=StateSelect.avoid)) annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
    Modelica.SIunits.AngularVelocity w=der(flange.phi) annotation(HideResult=true);

   // algorithms and equations of Set_a_start
   initial equation
    der(w) = a_start;
   equation
    flange.tau = 0;

   annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics));
   end Set_a_start;

   encapsulated model Set_flange_tau
    "Set flange.tau to zero"
    extends Modelica.Blocks.Interfaces.BlockIcon;

    import Modelica;

   // components of Set_flange_tau
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));

   // algorithms and equations of Set_flange_tau
   equation
    flange.tau = 0;
   end Set_flange_tau;
  protected
   Set_phi_start set_phi_start if use_phi_start annotation(Placement(transformation(extent={{-20,70},{0,90}},rotation=0)));
   Set_w_start set_w_start if use_w_start annotation(Placement(transformation(extent={{-20,-10},{0,10}},rotation=0)));
   Set_a_start set_a_start if use_a_start annotation(Placement(transformation(extent={{-20,-90},{0,-70}},rotation=0)));
   Set_flange_tau set_flange_tau annotation(Placement(transformation(extent={{96,-90},{76,-70}},rotation=0)));

  // algorithms and equations of InitializeFlange
  equation
   connect(set_phi_start.phi_start,phi_start) annotation(Line(points={{-22,80},{-120,80}},color={0,0,127},smooth=Smooth.None));
   connect(set_phi_start.flange,flange) annotation(Line(points={{0,80},{60,80},{60,0},{100,0}},color={0,0,0},smooth=Smooth.None));
   connect(set_w_start.flange,flange) annotation(Line(points={{0,0},{25,0},{25,1.16573e-015},{50,1.16573e-015},{50,0},{100,0}},color={0,0,0},smooth=Smooth.None));
   connect(set_w_start.w_start,w_start) annotation(Line(points={{-22,0},{-46.5,0},{-46.5,1.77636e-015},{-71,1.77636e-015},{-71,0},{-120,0}},color={0,0,127},smooth=Smooth.None));
   connect(set_a_start.a_start,a_start) annotation(Line(points={{-22,-80},{-120,-80}},color={0,0,127},smooth=Smooth.None));
   connect(set_a_start.flange,flange) annotation(Line(points={{0,-80},{60,-80},{60,0},{100,0}},color={0,0,0},smooth=Smooth.None));
   connect(set_flange_tau.flange,flange) annotation(Line(points={{76,-80},{60,-80},{60,0},{100,0}},color={0,0,0},smooth=Smooth.None));

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Text(extent={{-94,94},{68,66}},lineColor={0,0,0},textString="phi_start"),Text(extent={{-94,16},{70,-14}},lineColor={0,0,0},textString="w_start"),Text(extent={{-92,-68},{68,-96}},lineColor={0,0,0},textString="a_start")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Documentation(info="<html>
<p>
This component is used to optionally initialize the angle, speed,
and/or angular acceleration of the flange to which this component
is connected. Via parameters use_phi_start, use_w_start, use_a_start
the corresponding input signals phi_start, w_start, a_start are conditionally
activated. If an input is activated, the corresponding flange property
is initialized with the input value at start time.
</p>

<p>
For example, if \"use_phi_start = true\", then flange.phi is initialized
with the value of the input signal \"phi_start\" at the start time.
</p>

<p>
Additionally, it is optionally possible to define the \"StateSelect\"
attribute of the flange angle and the flange speed via paramater
\"stateSelection\".
</p>

<p>
This component is especially useful when the initial values of a flange
shall be set according to reference signals of a controller that are
provided via a signal bus.
</p>

</html>"));
  end InitializeFlange;

  model RelativeStates
   "Definition of relative state variables"

  // locally defined classes in RelativeStates
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of RelativeStates
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use the relative angle and relative speed as states";
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect) "Relative rotation angle used as state variable";
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity used as state variable";
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration";

  // algorithms and equations of RelativeStates
  equation
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   _famefault_flange_a.port_b.tau = 0;
   _famefault_flange_b.port_b.tau = 0;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Usually, the absolute angle and the absolute angular velocity of
Modelica.Mechanics.Rotational.Components.Inertia models are used as state variables.
In some circumstances, relative quantities are better suited, e.g.,
because it may be easier to supply initial values.
In such cases, model <b>RelativeStates</b> allows the definition of state variables
in the following way:
</p>
<ul>
<li> Connect an instance of this model between two flange connectors.</li>
<li> The <b>relative rotation angle</b> and the <b>relative angular velocity</b>
     between the two connectors are used as <b>state variables</b>.
</ul>
<p>
An example is given in the next figure
</p>

<IMG src=\"modelica://Modelica/Resources/Images/Rotational/relativeStates.png\" ALT=\"relativeStates\">

<p>
Here, the relative angle and the relative angular velocity between
the two inertias are used as state variables. Additionally, the
simulator selects either the absolute angle and absolute angular
velocity of model inertia1 or of model inertia2 as state variables.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Ellipse(extent={{-40,40},{40,-40}},lineColor={0,255,255},fillColor={0,255,255},fillPattern=FillPattern.Solid),Text(extent={{-40,40},{40,-40}},textString="S",lineColor={0,0,255}),Line(points={{-92,0},{-42,0}},color={0,0,0},pattern=LinePattern.Dot),Line(points={{40,0},{90,0}},color={0,0,0},pattern=LinePattern.Dot),Text(extent={{-150,-40},{150,-80}},textString="%name",lineColor={0,0,255})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Ellipse(extent={{-40,40},{40,-40}},lineColor={0,255,255},fillColor={0,255,255},fillPattern=FillPattern.Solid),Text(extent={{-40,40},{40,-40}},textString="S",lineColor={0,0,255}),Line(points={{40,0},{96,0}},color={0,0,0},pattern=LinePattern.Dash),Line(points={{-100,-10},{-100,-80}},color={160,160,164}),Line(points={{100,-10},{100,-80}},color={160,160,164}),Polygon(points={{80,-65},{80,-55},{100,-60},{80,-65}},lineColor={160,160,164},fillColor={160,160,164},fillPattern=FillPattern.Solid),Line(points={{-100,-60},{80,-60}},color={160,160,164}),Text(extent={{-30,-70},{30,-90}},textString="w_rel",lineColor={0,0,255}),Line(points={{-76,80},{-5,80}},color={128,128,128}),Polygon(points={{14,80},{-6,85},{-6,75},{14,80}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{18,87},{86,74}},lineColor={128,128,128},textString="rotation axis"),Line(points={{-96,0},{-40,0}},color={0,0,0},pattern=LinePattern.Dash)}));
  end RelativeStates;

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-58,8},{42,-92}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-100,-32},{-58,-52}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{42,-32},{80,-52}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192})}),Documentation(info="<html>
<p>
This package contains basic components 1D mechanical rotational drive trains.
</p>
</html>"));
 end Components;

 package Sensors
  "Sensors to measure variables in 1D rotational mechanical components"
  extends Modelica.Icons.SensorsPackage;

  model AngleSensor
   "Ideal sensor to measure the absolute flange angle"
   extends Rotational.Interfaces.PartialAbsoluteSensor;

  // components of AngleSensor
   Modelica.Blocks.Interfaces.RealOutput phi "Absolute angle of flange" annotation(Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));

  // algorithms and equations of AngleSensor
  equation
   phi = flange.phi;

  annotation(Documentation(info="<html>
<p>
Measures the <b>absolute angle phi</b> of a flange in an ideal
way and provides the result as output signal <b>phi</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{70,-30},{120,-70}},lineColor={0,0,0},textString="phi")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end AngleSensor;

  model SpeedSensor
   "Ideal sensor to measure the absolute flange angular velocity"
   extends Rotational.Interfaces.PartialAbsoluteSensor;

  // components of SpeedSensor
   Modelica.Blocks.Interfaces.RealOutput w "Absolute angular velocity of flange" annotation(Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));

  // algorithms and equations of SpeedSensor
  equation
   w = der(flange.phi);

  annotation(Documentation(info="<html>
<p>
Measures the <b>absolute angular velocity w</b> of a flange in an ideal
way and provides the result as output signal <b>w</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{70,-30},{120,-70}},lineColor={0,0,0},textString="w")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end SpeedSensor;

  model AccSensor
   "Ideal sensor to measure the absolute flange angular acceleration"
   extends Rotational.Interfaces.PartialAbsoluteSensor;

  // components of AccSensor
   SI.AngularVelocity w "Absolute angular velocity of flange";
   Modelica.Blocks.Interfaces.RealOutput a "Absolute angular acceleration of flange" annotation(Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));

  // algorithms and equations of AccSensor
  equation
   w = der(flange.phi);
   a = der(w);

  annotation(Documentation(info="<html>
<p>
Measures the <b>absolute angular acceleration a</b> of a flange in an ideal
way and provides the result as output signal <b>a</b> (to be further processed with
blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{70,-30},{120,-70}},lineColor={0,0,0},textString="a")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end AccSensor;

  model RelAngleSensor
   "Ideal sensor to measure the relative angle between two flanges"

  // locally defined classes in RelAngleSensor
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of RelAngleSensor
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.Blocks.Interfaces.RealOutput phi_rel "Relative angle between two flanges (= flange_b.phi - flange_a.phi)" annotation(Placement(transformation(origin={0,-110},extent={{10,-10},{-10,10}},rotation=90)));

  // algorithms and equations of RelAngleSensor
  equation
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   0 = _famefault_flange_a.port_b.tau;
   0 = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Measures the <b>relative angle phi_rel</b> between two flanges
in an ideal way and provides the result as output signal <b>phi_rel</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{20,-84},{160,-114}},lineColor={0,0,0},textString="phi_rel"),Line(points={{0,-100},{0,-70}},color={0,0,127})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end RelAngleSensor;

  model RelSpeedSensor
   "Ideal sensor to measure the relative angular velocity between two flanges"

  // locally defined classes in RelSpeedSensor
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of RelSpeedSensor
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.SIunits.Angle phi_rel "Relative angle between two flanges (flange_b.phi - flange_a.phi)";
   Modelica.Blocks.Interfaces.RealOutput w_rel "Relative angular velocity between two flanges (= der(flange_b.phi) - der(flange_a.phi))" annotation(Placement(transformation(origin={0,-110},extent={{10,-10},{-10,10}},rotation=90)));

  // algorithms and equations of RelSpeedSensor
  equation
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   0 = _famefault_flange_a.port_b.tau;
   0 = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Measures the <b>relative angular velocity w_rel</b> between two flanges
in an ideal way and provides the result as output signal <b>w_rel</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{20,-88},{160,-118}},lineColor={0,0,0},textString="w_rel"),Line(points={{0,-100},{0,-70}},color={0,0,127})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end RelSpeedSensor;

  model RelAccSensor
   "Ideal sensor to measure the relative angular acceleration between two flanges"

  // locally defined classes in RelAccSensor
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of RelAccSensor
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.SIunits.Angle phi_rel "Relative angle between two flanges (flange_b.phi - flange_a.phi)";
   Modelica.SIunits.AngularVelocity w_rel "Relative angular velocity between two flanges";
   Modelica.Blocks.Interfaces.RealOutput a_rel "Relative angular acceleration between two flanges" annotation(Placement(transformation(origin={0,-110},extent={{10,-10},{-10,10}},rotation=90)));

  // algorithms and equations of RelAccSensor
  equation
   phi_rel = _famefault_flange_b.port_b.phi-_famefault_flange_a.port_b.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   0 = _famefault_flange_a.port_b.tau;
   0 = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Measures the <b>relative angular acceleration a_rel</b> between two flanges
in an ideal way and provides the result as output signal <b>a_rel</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{20,-86},{160,-116}},lineColor={0,0,0},textString="a_rel"),Line(points={{0,-100},{0,-70}},color={0,0,127})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end RelAccSensor;

  model TorqueSensor
   "Ideal sensor to measure the torque between two flanges (= flange_a.tau)"

  // locally defined classes in TorqueSensor
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of TorqueSensor
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.Blocks.Interfaces.RealOutput tau "Torque in flange flange_a and flange_b (tau = flange_a.tau = -flange_b.tau)" annotation(Placement(transformation(origin={-80,-110},extent={{10,-10},{-10,10}},rotation=90)));

  // algorithms and equations of TorqueSensor
  equation
   _famefault_flange_a.port_b.phi = _famefault_flange_b.port_b.phi;
   _famefault_flange_a.port_b.tau = tau;
   0 = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Measures the <b>cut-torque between two flanges</b> in an ideal way
and provides the result as output signal <b>tau</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-50,-80},{50,-120}},lineColor={0,0,0},textString="tau"),Line(points={{-80,-100},{-80,0}},color={0,0,127})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end TorqueSensor;

  model PowerSensor
   "Ideal sensor to measure the power between two flanges (= flange_a.tau*der(flange_a.phi))"

  // locally defined classes in PowerSensor
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of PowerSensor
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.Blocks.Interfaces.RealOutput power "Power in flange flange_a" annotation(Placement(transformation(origin={-80,-110},extent={{10,-10},{-10,10}},rotation=90)));

  // algorithms and equations of PowerSensor
  equation
   _famefault_flange_a.port_b.phi = _famefault_flange_b.port_b.phi;
   power = _famefault_flange_a.port_b.tau*der(_famefault_flange_a.port_b.phi);
   0 = _famefault_flange_a.port_b.tau+_famefault_flange_b.port_b.tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<html>
<p>
Measures the <b>power between two flanges</b> in an ideal way
and provides the result as output signal <b>power</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>
</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-50,-80},{100,-120}},lineColor={0,0,0},textString="power"),Line(points={{-80,-100},{-80,0}},color={0,0,127})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end PowerSensor;

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Documentation(info="<html>
<p>
This package contains ideal sensor components that provide
the connector variables as signals for further processing with the
Modelica.Blocks library.
</p>
</html>"));
 end Sensors;

 package Sources
  "Sources to drive 1D rotational mechanical components"
  extends Modelica.Icons.SourcesPackage;

  model Position
   "Forced movement of a flange according to a reference angle signal"

   import SI = Modelica.SIunits;

  // locally defined classes in Position
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Position
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.Frequency f_crit=50 "if exact=false, critical frequency of filter to filter input signal" annotation(Dialog(enable=not exact));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   Modelica.SIunits.AngularAcceleration a(start=0) "If exact=false, Angular acceleration of flange with respect to support else dummy";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   Modelica.SIunits.AngularVelocity w(start=0,stateSelect=(if exact then StateSelect.default else StateSelect.prefer)) "If exact=false, Angular velocity of flange with respect to support else dummy";
   parameter Boolean exact=false "true/false exact treatment/filtering the input signal";
   Modelica.Blocks.Interfaces.RealInput phi_ref(final quantity="Angle",final unit="rad",displayUnit="deg") "Reference angle of flange with respect to support as input signal" annotation(Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
   Modelica.SIunits.Angle phi(stateSelect=(if exact then StateSelect.default else StateSelect.prefer)) "Rotation angle of flange with respect to support";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
   constant Real bf=0.6180 "s*s coefficient of Bessel filter";
   parameter Modelica.SIunits.AngularFrequency w_crit=2*Modelica.Constants.pi*f_crit "Critical frequency";
   constant Real af=1.3617 "s coefficient of Bessel filter";

  // algorithms and equations of Position
  initial equation
   if not exact then
    phi = phi_ref;
   end if;
  equation
   phi = _famefault_flange.port_b.phi-phi_support;
   if exact then
    phi = phi_ref;
    w = 0;
    a = 0;
   else
    w = der(phi);
    a = der(w);
    a = ((phi_ref-phi)*w_crit-af*w)*w_crit/(bf);
   end if;
   if not useSupport then
    phi_support = 0;
   end if;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Documentation(info="<HTML>
<p>
The input signal <b>phi_ref</b> defines the <b>reference
angle</b> in [rad]. Flange <b>flange</b> is <b>forced</b>
to move according to this reference motion relative to flange support. According to parameter
<b>exact</b> (default = <b>false</b>), this is done in the following way:
<ol>
<li><b>exact=true</b><br>
    The reference angle is treated <b>exactly</b>. This is only possible, if
    the input signal is defined by an analytical function which can be
    differentiated at least twice. If this prerequisite is fulfilled,
    the Modelica translator will differentiate the input signal twice
    in order to compute the reference acceleration of the flange.</li>
<li><b>exact=false</b><br>
    The reference angle is <b>filtered</b> and the second derivative
    of the filtered curve is used to compute the reference acceleration
    of the flange. This second derivative is <b>not</b> computed by
    numerical differentiation but by an appropriate realization of the
    filter. For filtering, a second order Bessel filter is used.
    The critical frequency (also called cut-off frequency) of the
    filter is defined via parameter <b>f_crit</b> in [Hz]. This value
    should be selected in such a way that it is higher as the essential
    low frequencies in the signal.</li>
</ol>
<p>
The input signal can be provided from one of the signal generator
blocks of the block library Modelica.Blocks.Sources.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Rectangle(extent={{-100,20},{100,-20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-30,-32},{30,-32}},color={0,0,0}),Line(points={{0,52},{0,32}},color={0,0,0}),Line(points={{-29,32},{30,32}},color={0,0,0}),Line(points={{0,-32},{0,-100}},color={0,0,0}),Line(points={{30,-42},{20,-52}},color={0,0,0}),Line(points={{30,-32},{10,-52}},color={0,0,0}),Line(points={{20,-32},{0,-52}},color={0,0,0}),Line(points={{10,-32},{-10,-52}},color={0,0,0}),Line(points={{0,-32},{-20,-52}},color={0,0,0}),Line(points={{-10,-32},{-30,-52}},color={0,0,0}),Line(points={{-20,-32},{-30,-42}},color={0,0,0}),Text(extent={{-56,-56},{-172,-90}},lineColor={0,0,0},textString="phi_ref"),Text(extent={{150,60},{-150,100}},textString="%name",lineColor={0,0,255}),Text(extent={{146,-28},{30,-62}},lineColor={0,0,0},textString="exact="),Text(extent={{146,-64},{30,-98}},lineColor={0,0,0},textString="%exact")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end Position;

  model Speed
   "Forced movement of a flange according to a reference angular velocity signal"

   import SI = Modelica.SIunits;

  // locally defined classes in Speed
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Speed
   Modelica.Blocks.Interfaces.RealInput w_ref "Reference angular velocity of flange with respect to support as input signal" annotation(Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
   Modelica.SIunits.AngularVelocity w(stateSelect=(if exact then StateSelect.default else StateSelect.prefer)) "Angular velocity of flange with respect to support";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.Frequency f_crit=50 "if exact=false, critical frequency of filter to filter input signal";
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   Modelica.SIunits.AngularAcceleration a "If exact=false, angular acceleration of flange with respect to support else dummy";
   parameter Boolean exact=false "true/false exact treatment/filtering the input signal";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   Modelica.SIunits.Angle phi(start=0,fixed=true,stateSelect=StateSelect.prefer) "Rotation angle of flange with respect to support";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
   parameter Modelica.SIunits.AngularFrequency w_crit=2*Modelica.Constants.pi*f_crit "Critical frequency";

  // algorithms and equations of Speed
  initial equation
   if not exact then
    w = w_ref;
   end if;
  equation
   phi = _famefault_flange.port_b.phi-phi_support;
   w = der(phi);
   if exact then
    w = w_ref;
    a = 0;
   else
    a = der(w);
    a = (w_ref-w)*w_crit;
   end if;
   if not useSupport then
    phi_support = 0;
   end if;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Documentation(info="<html>
<p>
The input signal <b>w_ref</b> defines the <b>reference
speed</b> in [rad/s]. Flange <b>flange</b> is <b>forced</b>
to move relative to flange support according to this reference motion. According to parameter
<b>exact</b> (default = <b>false</b>), this is done in the following way:
<ol>
<li><b>exact=true</b><br>
    The reference speed is treated <b>exactly</b>. This is only possible, if
    the input signal is defined by an analytical function which can be
    differentiated at least once. If this prerequisite is fulfilled,
    the Modelica translator will differentiate the input signal once
    in order to compute the reference acceleration of the flange.</li>
<li><b>exact=false</b><br>
    The reference angle is <b>filtered</b> and the second derivative
    of the filtered curve is used to compute the reference acceleration
    of the flange. This second derivative is <b>not</b> computed by
    numerical differentiation but by an appropriate realization of the
    filter. For filtering, a first order filter is used.
    The critical frequency (also called cut-off frequency) of the
    filter is defined via parameter <b>f_crit</b> in [Hz]. This value
    should be selected in such a way that it is higher as the essential
    low frequencies in the signal.</li>
</ol>
<p>
The input signal can be provided from one of the signal generator
blocks of the block library Modelica.Blocks.Sources.
</p>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Rectangle(extent={{-100,20},{100,-20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-30,-32},{30,-32}},color={0,0,0}),Line(points={{0,52},{0,32}},color={0,0,0}),Line(points={{-29,32},{30,32}},color={0,0,0}),Line(points={{0,-32},{0,-100}},color={0,0,0}),Line(points={{-10,-32},{-30,-52}},color={0,0,0}),Line(points={{0,-32},{-20,-52}},color={0,0,0}),Line(points={{10,-32},{-10,-52}},color={0,0,0}),Line(points={{20,-32},{0,-52}},color={0,0,0}),Line(points={{-20,-32},{-30,-42}},color={0,0,0}),Line(points={{30,-32},{10,-52}},color={0,0,0}),Line(points={{30,-42},{20,-52}},color={0,0,0}),Text(extent={{-54,-44},{-158,-78}},lineColor={0,0,0},textString="w_ref"),Text(extent={{0,120},{0,60}},textString="%name",lineColor={0,0,255}),Text(extent={{146,-26},{30,-60}},lineColor={0,0,0},textString="exact="),Text(extent={{146,-62},{30,-96}},lineColor={0,0,0},textString="%exact")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end Speed;

  model Accelerate
   "Forced movement of a flange according to an acceleration signal"

   import SI = Modelica.SIunits;

  // locally defined classes in Accelerate
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Accelerate
   Modelica.SIunits.AngularVelocity w(start=0,fixed=true,stateSelect=StateSelect.prefer) "Angular velocity of flange with respect to support";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Blocks.Interfaces.RealInput a_ref "Absolute angular acceleration of flange with respect to support as input signal" annotation(Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   Modelica.SIunits.AngularAcceleration a "Angular acceleration of flange with respect to support";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   Modelica.SIunits.Angle phi(start=0,fixed=true,stateSelect=StateSelect.prefer) "Rotation angle of flange with respect to support";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of Accelerate
  equation
   phi = _famefault_flange.port_b.phi-phi_support;
   w = der(phi);
   a = der(w);
   a = a_ref;
   if not useSupport then
    phi_support = 0;
   end if;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Documentation(info="<html>
<p>
The input signal <b>a</b> defines an <b>angular acceleration</b>
in [rad/s2]. Flange <b>flange</b> is <b>forced</b> to move relative to flange support with
this acceleration. The angular velocity <b>w</b> and the rotation angle
<b>phi</b> of the flange are automatically determined by integration of
the acceleration.
</p>
<p>
The input signal can be provided from one of the signal generator
blocks of the block library Modelica.Blocks.Sources.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Rectangle(extent={{-100,20},{100,-20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-30,-32},{30,-32}},color={0,0,0}),Line(points={{0,52},{0,32}},color={0,0,0}),Line(points={{-29,32},{30,32}},color={0,0,0}),Line(points={{0,-32},{0,-100}},color={0,0,0}),Line(points={{30,-42},{20,-52}},color={0,0,0}),Line(points={{30,-32},{10,-52}},color={0,0,0}),Line(points={{20,-32},{0,-52}},color={0,0,0}),Line(points={{10,-32},{-10,-52}},color={0,0,0}),Line(points={{0,-32},{-20,-52}},color={0,0,0}),Line(points={{-10,-32},{-30,-52}},color={0,0,0}),Line(points={{-20,-32},{-30,-42}},color={0,0,0}),Text(extent={{-46,-50},{-144,-86}},lineColor={0,0,0},textString="a_ref"),Text(extent={{-150,100},{150,60}},textString="%name",lineColor={0,0,255})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end Accelerate;

  model Move
   "Forced movement of a flange according to an angle, speed and angular acceleration signal"

   import SI = Modelica.SIunits;

  // locally defined classes in Move
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Move
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Blocks.Interfaces.RealInput u[3] "Angle, angular velocity and angular acceleration of flange with respect to support as input signals" annotation(Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   Modelica.SIunits.Angle phi "Rotation angle of flange with respect to support";
  protected

   function position

   // components of position
    input Real q_qd_qdd[3] "Required values for position, speed, acceleration";
    input Real dummy "Just to have one input signal that should be differentiated to avoid possible problems in the Modelica tool (is not used)";
    output Real q;

   // algorithms and equations of position
   algorithm
      q:=q_qd_qdd[1];

   annotation(derivative(noDerivative=q_qd_qdd)=position_der,__Dymola_InlineAfterIndexReduction=true);
   end position;

   function position_der

   // components of position_der
    input Real q_qd_qdd[3] "Required values for position, speed, acceleration";
    input Real dummy "Just to have one input signal that should be differentiated to avoid possible problems in the Modelica tool (is not used)";
    input Real dummy_der;
    output Real qd;

   // algorithms and equations of position_der
   algorithm
      qd:=q_qd_qdd[2];

   annotation(derivative(noDerivative=q_qd_qdd)=position_der2,__Dymola_InlineAfterIndexReduction=true);
   end position_der;

   function position_der2

   // components of position_der2
    input Real q_qd_qdd[3] "Required values for position, speed, acceleration";
    input Real dummy "Just to have one input signal that should be differentiated to avoid possible problems in the Modelica tool (is not used)";
    input Real dummy_der;
    input Real dummy_der2;
    output Real qdd;

   // algorithms and equations of position_der2
   algorithm
      qdd:=q_qd_qdd[3];
   end position_der2;
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of Move
  equation
   phi = _famefault_flange.port_b.phi-phi_support;
   phi = position(u,time);
   if not useSupport then
    phi_support = 0;
   end if;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Documentation(info="<html>
<p>
Flange <b>flange</b> is <b>forced</b> to move relative to flange support with a predefined motion
according to the input signals:
</p>
<pre>
    u[1]: angle of flange
    u[2]: angular velocity of flange
    u[3]: angular acceleration of flange
</pre>
<p>
The user has to guarantee that the input signals are consistent to each other,
i.e., that u[2] is the derivative of u[1] and that
u[3] is the derivative of u[2]. There are, however,
also applications where by purpose these conditions do not hold. For example,
if only the position dependent terms of a mechanical system shall be
calculated, one may provide angle = angle(t) and set the angular velocity
and the angular acceleration to zero.
</p>
<p>
The input signals can be provided from one of the signal generator
blocks of the block library Modelica.Blocks.Sources.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{-80,-60},{-80,-100}},lineColor={0,0,0},textString="phi,w,a"),Rectangle(extent={{-100,20},{100,-20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-30,-32},{30,-32}},color={0,0,0}),Line(points={{0,52},{0,32}},color={0,0,0}),Line(points={{-29,32},{30,32}},color={0,0,0}),Line(points={{0,-32},{0,-100}},color={0,0,0}),Line(points={{30,-42},{20,-52}},color={0,0,0}),Line(points={{30,-32},{10,-52}},color={0,0,0}),Line(points={{20,-32},{0,-52}},color={0,0,0}),Line(points={{10,-32},{-10,-52}},color={0,0,0}),Line(points={{0,-32},{-20,-52}},color={0,0,0}),Line(points={{-10,-32},{-30,-52}},color={0,0,0}),Line(points={{-20,-32},{-30,-42}},color={0,0,0}),Text(extent={{-150,100},{150,60}},textString="%name",lineColor={0,0,255})}));
  end Move;

  model Torque
   "Input signal acting as external torque on a flange"

  // locally defined classes in Torque
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Torque
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   Modelica.Blocks.Interfaces.RealInput tau "Accelerating torque acting at flange (= -flange.tau)" annotation(Placement(transformation(extent={{-140,-20},{-100,20}},rotation=0)));
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of Torque
  equation
   _famefault_flange.port_b.tau = -tau;
   if not useSupport then
    phi_support = 0;
   end if;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Documentation(info="<HTML>
<p>
The input signal <b>tau</b> defines an external
torque in [Nm] which acts (with negative sign) at
a flange connector, i.e., the component connected to this
flange is driven by torque <b>tau</b>.</p>
<p>
The input signal can be provided from one of the signal generator
blocks of Modelica.Blocks.Sources.
</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,110},{150,70}},textString="%name",lineColor={0,0,255}),Text(extent={{-62,-29},{-141,-70}},lineColor={0,0,0},textString="tau"),Line(points={{-88,0},{-64,30},{-36,52},{-2,62},{28,56},{48,44},{64,28},{76,14},{86,0}},color={0,0,0},thickness=0.5),Polygon(points={{86,0},{66,58},{37,27},{86,0}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{-30,-30},{30,-30}},color={0,0,0}),Line(points={{0,-30},{0,-101}},color={0,0,0}),Line(points={{-30,-50},{-10,-30}},color={0,0,0}),Line(points={{-10,-50},{10,-30}},color={0,0,0}),Line(points={{10,-50},{30,-30}},color={0,0,0}),Line(points={{-54,-42},{-38,-28},{-16,-16},{4,-14},{22,-18},{36,-26},{48,-36},{56,-46},{64,-58}},color={0,0,0}),Polygon(points={{-61,-66},{-44,-42},{-58,-36},{-61,-66}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{14,86},{82,73}},lineColor={128,128,128},textString="rotation axis"),Polygon(points={{10,80},{-10,85},{-10,75},{10,80}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Line(points={{-80,80},{-9,80}},color={128,128,128}),Line(points={{-88,0},{-64,30},{-36,52},{-2,62},{28,56},{48,44},{64,28},{76,14},{80,10}},color={0,0,0},thickness=0.5),Polygon(points={{86,0},{66,58},{38,28},{86,0}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}));
  end Torque;

  model Torque2
   "Input signal acting as torque on two flanges"

  // locally defined classes in Torque2
      model _famefaults_flange_a = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange_b = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of Torque2
   Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_a(amount=0.0);
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange_b(amount=0.0);
   Modelica.Blocks.Interfaces.RealInput tau "Torque driving the two flanges (a positive value accelerates the flange)" annotation(Placement(transformation(origin={0,40},extent={{-20,-20},{20,20}},rotation=270)));

  // algorithms and equations of Torque2
  equation
   _famefault_flange_a.port_b.tau = tau;
   _famefault_flange_b.port_b.tau = -tau;
   connect(flange_a,_famefault_flange_a.port_a);
   connect(flange_b,_famefault_flange_b.port_a);

  annotation(Documentation(info="<HTML>
<p>
The input signal <b>tau</b> defines an external
torque in [Nm] which acts at both flange connectors,
i.e., the components connected to these flanges are driven by torque <b>tau</b>.</p>
<p>The input signal can be provided from one of the signal generator
blocks of Modelica.Blocks.Sources.</p>

</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,-40},{150,-80}},textString="%name",lineColor={0,0,255}),Polygon(points={{-78,24},{-69,17},{-89,0},{-78,24}},lineColor={0,0,0},lineThickness=0.5,fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{-74,20},{-70,23},{-65,26},{-60,28},{-56,29},{-50,30},{-41,30},{-35,29},{-31,28},{-26,26},{-21,23},{-17,20},{-13,15},{-10,9}},color={0,0,0},thickness=0.5),Line(points={{74,20},{70,23},{65,26},{60,28},{56,29},{50,30},{41,30},{35,29},{31,28},{26,26},{21,23},{17,20},{13,15},{10,9}},color={0,0,0},thickness=0.5),Polygon(points={{89,0},{78,24},{69,17},{89,0}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{15,-71},{83,-84}},lineColor={128,128,128},textString="rotation axis"),Polygon(points={{11,-77},{-9,-72},{-9,-82},{11,-77}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Line(points={{-79,-77},{-8,-77}},color={128,128,128}),Line(points={{-75,20},{-71,23},{-66,26},{-61,28},{-57,29},{-51,30},{-42,30},{-36,29},{-32,28},{-27,26},{-22,23},{-18,20},{-14,15},{-11,9}},color={0,0,0},thickness=0.5),Polygon(points={{-79,24},{-70,17},{-90,0},{-79,24}},lineColor={0,0,0},lineThickness=0.5,fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{73,20},{69,23},{64,26},{59,28},{55,29},{49,30},{40,30},{34,29},{30,28},{25,26},{20,23},{16,20},{12,15},{9,9}},color={0,0,0},thickness=0.5),Polygon(points={{88,0},{77,24},{68,17},{88,0}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}));
  end Torque2;

  model LinearSpeedDependentTorque
   "Linear dependency of torque versus speed"

  // locally defined classes in LinearSpeedDependentTorque
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of LinearSpeedDependentTorque
   Modelica.SIunits.AngularVelocity w "Angular velocity of flange with respect to support (= der(phi))";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.Torque tau_nominal "Nominal torque (if negative, torque is acting as load)";
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   parameter Modelica.SIunits.AngularVelocity w_nominal(min=Modelica.Constants.eps) "Nominal speed";
   Modelica.SIunits.Torque tau "Accelerating torque acting at flange (= -flange.tau)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   parameter Boolean TorqueDirection=true "Same direction of torque in both directions of rotation";
   Modelica.SIunits.Angle phi "Angle of flange with respect to support (= flange.phi - support.phi)";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of LinearSpeedDependentTorque
  equation
   w = der(phi);
   tau = -_famefault_flange.port_b.tau;
   if TorqueDirection then
    tau = tau_nominal*abs(w/(w_nominal));
   else
    tau = tau_nominal*w/(w_nominal);
   end if;
   if not useSupport then
    phi_support = 0;
   end if;
   phi = _famefault_flange.port_b.phi-phi_support;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{-100,-100},{100,100}},color={0,0,255})}),Documentation(info="<HTML>
<p>
Model of torque, linearly dependent on angular velocity of flange.<br>
Parameter TorqueDirection chooses whether direction of torque is the same in both directions of rotation or not.
</p>
</HTML>"));
  end LinearSpeedDependentTorque;

  model QuadraticSpeedDependentTorque
   "Quadratic dependency of torque versus speed"

  // locally defined classes in QuadraticSpeedDependentTorque
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of QuadraticSpeedDependentTorque
   Modelica.SIunits.AngularVelocity w "Angular velocity of flange with respect to support (= der(phi))";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Modelica.SIunits.Torque tau_nominal "Nominal torque (if negative, torque is acting as load)";
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   parameter Modelica.SIunits.AngularVelocity w_nominal(min=Modelica.Constants.eps) "Nominal speed";
   Modelica.SIunits.Torque tau "Accelerating torque acting at flange (= -flange.tau)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   parameter Boolean TorqueDirection=true "Same direction of torque in both directions of rotation";
   Modelica.SIunits.Angle phi "Angle of flange with respect to support (= flange.phi - support.phi)";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of QuadraticSpeedDependentTorque
  equation
   w = der(phi);
   tau = -_famefault_flange.port_b.tau;
   if TorqueDirection then
    tau = tau_nominal*(w/(w_nominal))^(2);
   else
    tau = tau_nominal*smooth(1,(if w>=0 then (w/(w_nominal))^(2) else -(w/(w_nominal))^(2)));
   end if;
   if not useSupport then
    phi_support = 0;
   end if;
   phi = _famefault_flange.port_b.phi-phi_support;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{-100,-100},{-80,-98},{-60,-92},{-40,-82},{-20,-68},{0,-50},{20,-28},{40,-2},{60,28},{80,62},{100,100}},color={0,0,255})}),Documentation(info="<HTML>
<p>
Model of torque, quadratic dependent on angular velocity of flange.<br>
Parameter TorqueDirection chooses whether direction of torque is the same in both directions of rotation or not.
</p>
</HTML>"));
  end QuadraticSpeedDependentTorque;

  model ConstantTorque
   "Constant torque, not dependent on speed"

  // locally defined classes in ConstantTorque
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of ConstantTorque
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   Modelica.SIunits.Torque tau "Accelerating torque acting at flange (= -flange.tau)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   parameter Modelica.SIunits.Torque tau_constant "Constant torque (if negative, torque is acting as load)";
   Modelica.SIunits.Angle phi "Angle of flange with respect to support (= flange.phi - support.phi)";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of ConstantTorque
  equation
   tau = -_famefault_flange.port_b.tau;
   tau = tau_constant;
   if not useSupport then
    phi_support = 0;
   end if;
   phi = _famefault_flange.port_b.phi-phi_support;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{-98,0},{100,0}},color={0,0,255}),Text(extent={{-124,-16},{120,-40}},lineColor={0,0,0},textString="%tau_constant")}),Documentation(info="<HTML>
<p>
Model of constant torque, not dependent on angular velocity of flange.<br>
Positive torque acts accelerating.
</p>
</HTML>"));
  end ConstantTorque;

  model ConstantSpeed
   "Constant speed, not dependent on torque"

  // locally defined classes in ConstantSpeed
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of ConstantSpeed
   Modelica.SIunits.AngularVelocity w "Angular velocity of flange with respect to support (= der(phi))";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   parameter Modelica.SIunits.AngularVelocity w_fixed "Fixed speed";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   Modelica.SIunits.Angle phi "Angle of flange with respect to support (= flange.phi - support.phi)";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of ConstantSpeed
  equation
   w = der(phi);
   w = w_fixed;
   if not useSupport then
    phi_support = 0;
   end if;
   phi = _famefault_flange.port_b.phi-phi_support;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{0,-100},{0,100}},color={0,0,255}),Text(extent={{-116,-16},{128,-40}},lineColor={0,0,0},textString="%w_fixed")}),Documentation(info="<HTML>
<p>
Model of <b>fixed</b> angular verlocity of flange, not dependent on torque.
</p>
</HTML>"));
  end ConstantSpeed;

  model TorqueStep
   "Constant torque, not dependent on speed"

  // locally defined classes in TorqueStep
      model _famefaults_support = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_flange = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of TorqueStep
   parameter Modelica.SIunits.Time startTime=0 "Torque = offset for time < startTime";
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Modelica.Mechanics.Rotational.Interfaces.Support support() if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_support(amount=0.0,port_b(phi=phi_support,tau=-flange.tau)) if useSupport;
   parameter Modelica.SIunits.Torque offsetTorque(start=0) "Offset of torque";
   Modelica.SIunits.Torque tau "Accelerating torque acting at flange (= -flange.tau)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_flange(amount=0.0);
   parameter Modelica.SIunits.Torque stepTorque(start=1) "Height of torque step (if negative, torque is acting as load)";
   Modelica.SIunits.Angle phi "Angle of flange with respect to support (= flange.phi - support.phi)";
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of TorqueStep
  equation
   tau = -_famefault_flange.port_b.tau;
   tau = offsetTorque+(if time<startTime then 0 else stepTorque);
   if not useSupport then
    phi_support = 0;
   end if;
   phi = _famefault_flange.port_b.phi-phi_support;
   connect(support,_famefault_support.port_a);
   connect(flange,_famefault_flange.port_a);

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{-80,-60},{0,-60},{0,60},{80,60}},color={0,0,255}),Text(extent={{0,-40},{100,-60}},lineColor={0,0,255},textString="time")}),Documentation(info="<HTML>
<p>
Model of a torque step at time .<br>
Positive torque acts accelerating.
</p>
</HTML>"));
  end TorqueStep;

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Documentation(info="<html>
<p>
This package contains ideal sources to drive 1D mechanical rotational drive trains.
</p>
</html>"));
 end Sources;

 package Interfaces
  "Connectors and partial models for 1D rotational mechanical components"
  extends Modelica.Icons.InterfacesPackage;

  connector Flange_a
   "1-dim. rotational flange of a shaft (filled square icon)"

  // components of Flange_a
   SI.Angle phi "Absolute rotation angle of flange";
   flow SI.Torque tau "Cut torque in the flange";

  annotation(defaultComponentName="flange_a",Documentation(info="<html>
<p>
This is a connector for 1-dim. rotational mechanical systems and models
the mechanical flange of a shaft. The following variables are defined in this connector:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"> <b>phi</b></td>
      <td valign=\"top\"> Absolute rotation angle of theshaft flange in [rad] </td>
  </tr>
  <tr><td valign=\"top\"> <b>tau</b></td>
      <td valign=\"top\"> Cut-torque in the shaft flange in [Nm] </td>
  </tr>
</table>

<p>
There is a second connector for flanges: Flange_b. The connectors
Flange_a and Flange_b are completely identical. There is only a difference
in the icons, in order to easier identify a flange variable in a diagram.
For a discussion on the actual direction of the cut-torque tau and
of the rotation angle, see section
<a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide.SignConventions\">Sign Conventions</a>
in the user's guide of Rotational.
</p>

<p>
If needed, the absolute angular velocity w and the
absolute angular acceleration a of the flange can be determined by
differentiation of the flange angle phi:
</p>
<pre>
     w = der(phi);    a = der(w)
</pre>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Ellipse(extent={{-100,100},{100,-100}},lineColor={0,0,0},fillColor={95,95,95},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{-160,90},{40,50}},lineColor={0,0,0},textString="%name"),Ellipse(extent={{-40,40},{40,-40}},lineColor={0,0,0},fillColor={135,135,135},fillPattern=FillPattern.Solid)}));
  end Flange_a;

  connector Flange_b
   "1-dim. rotational flange of a shaft (non-filled square icon)"

  // components of Flange_b
   SI.Angle phi "Absolute rotation angle of flange";
   flow SI.Torque tau "Cut torque in the flange";

  annotation(defaultComponentName="flange_b",Documentation(info="<html>
<p>
This is a connector for 1-dim. rotational mechanical systems and models
the mechanical flange of a shaft. The following variables are defined in this connector:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"> <b>phi</b></td>
      <td valign=\"top\"> Absolute rotation angle of the shaft flange in [rad] </td>
  </tr>
  <tr><td valign=\"top\"> <b>tau</b></td>
      <td valign=\"top\"> Cut-torque in the shaft flange in [Nm] </td>
  </tr>
</table>

<p>
There is a second connector for flanges: Flange_a. The connectors
Flange_a and Flange_b are completely identical. There is only a difference
in the icons, in order to easier identify a flange variable in a diagram.
For a discussion on the actual direction of the cut-torque tau and
of the rotation angle, see section
<a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide.SignConventions\">Sign Conventions</a>
in the user's guide of Rotational.
</p>

<p>
If needed, the absolute angular velocity w and the
absolute angular acceleration a of the flange can be determined by
differentiation of the flange angle phi:
</p>
<pre>
     w = der(phi);    a = der(w)
</pre>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Ellipse(extent={{-98,100},{102,-100}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Ellipse(extent={{-40,40},{40,-40}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-40,90},{160,50}},lineColor={0,0,0},textString="%name")}));
  end Flange_b;

  connector Support
   "Support/housing of a 1-dim. rotational shaft"

  // components of Support
   SI.Angle phi "Absolute rotation angle of the support/housing";
   flow SI.Torque tau "Reaction torque in the support/housing";

  annotation(Documentation(info="<html>
<p>
This is a connector for 1-dim. rotational mechanical systems and models
the support or housing of a shaft. The following variables are defined in this connector:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"> <b>phi</b></td>
      <td valign=\"top\"> Absolute rotation angle of the support/housing in [rad] </td>
  </tr>
  <tr><td valign=\"top\"> <b>tau</b></td>
      <td valign=\"top\"> Reaction torque in the support/housing in [Nm] </td>
  </tr>
</table>

<p>
The support connector is usually defined as conditional connector.
It is most convenient to utilize it
</p>

<ul>
<li> For models to be build graphically (i.e., the model is build up by drag-and-drop
     from elementary components):<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport\">PartialOneFlangeAndSupport</a>,<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlangesAndSupport\">PartialTwoFlangesAndSupport</a>, <br> &nbsp; </li>

<li> For models to be build textually (i.e., elementary models):<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport\">PartialElementaryOneFlangeAndSupport</a>,<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport\">PartialElementaryTwoFlangesAndSupport</a>,<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryRotationalToTranslational\">PartialElementaryRotationalToTranslational</a>.</li>
</ul>

</html>"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2},initialScale=0.1),graphics={Ellipse(extent={{-100,100},{100,-100}},lineColor={0,0,0},fillColor={95,95,95},fillPattern=FillPattern.Solid),Rectangle(extent={{-150,150},{150,-150}},lineColor={192,192,192},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-100,100},{100,-100}},lineColor={0,0,0},fillColor={95,95,95},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2},initialScale=0.1),graphics={Rectangle(extent={{-60,60},{60,-60}},lineColor={192,192,192},fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{-160,100},{40,60}},lineColor={0,0,0},textString="%name"),Ellipse(extent={{-40,40},{40,-40}},lineColor={0,0,0},fillColor={135,135,135},fillPattern=FillPattern.Solid)}));
  end Support;

  model InternalSupport
   "Adapter model to utilize conditional support connector"

  // components of InternalSupport
   input Modelica.SIunits.Torque tau "External support torque (must be computed via torque balance in model where InternalSupport is used; = flange.tau)";
   Modelica.SIunits.Angle phi "External support angle (= flange.phi)";
   Flange_a flange "Internal support flange (must be connected to the conditional support connector for useSupport=true and to conditional fixed model for useSupport=false)" annotation(Placement(transformation(extent={{-10,-10},{10,10}})));

  // algorithms and equations of InternalSupport
  equation
   flange.tau = tau;
   flange.phi = phi;

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Ellipse(extent={{-20,20},{20,-20}},lineColor={135,135,135},fillColor={175,175,175},fillPattern=FillPattern.Solid),Text(extent={{-200,80},{200,40}},lineColor={0,0,255},textString="%name")}),Documentation(info="<html>
<p>
This is an adapter model to utilize a conditional support connector
in an elementary component, i.e., where the component equations are
defined textually:
</p>

<ul>
<li> If <i>useSupport = true</i>, the flange has to be connected to the conditional
     support connector.</li>
<li> If <i>useSupport = false</i>, the flange has to be connected to the conditional
     fixed model.</li>
</ul>

<p>
Variable <b>tau</b> is defined as <b>input</b> and must be provided when using
this component as a modifier (computed via a torque balance in
the model where InternalSupport is used). Usually, model InternalSupport is
utilized via the partial models:
</p>

<blockquote>
<a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport\">
PartialElementaryOneFlangeAndSupport</a>,<br>
<a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport\">
PartialElementaryTwoFlangesAndSupport</a>,<br>
<a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryRotationalToTranslational\">
PartialElementaryRotationalToTranslational</a>.</li>
</blockquote>

<p>
Note, the support angle can always be accessed as internalSupport.phi, and
the support torque can always be accessed as internalSupport.tau.
</p>

</html>"));
  end InternalSupport;

  partial model PartialTwoFlanges
   "Partial model for a component with two rotational 1-dim. shaft flanges"

  // components of PartialTwoFlanges
   Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with two flanges.
It is used e.g., to build up parts of a drive train consisting
of several components.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end PartialTwoFlanges;

  partial model PartialOneFlangeAndSupport
   "Partial model for a component with one rotational 1-dim. shaft flange and a support used for graphical modeling, i.e., the model is build up by drag-and-drop from elementary components"

  // components of PartialOneFlangeAndSupport
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Support support if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  protected
   Support internalSupport "Internal support/housing of component (either connected to support, if useSupport=true, or connected to fixed, if useSupport=false)" annotation(Placement(transformation(extent={{-3,-83},{3,-77}})));
   Components.Fixed fixed if not useSupport "Fixed support/housing, if not useSupport" annotation(Placement(transformation(extent={{10,-94},{30,-74}})));

  // algorithms and equations of PartialOneFlangeAndSupport
  equation
   connect(support,internalSupport) annotation(Line(points={{0,-100},{0,-80}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupport,fixed.flange) annotation(Line(points={{0,-80},{20,-80},{20,-84}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with one flange and a support/housing.
It is used e.g., to build up parts of a drive train graphically consisting
of several components.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{-38,-98},{-6,-96}},lineColor={95,95,95},textString="(if useSupport)"),Text(extent={{21,-95},{61,-96}},lineColor={95,95,95},textString="(if not useSupport)")}),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}));
  end PartialOneFlangeAndSupport;

  partial model PartialTwoFlangesAndSupport
   "Partial model for a component with two rotational 1-dim. shaft flanges and a support used for graphical modeling, i.e., the model is build up by drag-and-drop from elementary components"

  // components of PartialTwoFlangesAndSupport
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Support support if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  protected
   Support internalSupport "Internal support/housing of component (either connected to support, if useSupport=true, or connected to fixed, if useSupport=false)" annotation(Placement(transformation(extent={{-3,-83},{3,-77}})));
   Components.Fixed fixed if not useSupport "Fixed support/housing, if not useSupport" annotation(Placement(transformation(extent={{10,-97},{30,-77}})));

  // algorithms and equations of PartialTwoFlangesAndSupport
  equation
   connect(support,internalSupport) annotation(Line(points={{0,-100},{0,-95},{4.4409e-016,-95},{4.4409e-016,-90},{0,-90},{0,-80}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupport,fixed.flange) annotation(Line(points={{0,-80},{20,-80},{20,-87}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with two flanges and a support/housing.
It is used e.g., to build up parts of a drive train graphically consisting
of several components.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{-38,-98},{-6,-96}},lineColor={95,95,95},textString="(if useSupport)"),Text(extent={{24,-97},{64,-98}},lineColor={95,95,95},textString="(if not useSupport)")}),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}));
  end PartialTwoFlangesAndSupport;

  partial model PartialCompliant
   "Partial model for the compliant connection of two rotational 1-dim. shaft flanges"

  // components of PartialCompliant
   Modelica.SIunits.Angle phi_rel(start=0) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
   Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));

  // algorithms and equations of PartialCompliant
  equation
   phi_rel = flange_b.phi-flange_a.phi;
   flange_b.tau = tau;
   flange_a.tau = -tau;

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with a compliant connection of two
rotational 1-dim. flanges where inertial effects between the two
flanges are neglected. The basic assumption is that the cut-torques
of the two flanges sum-up to zero, i.e., they have the same absolute value
but opposite sign: flange_a.tau + flange_b.tau = 0. This base class
is used to built up force elements such as springs, dampers, friction.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end PartialCompliant;

  partial model PartialCompliantWithRelativeStates
   "Partial model for the compliant connection of two rotational 1-dim. shaft flanges where the relative angle and speed are used as preferred states"

  // components of PartialCompliantWithRelativeStates
   Modelica.SIunits.Angle phi_rel(start=0,stateSelect=stateSelect,nominal=phi_nominal) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
   Modelica.SIunits.AngularVelocity w_rel(start=0,stateSelect=stateSelect) "Relative angular velocity (= der(phi_rel))";
   Modelica.SIunits.AngularAcceleration a_rel(start=0) "Relative angular acceleration (= der(w_rel))";
   Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
   Flange_a flange_a "Left flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Right flange of compliant 1-dim. rotational component" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   parameter SI.Angle phi_nominal(displayUnit="rad")=1e-4 "Nominal value of phi_rel (used for scaling)" annotation(Dialog(tab="Advanced"));
   parameter StateSelect stateSelect=StateSelect.prefer "Priority to use phi_rel and w_rel as states" annotation(HideResult=true,Dialog(tab="Advanced"));

  // algorithms and equations of PartialCompliantWithRelativeStates
  equation
   phi_rel = flange_b.phi-flange_a.phi;
   w_rel = der(phi_rel);
   a_rel = der(w_rel);
   flange_b.tau = tau;
   flange_a.tau = -tau;

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with a compliant connection of two
rotational 1-dim. flanges where inertial effects between the two
flanges are neglected. The basic assumption is that the cut-torques
of the two flanges sum-up to zero, i.e., they have the same absolute value
but opposite sign: flange_a.tau + flange_b.tau = 0. This base class
is used to built up force elements such as springs, dampers, friction.
</p>

<p>
The relative angle and the relative speed are defined as preferred states.
The reason is that for some drive trains, such as drive
trains in vehicles, the absolute angle is quickly increasing during operation.
Numerically, it is better to use relative angles between drive train components
because they remain in a limited size. For this reason, StateSelect.prefer
is set for the relative angle of this component.
</p>

<p>
In order to improve the numerics, a nominal value for the relative angle
can be provided via parameter <b>phi_nominal</b> in the Advanced menu.
The default ist 1e-4 rad since relative angles are usually
in this order and the step size control of an integrator would be
practically switched off, if a default of 1 rad would be used.
This nominal value might also be computed from other values, such
as \"phi_nominal = tau_nominal / c\" for a rotational spring, if tau_nominal
and c are more meaningful for the user.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics));
  end PartialCompliantWithRelativeStates;

  partial model PartialElementaryOneFlangeAndSupport
   "Obsolete partial model. Use PartialElementaryOneFlangeAndSupport2."
   extends Modelica.Icons.ObsoleteModel;

  // components of PartialElementaryOneFlangeAndSupport
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Support support if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  protected
   Rotational.Interfaces.InternalSupport internalSupport(tau=-flange.tau) "Internal support/housing of component as a model with connector flange (flange is either connected to support, if useSupport=true, or connected to fixed, if useSupport=false)" annotation(Placement(transformation(extent={{-10,-90},{10,-70}})));
   Rotational.Components.Fixed fixed if not useSupport "Fixed support/housing, if not useSupport" annotation(Placement(transformation(extent={{10,-96},{30,-76}})));

  // algorithms and equations of PartialElementaryOneFlangeAndSupport
  equation
   connect(internalSupport.flange,support) annotation(Line(points={{0,-80},{0,-100}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupport.flange,fixed.flange) annotation(Line(points={{0,-80},{20,-80},{20,-86}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with one flange and a support/housing.
It is used to build up elementary components of a drive train with
equations in the text layer.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{25,-97},{65,-98}},lineColor={95,95,95},textString="(if not useSupport)"),Text(extent={{-38,-98},{-6,-96}},lineColor={95,95,95},textString="(if useSupport)")}),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}));
  end PartialElementaryOneFlangeAndSupport;

  partial model PartialElementaryOneFlangeAndSupport2
   "Partial model for a component with one rotational 1-dim. shaft flange and a support used for textual modeling, i.e., for elementary models"

  // components of PartialElementaryOneFlangeAndSupport2
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Flange_b flange "Flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Support support(phi=phi_support,tau=-flange.tau) if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of PartialElementaryOneFlangeAndSupport2
  equation
   if not useSupport then
    phi_support = 0;
   end if;

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with one flange and a support/housing.
It is used to build up elementary components of a drive train with
equations in the text layer.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}));
  end PartialElementaryOneFlangeAndSupport2;

  partial model PartialElementaryTwoFlangesAndSupport
   "Obsolete partial model. Use PartialElementaryTwoFlangesAndSupport2."
   extends Modelica.Icons.ObsoleteModel;

  // components of PartialElementaryTwoFlangesAndSupport
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Support support if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  protected
   Rotational.Interfaces.InternalSupport internalSupport(tau=-flange_a.tau-flange_b.tau) "Internal support/housing of component as a model with connector flange (flange is either connected to support, if useSupport=true, or connected to fixed, if useSupport=false)" annotation(Placement(transformation(extent={{-10,-90},{10,-70}})));
   Rotational.Components.Fixed fixed if not useSupport "Fixed support/housing, if not useSupport" annotation(Placement(transformation(extent={{10,-97},{30,-77}})));

  // algorithms and equations of PartialElementaryTwoFlangesAndSupport
  equation
   connect(internalSupport.flange,support) annotation(Line(points={{0,-80},{0,-100}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupport.flange,fixed.flange) annotation(Line(points={{0,-80},{20,-80},{20,-87}},color={0,0,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with two flanges and a support/housing.
It is used to build up elementary components of a drive train with
equations in the text layer.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Text(extent={{24,-97},{64,-98}},lineColor={95,95,95},textString="(if not useSupport)"),Text(extent={{-38,-98},{-6,-96}},lineColor={95,95,95},textString="(if useSupport)")}),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}));
  end PartialElementaryTwoFlangesAndSupport;

  partial model PartialElementaryTwoFlangesAndSupport2
   "Partial model for a component with two rotational 1-dim. shaft flanges and a support used for textual modeling, i.e., for elementary models"

  // components of PartialElementaryTwoFlangesAndSupport2
   parameter Boolean useSupport=false "= true, if support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Flange_a flange_a "Flange of left shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Flange of right shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));
   Support support(phi=phi_support,tau=-flange_a.tau-flange_b.tau) if useSupport "Support/housing of component" annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  protected
   Modelica.SIunits.Angle phi_support "Absolute angle of support flange";

  // algorithms and equations of PartialElementaryTwoFlangesAndSupport2
  equation
   if not useSupport then
    phi_support = 0;
   end if;

  annotation(Documentation(info="<html>
<p>
This is a 1-dim. rotational component with two flanges and a support/housing.
It is used to build up elementary components of a drive train with
equations in the text layer.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}));
  end PartialElementaryTwoFlangesAndSupport2;

  partial model PartialElementaryRotationalToTranslational
   "Partial model to transform rotational into translational motion"

  // components of PartialElementaryRotationalToTranslational
   parameter Boolean useSupportR=false "= true, if rotational support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   parameter Boolean useSupportT=false "= true, if translational support flange enabled, otherwise implicitly grounded" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
   Rotational.Interfaces.Flange_a flangeR "Flange of rotational shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Modelica.Mechanics.Translational.Interfaces.Flange_b flangeT "Flange of translational rod" annotation(Placement(transformation(extent={{90,10},{110,-10}},rotation=0)));
   Rotational.Interfaces.Support supportR if useSupportR "Rotational support/housing of component" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}},rotation=0),iconTransformation(extent={{-110,-110},{-90,-90}})));
   Translational.Interfaces.Support supportT if useSupportT "Translational support/housing of component" annotation(Placement(transformation(extent={{110,-110},{90,-90}},rotation=0),iconTransformation(extent={{90,-110},{110,-90}})));
  protected
   Rotational.Interfaces.InternalSupport internalSupportR(tau=-flangeR.tau) annotation(Placement(transformation(extent={{-110,-90},{-90,-70}})));
   Translational.Interfaces.InternalSupport internalSupportT(f=-flangeT.f) annotation(Placement(transformation(extent={{90,-90},{110,-70}})));
   Rotational.Components.Fixed fixedR if not useSupportR annotation(Placement(transformation(extent={{-90,-90},{-70,-70}})));
   Translational.Components.Fixed fixedT if not useSupportT annotation(Placement(transformation(extent={{70,-90},{90,-70}})));

  // algorithms and equations of PartialElementaryRotationalToTranslational
  equation
   connect(internalSupportR.flange,supportR) annotation(Line(points={{-100,-80},{-100,-100}},color={0,0,0},smooth=Smooth.None));
   connect(internalSupportR.flange,fixedR.flange) annotation(Line(points={{-100,-80},{-80,-80}},color={0,0,0},smooth=Smooth.None));
   connect(fixedT.flange,internalSupportT.flange) annotation(Line(points={{80,-80},{100,-80}},color={0,127,0},smooth=Smooth.None));
   connect(internalSupportT.flange,supportT) annotation(Line(points={{100,-80},{100,-100}},color={0,127,0},smooth=Smooth.None));

  annotation(Documentation(info="<html>

<p>
This is a 1-dim. rotational component with
</p>

<ul>
<li> one rotational flange, </li>
<li> one rotational support/housing, </li>
<li> one translational flange, and </li>
<li> one translatinal support/housing </li>
</ul>

<p>
This model is used to build up elementary components of a drive train
transforming rotational into translational motion with
equations in the text layer.
</p>

<p>
If <i>useSupportR=true</i>, the rotational support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupportR=false</i>, the rotational support connector is conditionally disabled
and instead the rotational part is internally fixed to ground.<br>
If <i>useSupportT=true</i>, the translational support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupportT=false</i>, the translational support connector is conditionally disabled
and instead the translational part is internally fixed to ground.
</p>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(visible=not useSupportT,points={{85,-110},{95,-100}},color={0,0,0}),Line(visible=not useSupportT,points={{95,-110},{105,-100}},color={0,0,0}),Line(visible=not useSupportT,points={{105,-110},{115,-100}},color={0,0,0}),Line(visible=not useSupportT,points={{85,-100},{115,-100}},color={0,0,0}),Line(visible=not useSupportR,points={{-115,-110},{-105,-100}},color={0,0,0}),Line(visible=not useSupportR,points={{-105,-110},{-95,-100}},color={0,0,0}),Line(visible=not useSupportR,points={{-95,-110},{-85,-100}},color={0,0,0}),Line(visible=not useSupportR,points={{-115,-100},{-85,-100}},color={0,0,0})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end PartialElementaryRotationalToTranslational;

  partial model PartialTorque
   "Partial model of a torque acting at the flange (accelerates the flange)"
   extends Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport2;

  // components of PartialTorque
   Modelica.SIunits.Angle phi "Angle of flange with respect to support (= flange.phi - support.phi)";

  // algorithms and equations of PartialTorque
  equation
   phi = flange.phi-phi_support;

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-96,96},{96,-96}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{0,-62},{0,-100}},color={0,0,0}),Line(points={{-92,0},{-76,36},{-54,62},{-30,80},{-14,88},{10,92},{26,90},{46,80},{64,62}},color={0,0,0}),Text(extent={{-150,140},{150,100}},lineColor={0,0,255},textString="%name"),Polygon(points={{94,16},{80,74},{50,52},{94,16}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{-58,-82},{-42,-68},{-20,-56},{0,-54},{18,-56},{34,-62},{44,-72},{54,-82},{60,-94}},color={0,0,0}),Polygon(points={{-65,-98},{-46,-80},{-58,-72},{-65,-98}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(visible=not useSupport,points={{-50,-120},{-30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-120},{-10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-10,-120},{10,-100}},color={0,0,0}),Line(visible=not useSupport,points={{10,-120},{30,-100}},color={0,0,0}),Line(visible=not useSupport,points={{-30,-100},{30,-100}},color={0,0,0})}),Documentation(info="<HTML>
<p>
Partial model of torque that accelerates the flange.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>"));
  end PartialTorque;

  partial model PartialAbsoluteSensor
   "Partial model to measure a single absolute flange variable"

  // components of PartialAbsoluteSensor
   Flange_a flange "Flange of shaft from which sensor information shall be measured" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));

  // algorithms and equations of PartialAbsoluteSensor
  equation
   0 = flange.tau;

  annotation(Documentation(info="<html>
<p>
This is a partial model of a 1-dim. rotational component with one flange of a shaft
in order to measure an absolute kinematic quantity in the flange
and to provide the measured signal as output signal for further processing
with the blocks of package Modelica.Blocks.
</p>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-70,0},{-90,0}},color={0,0,0}),Line(points={{70,0},{100,0}},color={0,0,127}),Text(extent={{150,80},{-150,120}},textString="%name",lineColor={0,0,255}),Ellipse(extent={{-70,70},{70,-70}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{0,70},{0,40}},color={0,0,0}),Line(points={{22.9,32.8},{40.2,57.3}},color={0,0,0}),Line(points={{-22.9,32.8},{-40.2,57.3}},color={0,0,0}),Line(points={{37.6,13.7},{65.8,23.9}},color={0,0,0}),Line(points={{-37.6,13.7},{-65.8,23.9}},color={0,0,0}),Line(points={{0,0},{9.02,28.6}},color={0,0,0}),Polygon(points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{-5,5},{5,-5}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end PartialAbsoluteSensor;

  partial model PartialRelativeSensor
   "Partial model to measure a single relative variable between two flanges"

  // components of PartialRelativeSensor
   Flange_a flange_a "Left flange of shaft" annotation(Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
   Flange_b flange_b "Right flange of shaft" annotation(Placement(transformation(extent={{90,-10},{110,10}},rotation=0)));

  // algorithms and equations of PartialRelativeSensor
  equation
   0 = flange_a.tau+flange_b.tau;

  annotation(Documentation(info="<html>
<p>
This is a partial model for 1-dim. rotational components with two rigidly connected
flanges in order to measure relative kinematic quantities
between the two flanges or the cut-torque in the flange and
to provide the measured signal as output signal for further processing
with the blocks of package Modelica.Blocks.
</p>

</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-70,0},{-90,0}},color={0,0,0}),Line(points={{70,0},{90,0}},color={0,0,0}),Text(extent={{-150,73},{150,113}},textString="%name",lineColor={0,0,255}),Ellipse(extent={{-70,70},{70,-70}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{0,70},{0,40}},color={0,0,0}),Line(points={{22.9,32.8},{40.2,57.3}},color={0,0,0}),Line(points={{-22.9,32.8},{-40.2,57.3}},color={0,0,0}),Line(points={{37.6,13.7},{65.8,23.9}},color={0,0,0}),Line(points={{-37.6,13.7},{-65.8,23.9}},color={0,0,0}),Line(points={{0,0},{9.02,28.6}},color={0,0,0}),Polygon(points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{-5,5},{5,-5}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
  end PartialRelativeSensor;

  partial model PartialFriction
   "Partial model of Coulomb friction elements"

  // components of PartialFriction
   parameter SI.AngularVelocity w_small=1.0e10 "Relative angular velocity near to zero if jumps due to a reinit(..) of the velocity can occur (set to low value only if such impulses can occur)" annotation(Dialog(tab="Advanced"));
   SI.AngularVelocity w_relfric "Relative angular velocity between frictional surfaces";
   SI.AngularAcceleration a_relfric "Relative angular acceleration between frictional surfaces";
   SI.Torque tau0 "Friction torque for w=0 and forward sliding";
   SI.Torque tau0_max "Maximum friction torque for w=0 and locked";
   Boolean free "true, if frictional element is not active";
   Real sa(final unit="1") "Path parameter of friction characteristic tau = f(a_relfric)";
   Boolean startForward(start=false,fixed=true) "true, if w_rel=0 and start of forward sliding";
   Boolean startBackward(start=false,fixed=true) "true, if w_rel=0 and start of backward sliding";
   Boolean locked(start=false) "true, if w_rel=0 and not sliding";
   constant Integer Unknown=3 "Value of mode is not known";
   constant Integer Free=2 "Element is not active";
   constant Integer Forward=1 "w_rel > 0 (forward sliding)";
   constant Integer Stuck=0 "w_rel = 0 (forward sliding, locked or backward sliding)";
   constant Integer Backward=-1 "w_rel < 0 (backward sliding)";
   Integer mode(final min=Backward,final max=Unknown,start=Unknown,fixed=true);
  protected
   constant SI.AngularAcceleration unitAngularAcceleration=1 annotation(HideResult=true);
   constant SI.Torque unitTorque=1 annotation(HideResult=true);

  // algorithms and equations of PartialFriction
  equation
   startForward = (((pre(mode)==Stuck) and ((sa>(tau0_max/(unitTorque))) or (pre(startForward) and (sa>(tau0/(unitTorque)))))) or ((pre(mode)==Backward) and (w_relfric>w_small))) or (initial() and (w_relfric>0));
   startBackward = (((pre(mode)==Stuck) and ((sa<((-tau0_max)/(unitTorque))) or (pre(startBackward) and (sa<((-tau0)/(unitTorque)))))) or ((pre(mode)==Forward) and (w_relfric<-w_small))) or (initial() and (w_relfric<0));
   locked = not free and not (((pre(mode)==Forward) or startForward) or (pre(mode)==Backward)) or startBackward;
   a_relfric/(unitAngularAcceleration) = (if locked then 0 else (if free then sa else (if startForward then sa-tau0_max/(unitTorque) else (if startBackward then sa+tau0_max/(unitTorque) else (if pre(mode)==Forward then sa-tau0_max/(unitTorque) else sa+tau0_max/(unitTorque))))));
   mode = (if free then Free else (if (((pre(mode)==Forward) or (pre(mode)==Free)) or startForward) and (w_relfric>0) then Forward else (if (((pre(mode)==Backward) or (pre(mode)==Free)) or startBackward) and (w_relfric<0) then Backward else Stuck)));

  annotation(Documentation(info="<html>
<p>
Basic model for Coulomb friction that models the stuck phase in a reliable way.
</p>
</html>"));
  end PartialFriction;

 annotation(Documentation(info="<html>
<p>
This package contains connectors and partial models for 1-dim.
rotational mechanical components. The components of this package can
only be used as basic building elements for models.
</p>

</html>
"));
 end Interfaces;

 package Icons
  "Icons for Rotational package"
  extends Modelica.Icons.Package;

  partial class Gear
   "Rotational gear icon"

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={2,2}),graphics={Rectangle(extent={{-40,20},{-20,-20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-40,100},{-20,20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{20,80},{40,39}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{20,40},{40,-40}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{40,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-20,70},{20,50}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-100,10},{-40,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-80,20},{-60,20}},color={0,0,0}),Line(points={{-80,-20},{-60,-20}},color={0,0,0}),Line(points={{-70,-20},{-70,-86}},color={0,0,0}),Line(points={{0,40},{0,-86}},color={0,0,0}),Line(points={{-10,40},{10,40}},color={0,0,0}),Line(points={{-10,80},{10,80}},color={0,0,0}),Line(points={{60,-20},{80,-20}},color={0,0,0}),Line(points={{60,20},{80,20}},color={0,0,0}),Line(points={{70,-20},{70,-86}},color={0,0,0}),Line(points={{70,-86},{-70,-86}},color={0,0,0})}),Documentation(info="<html>
<p>
This is the icon of a gear from the rotational package.
</p>
</html>"));
  end Gear;

  model Gearbox
   "Icon of gear box"

  annotation(Icon(graphics={Rectangle(extent={{-100,10},{-60,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{60,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-40,60},{40,-60}},lineColor={0,0,0},pattern=LinePattern.Solid,lineThickness=0.25,fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Polygon(points={{-60,10},{-60,20},{-40,40},{-40,-40},{-60,-20},{-60,10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={128,128,128}),Polygon(points={{60,20},{40,40},{40,-40},{60,-20},{60,20}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Polygon(points={{-60,-80},{-46,-80},{-20,-20},{20,-20},{46,-80},{60,-80},{60,-90},{-60,-90},{-60,-80}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid)}),Documentation(info="<html>
<p>
This is the icon of a gear box from the rotational package.
</p>
</html>"));
  end Gearbox;

  model Clutch
   "Icon of a clutch"

  annotation(Icon(graphics={Rectangle(extent={{-100,10},{-30,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-30,60},{-10,-60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{10,60},{30,-60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{30,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Polygon(points={{-30,40},{-60,50},{-60,30},{-30,40}},lineColor={0,0,127},fillColor={0,0,127},fillPattern=FillPattern.Solid),Polygon(points={{30,40},{60,50},{60,30},{30,40}},lineColor={0,0,127},fillColor={0,0,127},fillPattern=FillPattern.Solid),Line(points={{0,90},{90,70},{90,40},{30,40}},color={0,0,127}),Line(points={{0,90},{-90,70},{-90,40},{-30,40}},color={0,0,127})}),Documentation(info="<html>
<p>
This is the icon of a clutch from the rotational package.
</p>
</html>"));
  end Clutch;
 end Icons;

annotation(Documentation(info="<html>

<p>
Library <b>Rotational</b> is a <b>free</b> Modelica package providing
1-dimensional, rotational mechanical components to model in a convenient way
drive trains with frictional losses. A typical, simple example is shown
in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/Rotational/driveExample.png\">

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide\">Rotational.UsersGuide</a>
     discusses the most important aspects how to use this library.</li>
<li> <a href=\"modelica://Modelica.Mechanics.Rotational.Examples\">Rotational.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>

<p>
In version 3.0 of the Modelica Standard Library, the basic design of the
library has changed: Previously, bearing connectors could or could not be connected.
In 3.0, the bearing connector is renamed to \"<b>support</b>\" and this connector
is enabled via parameter \"useSupport\". If the support connector is enabled,
it must be connected, and if it is not enabled, it must not be connected.
</p>

<p>
In version 3.2 of the Modelica Standard Library, all <b>dissipative</b> components
of the Rotational library got an optional <b>heatPort</b> connector to which the
dissipated energy is transported in form of heat. This connector is enabled
via parameter \"useHeatPort\". If the heatPort connector is enabled,
it must be connected, and if it is not enabled, it must not be connected.
Independently, whether the heatPort is enabled or not,
the dissipated power is available from the new variable \"<b>lossPower</b>\" (which is
positive if heat is flowing out of the heatPort). For an example, see
<a href=\"modelica://Modelica.Mechanics.Rotational.Examples.HeatLosses\">Examples.HeatLosses</a>.
</p>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>
",revisions=""),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{-83,-66},{-63,-66}},color={0,0,0}),Line(points={{36,-68},{56,-68}},color={0,0,0}),Line(points={{-73,-66},{-73,-91}},color={0,0,0}),Line(points={{46,-68},{46,-91}},color={0,0,0}),Line(points={{-83,-29},{-63,-29}},color={0,0,0}),Line(points={{36,-32},{56,-32}},color={0,0,0}),Line(points={{-73,-9},{-73,-29}},color={0,0,0}),Line(points={{46,-12},{46,-32}},color={0,0,0}),Line(points={{-73,-91},{46,-91}},color={0,0,0}),Rectangle(extent={{-47,-17},{27,-80}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-87,-41},{-47,-54}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{27,-42},{66,-56}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192})}));
end Rotational;
