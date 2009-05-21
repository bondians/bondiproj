/*------------------------------------------------------------------------------
Name:       nixie.h
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       20-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    Nixie display driver routines
------------------------------------------------------------------------------*/

#ifndef NIXIE_H
#define NIXIE_H

// Number of nixie segments (incuding no-connects) on the display

#define NUM_NIXIE_SEGMENTS      64

// Number of segments per nixie digit (tube)

#define NIXIE_SEGMENTS_PER_DIGIT 10

// Number of display positions (tubes)

#define NIXIE_DISPLAY_WIDTH     6

// Number of allowable intensity levels: 0 is off, MAX_NIXIE_INTENSITY is
// full-on.
// This value, along with the TIMER0 OCR0A interrupt rate (625x/sec when
// F_CPU = 16000000), determines the display PWM period.

#define MAX_NIXIE_INTENSITY     9

//------------------------------------------------------------------------------

// The nixie_segment[] array contains the intensity settings for each and every
// nixie display segment.  Allowable values per element are
// 0..MAX_NIXIE_INTENSITY.  The TIMER0 OCR0A ISR 

extern uint8_t nixie_segment[NUM_NIXIE_SEGMENTS];

// Pointer to display "page" to show
// Should point to a NUM_NIXIE_SEGMENTS-byte array that contains intensity
// data for each segment in the display

extern uint8_t *nixie_segment_ptr;

//------------------------------------------------------------------------------

void nixie_display_init(void);
void set_nixie_segment(uint8_t digit, uint8_t segment, uint8_t intensity);
void clear_nixie_digit(uint8_t digit);
void nixie_display_refresh(void);

#endif  // NIXIE_H
