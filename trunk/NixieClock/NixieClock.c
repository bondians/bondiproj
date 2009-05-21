/*------------------------------------------------------------------------------
Name:       main.c
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       16-Mar-2009
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
#include "timer.h"
#include "nixie.h"
#include "player.h"

//------------------------------------------------------------------------------

const char hello[] PROGMEM = "NixieClock v1.00 (a Deep Bondi thing)";

//------------------------------------------------------------------------------

/******************************************************************************
 *
 ******************************************************************************/

const char player_test[] PROGMEM = "M8:O1[0:7:CNQ^DEFGAB>]0:CW";

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
    nixie_display_init();
    timer_init();
    beeper_init();
    delay_us(1000);         // Needed for FTDI USB-serial IC stabilization?

    // Assign stdio file handles to use serial port
    // Note: serial_f is declared in serial.c/.h

    stdin = &serial_f;
    stdout = &serial_f;
    stderr = &serial_f;

    // Ok to enable interrupts now

    sei();

    // Send sign-on message to serial port

    printf_P(PSTR("\r\n%S\r\n"), hello);

/*
    player_init(player_test, MEM_PGM);

    do {
        player_service();
        delay_us(4900);
    } while (!player_is_stopped());
*/

    set_nixie_segment(0, 0, 1);
    set_nixie_segment(1, 0, 2);
    set_nixie_segment(2, 0, 4);
    set_nixie_segment(3, 0, 6);
    set_nixie_segment(4, 0, 8);
    set_nixie_segment(5, 0, 9);
    set_nixie_segment(6, 0, 1);
    set_nixie_segment(7, 0, 9);

    int8_t intensity = 1;
    int8_t segment = 0;
    int8_t left, right;
    do {
        do {
            left = left_rotary_relative();
            right = right_rotary_relative();
        } while (!left && !right);
        intensity += left;
        if (intensity < 0) {
            intensity = 0;
        }
        else if (intensity > MAX_NIXIE_INTENSITY) {
            intensity = MAX_NIXIE_INTENSITY;
        }
        if (right) {
            clear_nixie_digit(0);
            segment += right;
            if (segment < 0) {
                segment = 0;
            }
            else if (segment >= NIXIE_SEGMENTS_PER_DIGIT) {
                segment = NIXIE_SEGMENTS_PER_DIGIT - 1;
            }
        }
        set_nixie_segment(0, segment, intensity);
    } while (1);
}
