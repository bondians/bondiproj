/*------------------------------------------------------------------------------
Name:       main.c
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       24-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    Main program
------------------------------------------------------------------------------*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/wdt.h>
#include <avr/eeprom.h>
#include <string.h>
#include <stdio.h>

#include "portdef.h"
#include "delay.h"
#include "spi.h"
#include "serial.h"
#include "rotary.h"
#include "button.h"
#include "timer.h"
#include "nixie.h"
#include "player.h"
#include "event.h"
#include "clock.h"

//------------------------------------------------------------------------------

const char hello[] PROGMEM = "NixieClock v1.00 (a Deep Bondi thing)";

const char player_test[] PROGMEM = "TQ:120:M8:O4[0:3:CQDEFGAB>]0:CW";

//------------------------------------------------------------------------------

FILE            primary;
nixie_stream_t  primary_stream;
uint8_t         primary_data[NIXIE_SEGMENTS];

FILE            secondary;
nixie_stream_t  secondary_stream;
uint8_t         secondary_data[NIXIE_SEGMENTS];

/******************************************************************************
 *
 ******************************************************************************/

extern uint16_t player_export;

void getstr(char *str, uint8_t max_len)
{
    char ch;
    int c;
    uint8_t index;

    if (!max_len) {
        *str = 0;
        return;
    }

    max_len--;
    index = 0;
 
    do {
        do {
            c = serial_in();
        } while (c < 0);
        ch = c;

        if (ch == '\r') {
            str[index] = 0;
            serial_crlf();
            break;
        }

        if (ch == '\b') {
            if (index) {
                index--;
                serial_out('\b');
                serial_out(' ');
                serial_out('\b');
            }
            continue;
        }

        if (ch < 0x20) {
            continue;
        }

        if (index < max_len) {
            str[index] = ch;
            serial_out(ch);
            index++;
        }
    } while (1);
 
    str[index] = 0;
}

/******************************************************************************
 *
 ******************************************************************************/

int main(void)
{
    event_t event;
    time_t time;
    date_t date;

    // Initialize I/O's

    DDRB = 0b00101111;
    DDRC = 0b00000001;
    DDRD = 0b00000010;

    PORTB = 0b00000000;
    PORTC = 0b00111111;
    PORTD = 0b00001100;

    TCCR1A = 0b00000000;
    TCCR1B = 0b00000000;

    // Initialize peripherals

    spi_init();
    serial_init(38400, IN_OUT_INT);
    rotary_init();
    timer_init();
    beeper_init();
    clock_run(1);
    delay_us(1000);         // Needed for FTDI USB-serial IC stabilization?

    // Set default time & date

    time.hour = 12;
    time.minute = 0;
    time.second = 0;
    set_time_24(&time);

    date.day = 1;
    date.month = 1;
    date.year = 2009;
    set_date(&date);
    
    // Assign stdio file handles to use serial port
    // Note: serial_f is declared in serial.c/.h

    stdin = &serial_f;
    stdout = &serial_f;
    stderr = &serial_f;

    // Set up nixie display streams

    nixie_stream_init(&primary, &primary_stream, primary_data);
    nixie_stream_init(&secondary, &secondary_stream, secondary_data);
    nixie_show_stream(&primary);
    nixie_display_enable(1);

    // Ok to enable interrupts now

    sei();

    // Send sign-on message to serial port

    printf_P(PSTR("\r\n%S\r\n"), hello);

    // Player test

    player_start(player_test, PLAYER_MEM_PGM);
    static char str[41];
    do {
        getstr(str, 40);
        player_start(str, PLAYER_MEM_RAM);
    } while (*str != '/');

    // Crossfade test

    fprintf_P(&primary, PSTR("~123*5456~\r"));
    fprintf_P(&secondary, PSTR("*5654~321\r"));
    delay_ms(1000);
    nixie_crossfade(&secondary);
    nixie_out('\f', &secondary);
    delay_ms(1000);
    nixie_crossfade(&secondary);
    delay_ms(1000);

    // Clock display test

    do {
        get_time_24(&time);
        fprintf_P(&secondary, PSTR("\r%02u.%02u.%02u"), time.hour, time.minute, time.second);
        nixie_crossfade(&secondary);

        do {
            event = wait_next_event();
        } while (event.event != ONE_SECOND_ELAPSED);
    } while (1);
        
/*
    event_t event;
    uint8_t timer_id;
    uint32_t count = 0;

    timer_id = timer_start(MS_TO_TICKS(5000), 1);

    do {
        event = get_next_event();
        if (event.event != NO_EVENT) {
           printf_P(PSTR("Event:%02u (%02X)  Data:%4d (%02X)\r\n"),
                  event.event, event.event, (int8_t) event.data, event.data);
        }

        fprintf_P(&primary, PSTR("%06lu\r"), count);
        count++;
        if (count > 999999) {
            count = 0;
        }
    } while (1);
*/

/* Nixie output test

    int16_t ch;
    do {
        do {
            ch = serial_in();
        } while (ch  < 0);
        serial_out(ch);
        nixie_out(ch, &primary);
    } while (1);
*/
}
