/*------------------------------------------------------------------------------
Name:       event.h
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       17-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    Event queue management
------------------------------------------------------------------------------*/

#ifndef EVENT_H
#define EVENT_H

#define EVENT_QUEUE_SIZE    16

//------------------------------------------------------------------------------

// Event types
//
// Note: The scan_for_events() function assumes a specific ordering of event
// types.  Do not change the order in which event types are declared here
// without first checking and modifying scan_for_events().

typedef enum {
    NO_EVENT,
    BUTTON0_PRESSED,
    BUTTON0_RELEASED,
    BUTTON0_SHORT,
    BUTTON0_LONG,
    BUTTON1_PRESSED,
    BUTTON1_RELEASED,
    BUTTON1_SHORT,
    BUTTON1_LONG,
    BUTTON2_PRESSED,
    BUTTON2_RELEASED,
    BUTTON2_SHORT,
    BUTTON2_LONG,
    BUTTON3_PRESSED,
    BUTTON3_RELEASED,
    BUTTON3_SHORT,
    BUTTON3_LONG,
    BUTTON4_PRESSED,
    BUTTON4_RELEASED,
    BUTTON4_SHORT,
    BUTTON4_LONG,
    BUTTON5_PRESSED,
    BUTTON5_RELEASED,
    BUTTON5_SHORT,
    BUTTON5_LONG,
    RIGHT_BUTTON_PRESSED,
    RIGHT_BUTTON_RELEASED,
    RIGHT_BUTTON_SHORT,
    RIGHT_BUTTON_LONG,
    LEFT_BUTTON_PRESSED,
    LEFT_BUTTON_RELEASED,
    LEFT_BUTTON_SHORT,
    LEFT_BUTTON_LONG,

    RIGHT_ROTARY_MOVED,
    LEFT_ROTARY_MOVED,

    TIMER_EXPIRED,
    ONE_SECOND_ELAPSED
} event_id;

typedef struct {
    event_id event;
    union {
        uint8_t data;
        int8_t signed_data;
    };
} event_t;

//------------------------------------------------------------------------------

void clear_events(void);
void add_event(event_id event, uint8_t data);
event_t get_next_event(void);
event_t wait_next_event(void);

#endif  // EVENT_H
