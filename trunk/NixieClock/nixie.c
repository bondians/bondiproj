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

/*------------------------------------------------------------------------------
Display character mode output controls:

Segment control (displayable characters):

0..9    Turn on segment 0-9 at cursor
A..I    Turn on segments 0 & 1..9
a..i    Same as A..I
<space> Turn off all segments at cursor

Note: All segment-output characters will auto-advance the cursor if cursor
auto-advance is enabled.  Previously-enabled segments at the cursor are
overwritten by the new segment pattern specified by the character unless
overlay mode is enabled, in which case the new segment pattern is ORed into
the existing one.

Neon lamp control:

<       Turn on left neon lamp
>       Turn on right neon lamp
(       Turn off left neon lamp
)       Turn off right neon lamp
`       Turn off both neon lamps
.       Turn on neon lamp to left of cursor
,       Turn on neon lamp to right of cursor

Intensity controls:

[       Decrease intensity of subsequent segments output by 1
]       Increase intensity of subsequent segments output by 1
*n      Set intensity of subsequent segments output to <n>.  n = '0'..'9'.
        Command is ignored if <n> is not an ASCII digit character.
~       Set intensity to nominal level

Cursor control:

$       Normal cursor mode, auto-advance after digit output
#       Static cursor mode, cursor stays at current position
&       Normal output mode, previous segments overwritten by new
|       Overlay mode, new segments overlay existing ones

@n      Move cursor to digit position <n>.  n = '0'..'6'.
        Command is ignored if <n> does not represent a valid display position.
        Note: Display position '6' is 'off the right edge'
{       Disable cursor wrap mode.  Cursor can advance past right side of display.
        If cursor is in the off-right-edge position, subsequent displayable
        characters will not be displayed.  Attempts to move the cursor past the
        left edge of the display will be ignored.        
}       Enable cursor wrap mode.  Cursor will move to leftmost digit if advanced
        past the rightmost digit, or move to rightmost digit if backed up past
        the leftmost digit.

Next character behavior-modification controls:

!       Next character does NOT advance cursor (single overwrite mode)
_       Next character will overlay existing segments (single overlay mode)
^       Move cursor left 1 digit, activate single overlay mode

Note: "Single" controls affect the next DISPLAYABLE (e.g. segment-controlling)
character.  Characters that perform control functions that occur in the output
stream following a single-mode control character will NOT turn off the
single-mode function.

Cursor movement, display clear, miscellaneous:

^L \f   Clear display, move cursor to leftmost digit
^M \r   Move cursor to leftmost digit
^J \n   Clear display but do not move cursor
^H \b   Move cursor to the left one digit (decrement)
^I \t   Move cursor to the right one digit (increment)
^K \v   Partial display reset - set intensity to nominal, turn off overlay mode
        (single and global), enable cursor auto-advance.  Does not affect
        cursor position or clear display.

Any character output that is not in the above list will be ignored.
------------------------------------------------------------------------------*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <stdio.h>

#include "portdef.h"
#include "nixie.h"

//------------------------------------------------------------------------------

static uint8_t *nixie_segment_ptr;

//------------------------------------------------------------------------------

// Segment/drive line offsets for start of each nixie tube display element

static const uint8_t nixie_digit_offset[] PROGMEM =
  {0, 10, 21, 32, 43, 53, 20, 42, 31, 63};
// 0   1   2   3   4   5  LL  RL  AA  AB
// LL,RL = Left/Right lamp "decimal points"

/******************************************************************************
 *
 ******************************************************************************/

