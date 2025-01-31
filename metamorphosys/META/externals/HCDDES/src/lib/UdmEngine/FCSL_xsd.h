#ifndef FCSL_xsd_H
#define FCSL_xsd_H
#include <string>
#pragma warning( disable : 4010)

namespace FCSL_xsd
{
const std::string& getString()
{
	static std::string str;
	if (str.empty())
	{
			str +="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
			str +="<?udm interface=\"FCSL\" version=\"1.00\"?>\n";
			str +="<xsd:schema xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n";
			str +=" xmlns:FM=\"http://www.isis.vanderbilt.edu/2004/schemas/FM\"\n";
			str +=" xmlns:SLSF=\"http://www.isis.vanderbilt.edu/2004/schemas/SLSF\"\n";
			str +=" elementFormDefault=\"qualified\" \n";
			str +=">\n";
			str +="<!-- generated on Mon Dec 10 10:56:35 2007 -->\n";
			str +="\n";
			str +="<xsd:import namespace=\"http://www.isis.vanderbilt.edu/2004/schemas/FM\" schemaLocation=\"FCSL_FM.xsd\"/>\n";
			str +="<xsd:import namespace=\"http://www.isis.vanderbilt.edu/2004/schemas/SLSF\" schemaLocation=\"FCSL_SLSF.xsd\"/>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ScheduleItemType\">\n";
			str +="		<xsd:attribute name=\"Duration\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"activationDelay\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"activationPeriod\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"ref\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"setOperatingMode\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"PartitionType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"ID\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"PartitionMemory\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"SystemPartition\" type=\"xsd:boolean\" default=\"false\"/>\n";
			str +="		<xsd:attribute name=\"Criticality\" type=\"xsd:string\" default=\"NONE\"/>\n";
			str +="		<xsd:attribute name=\"startupOrder\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"referedbyScheduleItem\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"members\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"CommMappingType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"dstCommMapping_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"srcCommMapping_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ProcessType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"TimeCapacity\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"kindOfDeadline\" type=\"xsd:string\" default=\"SOFT\"/>\n";
			str +="		<xsd:attribute name=\"stackSize\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"startOffset\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"basePriority\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"activationPeriod\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"isAperiodic\" type=\"xsd:boolean\" default=\"false\"/>\n";
			str +="		<xsd:attribute name=\"entryPoint\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"infiniteTimeCapacity\" type=\"xsd:boolean\" default=\"false\"/>\n";
			str +="		<xsd:attribute name=\"isHealthMonitor\" type=\"xsd:boolean\" default=\"false\"/>\n";
			str +="		<xsd:attribute name=\"setPartition\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"ref\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"OperatingModeType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"members\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ProcessingModuleType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"BusPort\" type=\"BusPortType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"CommMapping\" type=\"CommMappingType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"DevicePort\" type=\"DevicePortType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"OperatingMode\" type=\"OperatingModeType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"Partition\" type=\"PartitionType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"Process\" type=\"ProcessType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"ScheduleItem\" type=\"ScheduleItemType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"SPECint_rate2000\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"CPUType\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Cores\" type=\"xsd:long\" default=\"1\"/>\n";
			str +="		<xsd:attribute name=\"SPECfp_rate2000\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Memory\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"DevicePortType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"PhysicalAddress\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Procedure\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"BusType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"Medium\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"FrameSize\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"BusSpeed\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"MajorCycle\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstWire\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcWire\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"BusPortType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"PhysicalAddress\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Procedure\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstWire\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcWire\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"WireType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"dstWire_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"srcWire_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"HardwareModelsType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"HardwareSheet\" type=\"HardwareSheetType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"HardwareSheetType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"Bus\" type=\"BusType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"ProcessingModule\" type=\"ProcessingModuleType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"Wire\" type=\"WireType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"Port2ChannelType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"dstPort2Channel_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"srcPort2Channel_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"Channel2PortType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"srcChannel2Port_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"dstChannel2Port_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ChannelType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"ID\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Type\" type=\"xsd:string\" default=\"QUEUING\"/>\n";
			str +="		<xsd:attribute name=\"srcPort2Channel\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstChannel2Port\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"EventChannelType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"QueuingDiscipline\" type=\"xsd:string\" default=\"FIFO\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"ChannelType\" type=\"xsd:string\" default=\"EVENT\"/>\n";
			str +="		<xsd:attribute name=\"Count\" type=\"xsd:long\" default=\"1\"/>\n";
			str +="		<xsd:attribute name=\"srcOE2EC\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstEC2IE\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ComponentSheetType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"Channel\" type=\"ChannelType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"Channel2Port\" type=\"Channel2PortType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"Component\" type=\"ComponentType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"ComponentShortcut\" type=\"ComponentShortcutType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"EC2IE\" type=\"EC2IEType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"EventChannel\" type=\"EventChannelType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"OE2EC\" type=\"OE2ECType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"Port2Channel\" type=\"Port2ChannelType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ComponentType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"BitTestRef\" type=\"BitTestRefType\" minOccurs=\"0\"/>\n";
			str +="			<xsd:element name=\"EventPortMapping\" type=\"EventPortMappingType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"InputEvent\" type=\"InputEventType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"InputPort\" type=\"InputPortType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"OutputEvent\" type=\"OutputEventType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"OutputPort\" type=\"OutputPortType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"PortMapping\" type=\"PortMappingType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"SystemRef\" type=\"SystemRefType\" minOccurs=\"0\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"referedbyProcess\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"referedbyComponentShortcut\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"EventPortMappingType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"StorageClass\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstEventPortMapping_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"srcEventPortMapping_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"OutputPortType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"MaxMessageSize\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"RefreshRateSeconds\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"MaxNbMessages\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Type\" type=\"xsd:string\" default=\"QUEUING\"/>\n";
			str +="		<xsd:attribute name=\"dstCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstInPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcInPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstPort2Channel\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"OE2ECType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"dstOE2EC_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"srcOE2EC_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"EC2IEType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"srcEC2IE_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"dstEC2IE_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ComponentModelsType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"ComponentSheet\" type=\"ComponentSheetType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"BitTestRefType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"ref\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"PortMappingType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"StorageClass\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstInPortMapping_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"srcInPortMapping_end_\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"InputEventType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstEventPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcEventPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcEC2IE\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"SystemRefType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"ref\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"OutputEventType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"dstEventPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcEventPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstOE2EC\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"InputPortType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"MaxMessageSize\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Name\" type=\"xsd:string\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"RefreshRateSeconds\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"MaxNbMessages\" type=\"xsd:long\" use=\"required\"/>\n";
			str +="		<xsd:attribute name=\"Type\" type=\"xsd:string\" default=\"QUEUING\"/>\n";
			str +="		<xsd:attribute name=\"dstCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcCommMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"dstInPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcInPortMapping\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"srcChannel2Port\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"ComponentShortcutType\">\n";
			str +="		<xsd:attribute name=\"position\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"ref\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +="	<xsd:complexType name=\"RootFolderType\">\n";
			str +="		<xsd:sequence>\n";
			str +="			<xsd:element name=\"ComponentModels\" type=\"ComponentModelsType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element ref=\"FM:PlatformModels\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element ref=\"FM:TestModels\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element ref=\"FM:UnitModels\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"HardwareModels\" type=\"HardwareModelsType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element name=\"RootFolder\" type=\"RootFolderType\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element ref=\"SLSF:Dataflow\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element ref=\"SLSF:Stateflow\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="			<xsd:element ref=\"SLSF:Types\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>\n";
			str +="		</xsd:sequence>\n";
			str +="		<xsd:attribute name=\"name\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_id\" type=\"xsd:ID\"/>\n";
			str +="		<xsd:attribute name=\"_archetype\" type=\"xsd:IDREF\"/>\n";
			str +="		<xsd:attribute name=\"_derived\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_instances\" type=\"xsd:IDREFS\"/>\n";
			str +="		<xsd:attribute name=\"_desynched_atts\" type=\"xsd:string\"/>\n";
			str +="		<xsd:attribute name=\"_real_archetype\" type=\"xsd:boolean\"/>\n";
			str +="		<xsd:attribute name=\"_subtype\" type=\"xsd:boolean\"/>\n";
			str +="	</xsd:complexType>\n";
			str +="\n";
			str +=" <xsd:element name=\"RootFolder\" type=\"RootFolderType\"/>\n";
			str +="\n";
			str +="</xsd:schema>\n";
			str +="\n";
		}
		return str;
	}
} //namespace
#endif
