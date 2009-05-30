/*------------------------------------------------------------------------------
Name:       ClockDisplay.c
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       29-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    Clock display top level: Display time & date
------------------------------------------------------------------------------*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
//#include <avr/eeprom.h>
#include <string.h>
#include <stdio.h>

#include "portdef.h"
#include "delay.h"
#include "serial.h"
#include "nixie.h"
#include "player.h"
#include "event.h"
#include "clock.h"

//------------------------------------------------------------------------------

extern FILE primary, secondary;

typedef enum {
    MODE_CLOCK_12,
    MODE_CLOCK_24,
    MODE_DATE
} clock_mode_t;

/******************************************************************************
 *
 ******************************************************************************/

void SetTime(void)
{
}

/******************************************************************************
 *
 ******************************************************************************/

void TerminalMode(void)
{
    event_t event;
    int16_t ch;

    printf_P(PSTR("\r\nTerminal mode ready.\r\n"));

    fprintf_P(&primary, PSTR("\v\f"));
 
    do {
        event = get_next_event();
        if (event.event == BUTTON1_PRESSED) {
            break;
        }

        ch = serial_in();

        if (ch >= 0) {
            if (ch == '\e') {
                break;
            }
            serial_out(ch);
            nixie_out(ch, &primary);
        }
    } while (1);

    printf_P(PSTR("\r\nTerminal mode exit\r\n"));
    nixie_out('\v', &primary);
}

/******************************************************************************
 *
 ******************************************************************************/

/*
void SetClockMode(clock_mode_t *mode, event_t *event)
{
    uint8_t timer_id;
    uint8_t again;

    timer_id = timer_start(MS_TO_TICKS(750), 1);

    again = 1;
    do {
        timer_reset(timer_id);

        if (*mode == MODE_CLOCK_12) {
            *mode = MODE_CLOCK_24;
            fprintf_P(&secondary, PSTR("\f  24"));
        }
        else {
            *mode = MODE_CLOCK_12;
            fprintf_P(&secondary, PSTR("\f  12"));
        }
        nixie_crossfade(&secondary);

        do {
            event = wait_next_event();
            if ((event.event = TIMER_EXPIRED) &&
                (event.data = timer_id)) {
                again = 0;
                break;
            }
        } while(event.event != ONE_SECOND_ELAPSED);
    } while (again);

    timer_stop(timer_id);
}
*/

/******************************************************************************
 *
 ******************************************************************************/

void ClockDisplay(void)
{
    event_t event;
    time_t time;
    date_t date;
    uint8_t am_pm;
    clock_mode_t display_mode = MODE_CLOCK_24;
    clock_mode_t clock_mode = MODE_CLOCK_24;

//  nixie_out('\f',&primary);
    nixie_out('\f',&secondary);

    nixie_show_stream(&primary);

    do {
        switch (display_mode) {
            case MODE_CLOCK_12 :
                get_time_12(&time, &am_pm);
                am_pm = am_pm ? 'X' : 'x';
                fprintf_P(&secondary, PSTR("\r%2u.%02u.%02u%c"),
                    time.hour, time.minute, time.second, am_pm);
                break;

            case MODE_CLOCK_24 :
                get_time_24(&time);
                fprintf_P(&secondary, PSTR("\r%02u.%02u.%02u"),
                    time.hour, time.minute, time.second);
                break;

            case MODE_DATE :
                get_date(&date);
                date.year %= 100;
                fprintf_P(&secondary, PSTR("\r`xy%02u%02u%02u"),
                    date.month, date.day, date.year);
                break;
        };

        nixie_crossfade(&secondary);

        event = wait_next_event();

        if (event.event == BUTTON0_PRESSED) {
            display_mode = (display_mode == MODE_DATE) ?
                           clock_mode : MODE_DATE;
        }

        else if (event.event == BUTTON5_PRESSED) {
            if ((display_mode == MODE_CLOCK_12) ||
                (display_mode == MODE_CLOCK_24)) {
                if (clock_mode == MODE_CLOCK_12) {
                    clock_mode = MODE_CLOCK_24;
                    fprintf_P(&secondary, PSTR("\f  24"));
                }
                else {
                    clock_mode = MODE_CLOCK_12;
                    fprintf_P(&secondary, PSTR("\f  12"));
                }
                nixie_crossfade(&secondary);
                delay_ms(500);
            }
            display_mode = clock_mode;
        }

        else if (event.event == BUTTON1_LONG) {
            TerminalMode();
        }
    } while (1);
}       
