// Example main.c - This should be generated by the FRODO code generator
#include "main.h"
#include "logger.h"
#include "arch/highres_timing.h"
#include "error_handler.h"
#include "scheduler.h"
#include "serialio.h"

#define UTILIZATION				0.95


/*****************************************************************************/

/*** Message Structures ***/

// Message struct for message type SyncUDP_in_msg_t
typedef struct {
	pfloat_t pos_data;
	pfloat_t ang_data;
} Serial_in_msg_t;


// Global Context
typedef struct {
	// Schedulable instances
	FS_Schedulable*				task1;

	// Channel instances
	Serial_Channel*				serial0;

	// Message instances
	Serial_in_msg_t			    serialIn_msg;
	sem_t*						serialIn_sem;
} Context_t;

/*****************************************************************************/

void* Task1_exec( void *cntx ) {
	// Cast to a context structure
	Context_t* context = (Context_t*)cntx;
	char logBuffer[256];
	while ( true ) {
		// Wait to execute
		FS_SignalExecution( context->task1 );
		// Print out the values of the message
		sprintf( logBuffer, "=======> PosData: %4.3f.\n", context->serialIn_msg.pos_data );
		sprintf( logBuffer, "=======> AngData: %4.3f.\n", context->serialIn_msg.ang_data );
		// Do something
		context->serialIn_msg.pos_data += 0.05;
		context->serialIn_msg.ang_data = context->serialIn_msg.pos_data - 0.02;

		// Do we need to do an async send?
		if ( context->serialIn_msg.pos_data >= 0.20 ) {
			// Try to send Msg#1 in the next 20ms over channel syncUDP
			Serial_AsyncSend( context->serial0, 1, 20.0 );
		}
		LogMessage( logBuffer );
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
	// Zero the context
	memset( &context, 0, sizeof(Context_t) );
	// Initialize message semaphores
	context.serialIn_sem = _CreateSemaphore( "serialIn", 1 );
	// Initialize all tasks
	//...

	// Initialize the logging subsystem
	FL_Initialize( ToConsole, AllCategories, false, "SimpleExample.log");
	FL_SetTypeMask( Scheduler, AllEvents & ~HyperperiodEnd );
	FL_SetTypeMask( Peripheral, AllEvents & ~ReceiveBegin );
	// Initialize Scheduler with hyperperiod length and context
	FS_Initialize( DeadlineMonotonic, FE_SchedulerError, 20.0, 1, &context );
	// Initialize the UDP subsystem
	Serial_Initialize( FE_SerialError );


	/*** Create Tasks ***/

	{
		// Create task with instances
		pfloat_t Task1_data[1] = { 15.0 };
		FS_CreatePeriodicTask( "Task1", Task1_exec, &context.task1, 1.00, NoRestriction, 1, Task1_data );
	}

	/*** Create Peripherals ***/

	{
		pfloat_t msg1_rtimes[1] = { 10.0 };
		FP_SyncExpectation syncExpects[2] = {
			{ ExpectReceive, 1, sizeof(Serial_in_msg_t), 1, msg1_rtimes, 1.0, &context.serialIn_msg, context.serialIn_sem, NULL }
		};

		FP_AsyncExpectation asyncExpects[1] = {
			{ ExpectSend, 1, sizeof(Serial_in_msg_t), 1.0, 0.0, 20.0, &context.serialIn_msg, context.serialIn_sem, NULL }
		};
		context.serial0 = Serial_CreateChannel( "/dev/ttyS0", 57600, 1, syncExpects, 1, asyncExpects, true, false, 2 );
	}

	/*** Execute the schedule ***/

	// Wait for the platform to wake up ( Platform Dependent )
	NanoSleep( SCHEDULER_INITIALIZATION_WAIT, SCHEDULER_RESOLUTION_MS );
	// Execute the schedule
	FS_Execute( 12 );

	/*** Shutdown the application ***/

	// If this returns we must shut everything down
	Serial_Shutdown( );
	FS_Shutdown( );
	// Shutdown the logger
	FL_Shutdown( );
	// Destroy message semaphores
	_DestroySemaphore( "serialIn", context.serialIn_sem );
}
