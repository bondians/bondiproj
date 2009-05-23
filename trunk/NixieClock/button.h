/*------------------------------------------------------------------------------
Name:       button.h
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       22-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    Button decoding routines
------------------------------------------------------------------------------*/

#ifndef BUTTON_H
#define BUTTON_H

#include "timer.h"

// Total number of buttons handled by these routines

#define NUM_BUTTONS             8

// "Short" button press (debounce) delay

#define BUTTON_SHORT_DELAY      MS_TO_TICKS(50)

// "Long" button press delay

#define BUTTON_LONG_DELAY       MS_TO_TICKS(1000)

//------------------------------------------------------------------------------

// Button status bitmap

typedef union {
    uint8_t all;
    struct {
        uint8_t button0     : 1;
        uint8_t button1     : 1;
        uint8_t button2     : 1;
        uint8_t button3     : 1;
        uint8_t button4     : 1;
        uint8_t button5     : 1;
        uint8_t left_button : 1;
        uint8_t right_button: 1;
    };
} button_t;

//------------------------------------------------------------------------------

// Exported functions

button_t read_button_state(void);
button_t read_buttons_pressed(void);
button_t reset_buttons_pressed(void);
button_t read_buttons_released(void);
button_t reset_buttons_released(void);
button_t read_short_buttons(void);
button_t reset_short_buttons(void);
button_t read_long_buttons(void);
button_t reset_long_buttons(void);

void button_scan(void);

#endif
