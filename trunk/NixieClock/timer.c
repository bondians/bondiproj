/*------------------------------------------------------------------------------
Name:       timer.c
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       17-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    General purpose timing functions and RTC routines
------------------------------------------------------------------------------*/

#include <inttypes.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

#include "portdef.h"
#include "timer.h"
#include "nixie.h"

#if TIMER0_PRESCALER == 1
  #define TIMER0_PRESCALER_BITS     BM(CS00)
#elif TIMER0_PRESCALER == 8
  #define TIMER0_PRESCALER_BITS     BM(CS01)
#elif TIMER0_PRESCALER == 64
  #define TIMER0_PRESCALER_BITS     BM(CS01) | BM(CS00)
#elif TIMER0_PRESCALER == 256
  #define TIMER0_PRESCALER_BITS     BM(CS02)
#elif TIMER0_PRESCALER == 1024
  #define TIMER0_PRESCALER_BITS     BM(CS02) | BM(CS00)
#else
  #define TIMER0_PRESCALER_BITS     0
  #warning Invalid timer 0 prescaler selected (must be 1, 8, 64, 256 or 1024)
#endif

/******************************************************************************
 *
 ******************************************************************************/

void timer_init(void)
{
    TCCR0B = 0;                         // Stop timer during init

    TCCR0A = BM(WGM01);                 // OC0x pins disabled, CTC mode (WGM02..0 = 010)
    TCNT0 = 0;                          // Reset timer counter
    OCR0A = TIMER0_PERIOD_TICKS - 1;    // 625x/sec interval when prescaler = f/256 w/16MHz clock
    OCR0B = 0;                          // Set some known value in OCR0B (not used)
    TIMSK0 = BM(OCIE0A);                // Enable output compare A interrupt
    TIFR0 = BM(OCF0B) | BM(OCF0A) | BM(TOV0); // Clear all timer interrupt flags

    TCCR0B = TIMER0_PRESCALER_BITS;     // Select f/256 prescaler, start counter
}

/******************************************************************************
 *
 ******************************************************************************/

ISR(TIMER0_COMPA_vect, ISR_BLOCK)
{
    nixie_display_refresh();
}