void nixie_display_refresh(void)
{
    static uint8_t intensity_count;     // Intensity counter, goes from 0..MAX_NIXIE_INTENSITY, incremented every entry
    register uint8_t segment_index;     // Iterator to index segment intensity array, 0..NIXIE_SEGMENTS
    register uint8_t nixie_data;        // Data accumulator, sent to SPI, 8 bits of segment on/off data
    register uint8_t bit_mask;          // ORed into nixie_data if a given segment should be ON

    // Set initial values for the segment bit-on mask and SPI data accumulator

    bit_mask = 0x01;
    nixie_data = 0x00;

    // Build and shift out via SPI 64 bits (NIXIE_SEGMENTS) worth of
    // nixie segment on/off data

    for (segment_index = 0; segment_index < NIXIE_SEGMENTS; segment_index++) {

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

/******************************************************************************
 *
 ******************************************************************************/

void nixie_show_stream(FILE *stream)
{
    nixie_segment_ptr = ((nixie_stream_t *) stream->udata)->segdata;
}

/******************************************************************************
 *
 ******************************************************************************/

static void clear_nixie_display(uint8_t *segdata)
{
    uint8_t count;

    for (count = NIXIE_SEGMENTS; count; count--) {
        *segdata = 0;
        segdata++;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

static void clear_nixie_digit(uint8_t *segdata, uint8_t digit)
{
    uint8_t count;

    segdata += pgm_read_byte(&nixie_digit_offset[digit]);
    for (count = NIXIE_SEGMENTS_PER_DIGIT; count; count--) {
        *segdata = 0;
        segdata++;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

static void set_nixie_segment(uint8_t *segdata, uint8_t digit, uint8_t segment, uint8_t intensity)
{
    segdata += pgm_read_byte(&nixie_digit_offset[digit]) + segment;
    *segdata = intensity;
}

/******************************************************************************
 *
 ******************************************************************************/

static void nixie_control_init(nixie_stream_t *p)
{
    clear_nixie_display(p->segdata);
    p->cursor = 0;
    p->intensity = MAX_NIXIE_INTENSITY;
    p->control.all = 0;
    p->state = NORMAL_OUTPUT;
}

/******************************************************************************
 *
 ******************************************************************************/

void nixie_stream_init(FILE *stream, nixie_stream_t *control, uint8_t *segdata)
{
    stream->put = &nixie_out;
    stream->get = NULL;
    stream->flags = _FDEV_SETUP_WRITE;
    stream->udata = control;

    ((nixie_stream_t *) (stream->udata))->segdata = segdata;

    nixie_control_init(control);
}

/******************************************************************************
 *
 ******************************************************************************/

static void inc_cursor(nixie_stream_t *stream, uint8_t char_mode)
{
    if (char_mode) {
        if (stream->control.no_cursor_inc || stream->control.single_no_inc) {
            stream->control.single_no_inc = 0;
            return;
        }
    }

    stream->cursor++;

    if (stream->control.no_cursor_wrap) {
        if (stream->cursor > NIXIE_DISPLAY_WIDTH) {
            stream->cursor = NIXIE_DISPLAY_WIDTH;
        }
    }
    else if (stream->cursor >= NIXIE_DISPLAY_WIDTH) {
        stream->cursor = 0;
    }
}

/******************************************************************************
 *
 ******************************************************************************/

static void dec_cursor(nixie_stream_t *stream)
{
    stream->cursor--;

    if (stream->cursor & 0x80) {
        if (stream->control.no_cursor_wrap) {
            stream->cursor = 0;
        }
        else {
            stream->cursor = NIXIE_DISPLAY_WIDTH - 1;
        }
    }
}

/******************************************************************************
 *
 ******************************************************************************/

int16_t nixie_out(char ch, FILE *stream)
{
    register nixie_stream_t *p;
    uint8_t char_type;

    p = stream->udata;

    // If previous command requires a parameter digit, interpret next
    // character as a parameter and set value according to previous
    // character sent.

    if (p->state != NORMAL_OUTPUT) {
        ch -= '0';

        if (p->state == SET_INTENSITY) {
            if (ch <= MAX_NIXIE_INTENSITY) {
                p->intensity = ch;
            }
        }
 
        else if (p->state == SET_CURSOR_POS) {
            if (ch <= NIXIE_DISPLAY_WIDTH) {
                p->cursor = ch;
            }
        }

        p->state = NORMAL_OUTPUT;
        return 0;
    }

    // Determine if character is displayable
    // char_type = 0 : Not displayable
    // char_type = 1 : Single digit
    // char_type = 2 : Single digit plus '0' segment
    // char_type = 3 : Space

    char_type = 0;
    if ((ch >= '0') && (ch <= '9'))  {
        char_type = 1;
        ch -= '0';
    }
    else if ((ch >= 'A') && (ch <= 'I')) {
        char_type = 2;
        ch -= 'A';
    }
    else if ((ch >= 'a') && (ch <= 'i')) {
        char_type = 2;
        ch -= 'a';
    }
    else if (ch == ' ') {
        char_type = 3;
    }

    // If character is displayable, turn on appropriate segment(s)
    // on the nixie display

    if (char_type) {
        if (p->cursor < NIXIE_DISPLAY_WIDTH) {
            if (! (p->control.overlay || p->control.single_overlay)) {
                clear_nixie_digit(p->segdata, p->cursor);
            }

            if (char_type == 2) {
                set_nixie_segment(p->segdata, p->cursor, 0, p->intensity);
                ch++;
            }
            if (char_type != 3) {
                set_nixie_segment(p->segdata, p->cursor, ch, p->intensity);
            }
        }

        inc_cursor(p, 1);
        p->control.single_overlay = 0;
        return 0;
    }

    // Character is not displayable
    // Check for valid control characters

    switch(ch) {
        case '<' :                      // Turn on left neon lamp
            set_nixie_segment(p->segdata, NIXIE_LEFT_LAMP, 0, p->intensity);
            break;
 
        case '>' :                      // Turn on right neon lamp
            set_nixie_segment(p->segdata, NIXIE_RIGHT_LAMP, 0, p->intensity);
            break;

        case '(' :                      // Turn off left neon lamp
            set_nixie_segment(p->segdata, NIXIE_LEFT_LAMP, 0, 0);
            break;

        case ')' :                      // Turn off right neon lamp
            set_nixie_segment(p->segdata, NIXIE_RIGHT_LAMP, 0, 0);
            break;

        case '`' :                      // Turn off both neon lamps
            set_nixie_segment(p->segdata, NIXIE_LEFT_LAMP, 0, 0);
            set_nixie_segment(p->segdata, NIXIE_RIGHT_LAMP, 0, 0);
            break;

        case '.' :                      // Turn on lamp to left of cursor
            if ((p->cursor == 2) || (p->cursor == 3)) {
                set_nixie_segment(p->segdata, NIXIE_LEFT_LAMP, 0, p->intensity);
            }
            else if (p->cursor > 3) {
                set_nixie_segment(p->segdata, NIXIE_RIGHT_LAMP, 0, p->intensity);
            }
            break;

        case ',' :                      // Turn on lamp to right of cursor
            if ((p->cursor == 0) || (p->cursor == 1)) {
                set_nixie_segment(p->segdata, NIXIE_LEFT_LAMP, 0, p->intensity);
            }
            else if (p->cursor < 4) {
                set_nixie_segment(p->segdata, NIXIE_RIGHT_LAMP, 0, p->intensity);
            }
            break;

        case '[' :                      // Decrease intensity by 1
            if (p->intensity) {
                p->intensity--;
            }
            break;

        case ']' :                      // Increase intensity by 1
            if (p->intensity < MAX_NIXIE_INTENSITY) {
                p->intensity++;
            }
            break;

        case '*' :                      // Set intensity to following digit
            p->state = SET_INTENSITY;
            break;

        case '~' :                      // Set intensity to max/nominal
            p->intensity = MAX_NIXIE_INTENSITY;
            break;

        case '$' :                      // Enable cursor auto-increment
            p->control.no_cursor_inc = 0;
            break;

        case '#' :                      // Disable cursor auto-increment
            p->control.no_cursor_inc = 1;
            break;

        case '!' :                      // Next char does not auto-inc cursor
            p->control.single_no_inc = 1;
            break;

        case '&' :                      // Disable overlay mode
            p->control.overlay = 0;
            break;

        case '|' :                      // Enable overlay mode
            p->control.overlay = 1;
            break;

        case '_' :                      // Next char will overlay
            p->control.single_overlay = 1;
            break;

        case '^' :                      // Dec cursor, next char overlays
            dec_cursor(p);
            p->control.single_overlay = 1;
            break;

        case '@' :                      // Set cursor to absolute position
            p->state = SET_CURSOR_POS;
            break;

        case '{' :                      // Disable cursor auto-wraparound
            p->control.no_cursor_wrap = 1;
            break;

        case '}' :                      // Enable cursor auto-wraparound
            p->control.no_cursor_wrap = 0;
            break;

        case '\f' :                     // Clear display, cursor to left
            clear_nixie_display(p->segdata);
            p->cursor = 0;
            break;

        case '\r' :                     // Move cursor to leftmost digit
            p->cursor = 0;
            break;

        case '\n' :                     // Clear display
            clear_nixie_display(p->segdata);
            break;

        case '\b' :                     // Move cursor left 1 digit
            dec_cursor(p);
            break;

        case '\t' :                     // Move cursor right 1 digit
            inc_cursor(p, 0);
            break;

        case '\v' :                     // Partial display init
            p->intensity = MAX_NIXIE_INTENSITY;
            p->cursor = 0;
            p->control.all = 0;
            break;
    }

    return 0;
}
