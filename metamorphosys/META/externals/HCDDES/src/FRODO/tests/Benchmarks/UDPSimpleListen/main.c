// Example main.c - This should be generated by the FRODO code generator
#include "frodo.h"


/*****************************************************************************/


/*** Message Structures ***/

// Message struct for message type pos_data_msg_t
typedef struct {
	pfloat_t value;
} data_t;


// Global Context
typedef struct {
	// Schedulable instances
	SchedSchedulable*			task1;
	// Channel instances
	UDPChannel*					udpChannel;
	// Message Ports
	PortId_t					msgPort;
} Context_t;


/*****************************************************************************/


void* Task1_exec( void *cntx ) {
	// Cast to a context structure
	Context_t* context = (Context_t*)cntx;
//	char localBuffer[256];
	data_t data = { 0.0 };
	ReturnCode_t returnCode = 0;
	while ( true ) {
		// Wait to execute
		SchedSignalExecution( context->task1 );

		// Read the message port
		ReadSamplingMessage( context->msgPort, &data, NULL, NULL, &returnCode );
		// Write out a message for the moment
//		sprintf( localBuffer, "====>\t\tValue: %4.3f.\n", data.value += 0.5 );
//		LogMessage( localBuffer );
		// Write the new value back to the port
		WriteSamplingMessage( context->msgPort, &data, sizeof(data_t), &returnCode );

		// Signal that we are done with this execution
		SchedSignalCompletion( context->task1 );
	}
	// Must return something - never will get here
	return NULL;
}


/*****************************************************************************/


/** Primary entry function ***/
int main( int argc, char* argv[] ) {
	ReturnCode_t returnCode;
	// Create the master context
	Context_t context;
	// Zero the context
	memset( &context, 0, sizeof(Context_t) );
	// Check the command line arguments for local and remote IP addresses
	assert( argc == 4 );
	// Initialize FRODO subsystems
	SysEventInitialize( AllCategories, true, true, false );
	PeripheralInitialize();
	LogInitialize();
	ErrorHandlerInitialize();
	SchedInitialize( EarliestDeadlineFirst, ErrSchedulerHandler, 20.0, 1, &context );
	// Initialize the UDP subsystem
	UDPInitialize( ErrUDPHandler );

	/*** Create message ports ***/
	{
		// Set initial value of port message
		data_t data = { 1.0 };
		CreateSamplingPort( "data", sizeof(data_t), Bidirectional, 0, &(context.msgPort), &returnCode );
		WriteSamplingMessage( context.msgPort, &data, sizeof(data_t), &returnCode );
	}

	/*** Create Tasks ***/

	{
		// Create task with instances
		pfloat_t Task1_times[9] = { 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0, 18.0 };
		SchedCreatePeriodicTask( "Task1", Task1_exec, &context.task1, 0.75, NoRestriction, 9, Task1_times );
	}

	/*** Create Peripherals ***/

	{
		// Create a channel with no expectations
		context.udpChannel = UDPCreateChannel( argv[1], argv[2], 21212, 0, NULL, 0, NULL, true, true, 1 );
	}

	/*** Execute the schedule ***/

	// Wait for the platform to wake up ( Platform Dependent )
	NanoSleep( SCHEDULER_INITIALIZATION_WAIT );
	// Execute the schedule
	SchedExecute( atoi(argv[3]) );

	/*** Shutdown the application ***/

	// If this returns we must shut everything down
	UDPShutdown( );
	SchedShutdown( );
	SysEventShutdown( NULL );
}