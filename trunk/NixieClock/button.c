/*------------------------------------------------------------------------------
Name:       button.c
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

#include <inttypes.h>
#include <avr/io.h>
#include <util/atomic.h>

#include "portdef.h"
#include "timer.h"
#include "button.h"

//------------------------------------------------------------------------------

static volatile button_t button_state;
static volatile button_t button_pressed;
static volatile button_t button_released;
static volatile button_t button_short;
static volatile button_t button_long;

static volatile uint16_t button_timer[NUM_BUTTONS];

/******************************************************************************
 *
 ******************************************************************************/

button_t read_button_state(void)
{
    return button_state;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t read_buttons_pressed(void)
{
    return button_pressed;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t reset_buttons_pressed(void)
{
    button_t temp;

    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        temp = button_pressed;
        button_pressed.all = 0;
    }

    return temp;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t read_buttons_released(void)
{
    return button_released;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t reset_buttons_released(void)
{
    button_t temp;
     
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        temp = button_released;
        button_released.all = 0;
    }

    return temp;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t read_short_buttons(void)
{
    return button_short;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t reset_short_buttons(void)
{
    button_t temp;

    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        temp = button_short;
        button_short.all = 0;
    }

    return temp;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t read_long_buttons(void)
{
    return button_long;
}

/******************************************************************************
 *
 ******************************************************************************/

button_t reset_long_buttons(void)
{
    button_t temp;

    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        temp = button_long;
        button_long.all = 0;
    }

    return temp;
}

/******************************************************************************
 *
 ******************************************************************************/

void button_scan(void)
{
    register button_t button;
    register uint8_t  index;
    register uint8_t  mask;
    volatile register uint16_t *down_time_p;
    register uint16_t down_time;


    // Read current button status and store as present button state
    //
    // Note: Using the construct { if (PINREAD(x)) {y = 1} } is more efficient
    // than constructs like:
    //   y = PINREAD(x) != 0;
    //   or
    //   y = PINREAD(x) ? 1 : 0;
    // The method used below generates the tightest code when avr-gcc is used.

    button.all = 0xFF;

    if (PINREAD(BUTTON0)) {
        button.button0 = 0;
    }
    if (PINREAD(BUTTON1)) {
        button.button1 = 0;
    }
    if (PINREAD(BUTTON2)) {
        button.button2 = 0;
    }
    if (PINREAD(BUTTON3)) {
        button.button3 = 0;
    }
    if (PINREAD(BUTTON4)) {
        button.button4 = 0;
    }
    if (PINREAD(BUTTON5)) {
        button.button5 = 0;
    }
    if (PINREAD(LEFT_BUTTON)) {
        button.left_button = 0;
    }
    if (PINREAD(RIGHT_BUTTON)) {
        button.right_button = 0;
    }

    button_state = button;

    // Scan button status for changes, debounce buttons and register
    // button events

    down_time_p = button_timer;
    mask = 0x01;

    for (index = 0; index < NUM_BUTTONS; index++) {
        down_time = *down_time_p;

        if (button.all & mask) {

            // Button is pressed (on)
            // Do not increment button-down timer if it is at max already

            if (down_time != 0xFFFF) {
                down_time++;

                if (down_time == BUTTON_SHORT_DELAY) {

                    // Button down long enough to be considered debounced

                    button_pressed.all |= mask;
                }

                else if (down_time == BUTTON_LONG_DELAY) {

                    // Button down long enough to qualifiy as a long press

                    button_long.all |= mask;
                }
            }
        }

        else {

            // Button is up (off)

            if (down_time >= BUTTON_SHORT_DELAY) {

                // Button was down long enough to be debounced, so generate
                // a release event

                button_released.all |= mask;

                if (down_time < BUTTON_LONG_DELAY) {

                    // Button was down longer than minimum short time,
                    // but not long enough for the long time, so it qualifies
                    // as a short press

                    button_short.all |= mask;
                }
            }

            down_time = 0;
        }

        *down_time_p = down_time;
        down_time_p++;

        mask <<= 1;
    }
}
