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

//------------------------------------------------------------------------------

const char hello[] PROGMEM = "NixieClock v1.00 (a Deep Bondi thing)";

const char player_test[] PROGMEM = "M8:O1[0:7:CNQ^DEFGAB>]0:CW";

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

int main(void)
{

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
    delay_us(1000);         // Needed for FTDI USB-serial IC stabilization?

    // Assign stdio file handles to use serial port
    // Note: serial_f is declared in serial.c/.h

    stdin = &serial_f;
    stdout = &serial_f;
    stderr = &serial_f;

    // Set up nixie display streams

    nixie_stream_init(&primary, &primary_stream, primary_data);
    nixie_stream_init(&secondary, &secondary_stream, secondary_data);
    nixie_show_stream(&primary);

    // Ok to enable interrupts now

    sei();

    // Send sign-on message to serial port

    printf_P(PSTR("\r\n%S\r\n"), hello);

/* Music player test

    player_init(player_test, MEM_PGM);

    do {
        player_service();
        delay_us(4900);
    } while (!player_is_stopped());
*/

/* Button manager test

    button_t state, pressed, released, bshort, blong;
    do {
        state = read_button_state();
        pressed = read_buttons_pressed();
        released = read_buttons_released();
        bshort = read_short_buttons();
        blong = read_long_buttons();

        serial_binary(state.all);
        serial_out(' ');
        serial_binary(pressed.all);
        serial_out(' ');
        serial_binary(released.all);
        serial_out(' ');
        serial_binary(bshort.all);
        serial_out(' ');
        serial_binary(blong.all);
        serial_out('\r');

        if (serial_in() == ' ') {
            pressed = reset_buttons_pressed();
            released = reset_buttons_released();
            bshort = reset_short_buttons();
            blong = reset_long_buttons();
            serial_out('\n');
        }
    } while (1);
*/

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
