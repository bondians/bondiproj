/*------------------------------------------------------------------------------
Name:       clock.c
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       24-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    Time & date managment functions
------------------------------------------------------------------------------*/

#include <inttypes.h>
#include <avr/pgmspace.h>
#include <util/atomic.h>

#include "clock.h"

//------------------------------------------------------------------------------

static time_t time;
static date_t date;

static uint8_t run;

//------------------------------------------------------------------------------

const uint8_t days_in_month[] PROGMEM =
    {00, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
//       Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

/******************************************************************************
 *
 ******************************************************************************/

void get_time_12(time_t *t, uint8_t *am_pm)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        *t = time;
    }

    (t->hour)++;
    if (t->hour > 12) {
        t->hour -= 12;
        *am_pm = 1;
    }
    else {
        *am_pm = 0;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void get_time_24(time_t *t)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        *t = time;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void set_time_12(time_t *t, uint8_t am_pm)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        time = *t;

        time.hour--;
        if (am_pm) {
            time.hour += 12;
        }
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void set_time_24(time_t *t)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        time = *t;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void get_date(date_t *d)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        *d = date;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void set_date(date_t *d)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
        date = *d;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void clock_run(uint8_t run_flag)
{
    run = run_flag;
}

/******************************************************************************
 *
 ******************************************************************************/

void time_date_update(void)
{
    if (!run) {
        return;
    }

    time.second++;
    if (time.second >= 60) {
        time.second = 0;
 
        time.minute++;
        if (time.minute >= 60) {
            time.minute = 0;
 
            time.hour++;
            if (time.hour >= 24) {
                time.hour = 0;
 
                date.day++;
                if (date.day > pgm_read_byte(&days_in_month[date.month])) {

                    // Leap-year logic - Add a leap-day if:
                    // - Month is February (2), and
                    // - Year is evenly divisible by 4, and
                    // - Year is not evenly divisible by 100, and
                    // - A leap-day has not already been added

                    if ((date.month != 2) ||
                        (date.year & 0x0004) || !(date.year % 100) ||
                        (date.day > pgm_read_byte(&days_in_month[date.month]))) {
                        date.day = 1;

                        date.month++;
                        if (date.month > 12) {
                            date.month = 1;
                            date.year++;
                        }
                    }
                }
            }
        }
    }
}
