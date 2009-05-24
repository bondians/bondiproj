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

#include <inttypes.h>
#include <stdio.h>

// Number of nixie segments (incuding no-connects) on the display

#define NIXIE_SEGMENTS           64

// Number of segments per nixie digit (tube)

#define NIXIE_SEGMENTS_PER_DIGIT 10

// Number of display positions (tubes)

#define NIXIE_DISPLAY_WIDTH     6

// Number of allowable intensity levels: 0 is off, MAX_NIXIE_INTENSITY is
// full-on.
// This value, along with the TIMER0 OCR0A interrupt rate (625x/sec when
// F_CPU = 16000000), determines the display PWM period.

#define MAX_NIXIE_INTENSITY     9

// Digit offsets for neon lamps (as used by set_nixie_segment())

#define NIXIE_LEFT_LAMP         (NIXIE_DISPLAY_WIDTH + 0)
#define NIXIE_RIGHT_LAMP        (NIXIE_DISPLAY_WIDTH + 1)
#define NIXIE_AUX_A             (NIXIE_DISPLAY_WIDTH + 2)
#define NIXIE_AUX_B             (NIXIE_DISPLAY_WIDTH + 3)

//------------------------------------------------------------------------------

// Output control flags used by nixie_out()

typedef union {
    uint8_t all;
    struct {
        uint8_t no_cursor_inc   : 1;    // Do not auto-increment cursor
        uint8_t single_no_inc   : 1;    // Do not auto-increment cursor for next char
        uint8_t overlay         : 1;    // Overlay new segment pattern onto existing pattern
        uint8_t single_overlay  : 1;    // Overlay segments for next char only
        uint8_t no_cursor_wrap  : 1;    // Do not wrap cursor when it goes off left or right side
        uint8_t unused5         : 1;
        uint8_t unused6         : 1;
        uint8_t unused7         : 1;
    };
} control_t;

// Output modes/states, determines how character stream is processed

typedef enum {
    NORMAL_OUTPUT,                      // Interpret character normally
    SET_INTENSITY,                      // Character is set intensity parameter
    SET_CURSOR_POS                      // Character is cursor position parameter
} state_t;

// Collection of data needed to manage a nixie display output stream
// A variable of this type is pointed to in the <udev> field of the
// stdio FILE structure.

typedef struct {
    uint8_t *segdata;                   // Pointer to display segment intensity buffer
    uint8_t cursor;                     // Cursor position, next char output here
    uint8_t intensity;                  // Intensity level of segments written
    state_t state;                      // Output mode, see state_t
    control_t control;                  // Output control flags
} nixie_stream_t;

//------------------------------------------------------------------------------

void nixie_display_refresh(void);
void nixie_stream_init(FILE *stream, nixie_stream_t *control, uint8_t *segdata);
void nixie_show_stream(FILE *stream);
int16_t nixie_out(char ch, FILE *stream);

#endif  // NIXIE_H
