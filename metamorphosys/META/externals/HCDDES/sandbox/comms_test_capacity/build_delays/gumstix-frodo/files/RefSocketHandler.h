/* 
 * C Code header for Module RefSocketHandler
 * Generated by C_CodeGen on 
 */

#ifndef _C_RefSocketHandler_H_
#define _C_RefSocketHandler_H_


/*** Context Definition ***/
typedef void* RefSocketHandler_context;


/*** Init Function Declaration ***/
void RefSocketHandler_init( RefSocketHandler_context* RefSocketHandler_ctxt );


/*** Main Function Declaration ***/
void RefSocketHandler_main(
	RefSocketHandler_context* RefSocketHandler_ctxt ,
	float raw_pos_ref[4],
	float *pos_ref[4]
);


#endif // _C_RefSocketHandler_H_

