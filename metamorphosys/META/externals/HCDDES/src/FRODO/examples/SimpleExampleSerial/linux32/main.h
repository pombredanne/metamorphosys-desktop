/*** Generated by the FRODO code generator -- DO NOT HAND EDIT ***/


#ifndef __FRODO_GENERATED_MAIN_H__
#define __FRODO_GENERATED_MAIN_H__


/*** Included Header Files ***/
#include "arch/linux32/linux32_platform.h"


/*** Optional Optimization Global Values ***/
// Scheduler
#define FS_MAXTASKNAMELENGTH				16
#define	FS_MAXSCHEDULABLES				8
#define	FS_MAXPERIODICINSTANCES				16
#define	FS_MAXSPORADICINSTANCES				16
#define FS_MAXSYNCCHANNELS				8
// Generic Peripherals
#define	FP_MAXMESSAGESIZE				256
// UDP Peripherals
#define SERIAL_MAXCHANNELS				1
#define SERIAL_MAXSYNCEXPECTATIONS			8
#define SERIAL_MAXASYNCEXPECTATIONS			8
#define SERIAL_MAXSYNCTIMES				8
#define SERIAL_MAXPEERS					8
#define SERIAL_SYNCPOLLWAIT				500
#define SERIAL_DEVICE					"/dev/ttyUSB0"
#define SERIAL_BAUD					115200
#define SERIAL_DATABITS					8
#define SERIAL_PARITY					0
#define SERIAL_STOPBITS					1


#define SERIAL_MAXEXPECTINSTANCES			8
// Logger
#define LOGGER_MAXENTRIES				1024 * 1024
#define LOGGER_TEXTLENGTH				128


/*****************************************************************************/


#endif // __FRODO_GENERATED_MAIN_H__

