/*** Generated by the FRODO code generator -- DO NOT HAND EDIT ***/


#ifndef __FRODO_GENERATED_MAIN_H__
#define __FRODO_GENERATED_MAIN_H__


/*** Included Header Files ***/
#include "frodo.h"


/*** Message Structures ***/

// Message struct for message type pos_data_msg_t
typedef struct {
	pfloat_t value;
} data_t;


// Global Context
typedef struct {
	// Schedulable instances
	SchedSchedulable*				task1;
	// Channel instances
	UDPChannel*						udpChannel;
	// Message Ports
	PortId_t						msgPort;
} Context_t;


/*****************************************************************************/


#endif // __FRODO_GENERATED_MAIN_H__

