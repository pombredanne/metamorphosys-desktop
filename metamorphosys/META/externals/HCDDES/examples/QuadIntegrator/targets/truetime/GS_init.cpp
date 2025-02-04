/***
 * Generated code: DO NOT EDIT MANUALLY
 * For use in generating Matlab/Simulink + TrueTime
 * models from ESMoL models.  Please consult ESMoL
 * documentation for additional information.
***/


/*** Gloablly Included Header Files ***/
#define S_FUNCTION_NAME GS_init
#define mexPutArray
#include "ttkernel.cpp"
#include <map>
#include "OuterLoop_sl.c"



/*** Message Structures ***/

// Message struct for message type DataHandling_pos_msg
typedef struct {
	single OuterLoop_pos;
	single OuterLoop_pos_ref;
	
} DataHandling_pos_msg_t;

// Message struct for message type OuterLoop_ang_ref
typedef struct {
	single OuterLoop_ang_ref;
	
} OuterLoop_ang_ref_t;



/*** Setup Kernel Data Structure ***/
// Kernel data structure
struct KernelData {
	OuterLoop_context* OuterLoop_ctx;
	
	DataHandling_pos_msg_t*		DataHandling_pos_msg;
	OuterLoop_ang_ref_t*		OuterLoop_ang_ref;
	
	// Other kernel data needed by the scheduler
	unsigned int								hyperperiod;
	double										hyperperiodStart;
	std::map< double, std::string >				tasks;
	std::map< double, std::string >::iterator	currentTask;
};


/************************************************************/

//Code to handle the execution of OuterLoop_task
double OuterLoop_code( int seg, void *data ) {
	// Get the kernel data
	KernelData *kernelData = (KernelData*)ttGetUserData();
	// Go through the two possible phases
	switch ( seg ) {
		// Execute component code
		case 1:
			// Execute the task component
			OuterLoop_main( 
				kernelData->OuterLoop_ctx,
				kernelData->DataHandling_pos_msg->OuterLoop_pos_ref,
				kernelData->DataHandling_pos_msg->OuterLoop_pos,
				&kernelData->OuterLoop_ang_ref->OuterLoop_ang_ref
				);
			// Return the WCET for the task
			return 0.000245;
		
		// We are done phase
		default:
			return FINISHED;
	}
}




/************************************************************/

//Code to handle the communication of DataHandling_pos_msg
double DataHandling_pos_msg_code( int seg, void *data ) {
	// Get the kernel data
	KernelData *kernelData = (KernelData*)ttGetUserData();
	void* localBuffer;
	// Go through the two possible phases
	switch ( seg ) {
		// Execute component code
		case 1:
			
			// Receive the message from the network
			localBuffer = ttGetMsg( 1 );
			// Check if null local buffer
			if ( localBuffer != NULL ) {
				// Copy data into the actual message buffer
				memcpy( kernelData->DataHandling_pos_msg, localBuffer, sizeof( DataHandling_pos_msg_t ) );
			} 
			return 0.000001;  // ${WCET} = 0.001000;
			

		// We are done phase
		default:
			return FINISHED;
	}
}
/************************************************************/

//Code to handle the communication of OuterLoop_ang_ref
double OuterLoop_ang_ref_code( int seg, void *data ) {
	// Get the kernel data
	KernelData *kernelData = (KernelData*)ttGetUserData();
	void* localBuffer;
	// Go through the two possible phases
	switch ( seg ) {
		// Execute component code
		case 1:
			// Send the message onto the network
			localBuffer = (void*)kernelData->OuterLoop_ang_ref;
			ttSendMsg( 1, 2, localBuffer, sizeof( OuterLoop_ang_ref_t ) );
			return 0.001000;
			
			

		// We are done phase
		default:
			return FINISHED;
	}
}


/************************************************************/


void add_tasks( std::string taskName, int count, double* times ) {
	KernelData *kernelData = (KernelData*)ttGetUserData();
	// Loop through the times
	for (int i = 0; i < count; i++ ) {
		// A negative time indicates not to add it
		if ( times[i] > 0.0 ) {
			// Add each time to the master task list with task name
			kernelData->tasks.insert( std::make_pair( times[i], taskName ) );
		}
	}
}


