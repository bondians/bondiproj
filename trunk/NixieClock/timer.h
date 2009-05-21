/*------------------------------------------------------------------------------
Name:       timer.h
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       17-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168 or ATmega328

Content:    "Heartbeat" timing ISR, used for RTC, timing functions, and
            nixie display update.  Also includes generic timer functions
------------------------------------------------------------------------------*/

#ifndef TIMER_H
#define TIMER_H

#define TIMER0_PERIOD_TICKS 100
#define TIMER0_PRESCALER    256

#define TIMER0_FREQUENCY    (F_CPU / TIMER_PRESCALER / TIMER_PERIOD_TICKS)

//------------------------------------------------------------------------------

void timer_init(void);

#endif  // TIMER_H

