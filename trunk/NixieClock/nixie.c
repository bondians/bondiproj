/*------------------------------------------------------------------------------
Name:       nixie.c
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

/*------------------------------------------------------------------------------
Digit/segment layout for TubeClock:

Offset   |0               9| |10             19|   |21             30|   |32             41|   |43             52| |53             62| |63
Digit    |    Leftmost 0   | |        1        |   |        2        |   |        3        |   |        4        | |   Rightmost 5   |
Segment  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 p 0 1 2 3 4 5 6 7 8 9 x 0 1 2 3 4 5 6 7 8 9 p 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 x
Byte #   |      0      | |      1      | |      2      | |      3      | |      4      | |      5      | |      6      | |      7      |
Bit #    7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0
------------------------------------------------------------------------------*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

#include "portdef.h"
#include "nixie.h"

uint8_t nixie_segment[NUM_NIXIE_SEGMENTS];

uint8_t *nixie_segment_ptr;

// Segment/drive line offsets for start of each nixie tube display element

static const uint8_t nixie_digit_offset[NIXIE_DISPLAY_WIDTH+2] PROGMEM =
  {0, 10, 21, 32, 43, 53, 20, 42};
// 0   1   2   3   4   5  LL  RL
// LL,RL = Left/Right lamp "decimal points"

/******************************************************************************
 *
 ******************************************************************************/

void nixie_display_init(void)
{
    nixie_segment_ptr = &nixie_segment[0];
}

/******************************************************************************
 *
 ******************************************************************************/

void set_nixie_segment(uint8_t digit, uint8_t segment, uint8_t intensity)
{
    uint8_t index;

    index = pgm_read_byte(&nixie_digit_offset[digit]) + segment;
    nixie_segment_ptr[index] = intensity;
}

/******************************************************************************
 *
 ******************************************************************************/

void clear_nixie_digit(uint8_t digit)
{
    uint8_t *p;
    uint8_t count;

    p = nixie_segment_ptr + pgm_read_byte(&nixie_digit_offset[digit]);
    for (count = NIXIE_SEGMENTS_PER_DIGIT; count; count--) {
        *p = 0;
        p++;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

void nixie_display_refresh(void)
{
    static uint8_t intensity_count;     // Intensity counter, goes from 0..MAX_NIXIE_INTENSITY, incremented every entry
    register uint8_t segment_index;     // Iterator to index segment intensity array, 0..NUM_NIXIE_SEGMENTS
    register uint8_t nixie_data;        // Data accumulator, sent to SPI, 8 bits of segment on/off data
    register uint8_t bit_mask;          // ORed into nixie_data if a given segment should be ON

    // Set initial values for the segment bit-on mask and SPI data accumulator

    bit_mask = 0x01;
    nixie_data = 0x00;

    // Build and shift out via SPI 64 bits (NUM_NIXIE_SEGMENTS) worth of
    // nixie segment on/off data

    for (segment_index = 0; segment_index < NUM_NIXIE_SEGMENTS; segment_index++) {

        // A given nixie display segment should be ON for this PWM sub-cycle
        // if its intensity setting is greater than the current sub-cycle
        // count, which cycles from 0..MAX_NIXIE_INTENSITY and is incremented
        // on every entry into the ISR.

        if (nixie_segment_ptr[segment_index] > intensity_count) {
            // Turn nixie segment on for this PWM subcycle
            nixie_data |= bit_mask;
        }

        if (bit_mask & 0x80) {

            // 8 bits of segment data have been processed
            // Send the data to the display driver via SPI, and reset data
            // accumulator and bit-on mask for the next 8 bits of data to
            // send out.

            while (!(SPSR & BM(SPIF))); // Wait for previous byte to finish shifting out
            SPDR = nixie_data;
            bit_mask = 0x01;
            nixie_data = 0x00;
        }

        else {

            // Advance bit-on mask for the next display segment

            bit_mask <<= 1;
        }
    }

    // Display driver has all 64 bits of data it needs
    // Pulse latch-data pin on display driver

    while (!(SPSR & BM(SPIF))); // Wait for last byte to finish shifting out
    BSET(DRIVER_LATCH);
    BCLR(DRIVER_LATCH);

    // Increment intensity counter for next display PWM sub-cycle
    // When this count exceeds the max intensity setting, reset it to 0

    intensity_count++;
    if (intensity_count >= MAX_NIXIE_INTENSITY) {
        intensity_count = 0;
   }

}