double scheduler_exec( int seg, void *data ) {
	// Get the kernel data structure
	KernelData *kernelData = (KernelData*)ttGetUserData();

	// See if we are in the start of a hyperperiod ...
	if ( seg == 1 ) {
		// Determine start of current hyperperiod
		kernelData->hyperperiodStart = ttCurrentTime();
	}
	// Otherwise we should schedule a task
	else {
		// We are woken up, now schedule the task
		ttCreateJob( kernelData->currentTask->second.c_str() );
		// Move on to the next task
		kernelData->currentTask++;
		// Double check for end of hyperperiod
		if ( kernelData->currentTask == kernelData->tasks.end() ) {
			// Reset the task list pointer
			kernelData->currentTask = kernelData->tasks.begin();
			// Increment the hyperperiod count
			kernelData->hyperperiod++;
			// And we are out of here
			return FINISHED;
		}
	}
	// Determine time of the next task to be executed
	double taskTime = kernelData->currentTask->first + kernelData->hyperperiodStart;
	// Sleep until that time
	ttSleepUntil( taskTime );
	// Each scheduler segment consumes 1us
	return 0.000001;
}


/************************************************************/


// Primary entry point for the GS_init Matlab function
void init() {
	// Initialize TrueTime kernel  
	ttInitKernel( prioFP );
  
	// Allocate kernel data and store pointer in UserData
	KernelData* kernelData = new KernelData;
	ttSetUserData( kernelData );
  
	// Read the input argument from the block dialogue
	mxArray *initarg = ttGetInitArg();
	if ( !mxIsDoubleScalar( initarg ) ) {
		TT_MEX_ERROR( "The init argument must be a number!\n" );
		return;
	}

	/*****************************************************/
	
	// Allocate all local message structures into kernel data
	kernelData->DataHandling_pos_msg = new DataHandling_pos_msg_t;
	memset( kernelData->DataHandling_pos_msg, 0, sizeof(DataHandling_pos_msg_t) );
	kernelData->OuterLoop_ang_ref = new OuterLoop_ang_ref_t;
	memset( kernelData->OuterLoop_ang_ref, 0, sizeof(OuterLoop_ang_ref_t) );
	


	/*****************************************************/

	// Create and store pointer in kernel data
	kernelData->OuterLoop_ctx = new OuterLoop_context;
	// Initialize component and its context data
	OuterLoop_init( kernelData->OuterLoop_ctx );
	// Add all instances of the tasks to the global task list
	double OuterLoop_task_data[1] = { 0.01 };
	add_tasks( "OuterLoop_task", 1, OuterLoop_task_data );
	// Create a sporadic controller task
	ttCreateTask( "OuterLoop_task", 0.000245, OuterLoop_code );
	ttSetPriority( 2, "OuterLoop_task" );





	/*****************************************************/

	// Add all instances of the bus message to the global task list
	double DataHandling_pos_msg_task_data[1] = { 0.017 };
	add_tasks( "DataHandling_pos_msg_task", 1, DataHandling_pos_msg_task_data );
	// Create a sporadic bus message task
	ttCreateTask( "DataHandling_pos_msg_task", 0.001000, DataHandling_pos_msg_code );
	ttSetPriority( 2, "DataHandling_pos_msg_task" );

	/*****************************************************/

	// Add all instances of the bus message to the global task list
	double OuterLoop_ang_ref_task_data[1] = { 0.013 };
	add_tasks( "OuterLoop_ang_ref_task", 1, OuterLoop_ang_ref_task_data );
	// Create a sporadic bus message task
	ttCreateTask( "OuterLoop_ang_ref_task", 0.001000, OuterLoop_ang_ref_code );
	ttSetPriority( 2, "OuterLoop_ang_ref_task" );


	/*****************************************************/


	// Setup the master hyperperiod schedule and get ready to run
	kernelData->hyperperiod = 0;
	kernelData->currentTask = kernelData->tasks.begin();
	// Create the primary scheduler task
	ttCreatePeriodicTask( "FRODO_Scheduler", 0.020000, scheduler_exec );
	ttSetPriority( 1, "FRODO_Scheduler" );
}


void cleanup() {
	// Free all dynamic memory allocated during run-time
	KernelData *kernelData = (KernelData*)ttGetUserData();
	delete kernelData->OuterLoop_ctx;

	delete kernelData->DataHandling_pos_msg;
	delete kernelData->OuterLoop_ang_ref;

	kernelData->tasks.clear();
	kernelData->currentTask = kernelData->tasks.begin();
	// Finally, delete the kernel data structure itself
	delete kernelData;
}


/************************************************************/

