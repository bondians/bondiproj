#ifndef DELAY_H
#define DELAY_H

/*------------------------------------------------------------------------------
Name:       delay.h
Project:    LCD2USB v2; LCD display interface based on AVR USB driver
Author:     Mark Schultz <n9xmj@yahoo.com>
Date:       07-Jan-2007
Tabsize:    4
Copyright:  (c) 2007 by Mark Schultz
License:    GPL
Revision:   $Id$
Target CPU: ATmega168

Content:    Basic software delay routines
------------------------------------------------------------------------------*/

#include <stdint.h>

#ifndef F_CPU
#define F_CPU 12000000UL
#endif

// Delay in 4 cycle units

extern void short_delay(uint16_t cyc4);

// Delay in microseconds

extern void delay_us(uint16_t us);

// Delay in milliseconds

extern void delay_ms(uint16_t ms);

#endif  // DELAY_H

