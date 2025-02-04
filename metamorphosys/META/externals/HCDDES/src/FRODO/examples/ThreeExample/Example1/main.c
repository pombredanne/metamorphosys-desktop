// Example main.c - This should be generated by the FRODO code generator
#include "main.h"
#include "logger.h"
#include "arch/highres_timing.h"
#include "error_handler.h"
#include "scheduler.h"
#include "udp.h"


#define UTILIZATION				0.95


/*****************************************************************************/


/*** Message Structures ***/

// Message struct for message type ...
typedef struct {
	pfloat_t pos_data;
} UDPSend_msg_t;


// Global Context
typedef struct {
	// Schedulable instances
	FS_Schedulable*			task1;

	// Peripheral instances
	UDP_Channel*			udpChannel;

	// Message instances
	UDPSend_msg_t			udpSend_msg;
	Semaphore*				udpSend_sem;
} Context_t;


/*****************************************************************************/


void* Task1_exec( void *cntx ) {
	// Cast to a context structure
	Context_t* context = (Context_t*)cntx;
	char localBuffer[256];
	for ( ; ; ) {
		// Wait to execute
		FS_SignalExecution( context->task1 );
		// Increment pos_data value a bit
		context->udpSend_msg.pos_data += 0.05;
		//context->syncUDPIn_msg.pos_data + 0.05;
		sprintf( localBuffer, "====>\t\tValue: %4.3f.\n", context->udpSend_msg.pos_data );
		LogMessage( localBuffer );
		// Signal that we are done with this execution
		FS_SignalCompletion( context->task1 );
	}
	// Must return something - never will get here
	return NULL;
}


/*****************************************************************************/


/** Primary entry function ***/
int main(void) {
	// Create the master context
	Context_t context;
	memset( &context, 0, sizeof(Context_t) );
	// Initialize message semaphores
	context.udpSend_sem = _CreateSemaphore( "udpSend", 1 );
	// Initialize all tasks
	// ...

	// Initialize the logging subsystem
	FL_Initialize( ToConsole, AllCategories, false, NULL);
	FL_SetTypeMask( Scheduler, AllEvents & ~HyperperiodEnd );
	FL_SetTypeMask( Peripheral, AllEvents & ~ReceiveBegin );
	
	
	
	
	
	// Initialize Scheduler with hyperperiod length and context
	FS_Initialize( DeadlineMonotonic, 20.0, 1, &context );

	/*** Create Tasks ***/

	// Create RefHandler task with instances
	pfloat_t RefHandler_times[1] = { 5.0 };
	FS_CreatePeriodicTask( "RefHandler", RefHandler_exec, &context.RefHandler, 0.001, NoRestriction, 1, RefHandler_times );
	// Create OuterLoop task with instances
	pfloat_t OuterLoop_times[1] = { 10.0 };
	FS_CreatePeriodicTask( "OuterLoop", OuterLoop_exec, &context.OuterLoop, 1.5, NoRestriction, 1, OuterLoop_times );		

	/*** Create Peripheral Channels ***/
	
	pfloat_t msg1_rtimes[2] = { 8.0, 13.0 };
	pfloat_t msg1_stimes[1] = { 2.0 };
	FP_SyncExpectation expects[4] = {
		{ ExpectReceive, 1, sizeof(UDPSend_msg_t), 2, msg1_rtimes, 1.0, &context.udpSend_msg, context.udpSend_sem, NULL },
		{ ExpectSend, 1, sizeof(UDPSend_msg_t), 1, msg1_stimes, 1.0, &context.udpSend_msg, context.udpSend_sem, NULL }
	};
	context.udpChannel = UDP_CreateChannel( UDP_LOCALADDRESS, UDP_REMOTEADDRESS, 21212,
										   2, expects, 0, NULL, true, true, 3 );

	/*** Execute the schedule ***/

	// Wait for the platform to wake up ( Platform Dependent )
	NanoSleep( SCHEDULER_INITIALIZATION_WAIT, SCHEDULER_RESOLUTION_MS );
	// Execute the schedule
	FS_Execute( );

	
	
	
	
	
	/*** Shutdown the application ***/

	// If here, we must shut everything down
	UDP_Shutdown( );
	FS_Shutdown( );
	// Shutdown the logger
	FL_Shutdown( );

	// Destroy message semaphores
	_DestroySemaphore( "udpSend", context.udpSend_sem );
}
