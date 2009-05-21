#ifndef BEEPER_H
#define BEEPER_H
/*------------------------------------------------------------------------------
Name:       player.h
Project:    NixieClock
Author:     Mark Schultz <n9xmj@yahoo.com>, Daniel Henderson <tindrum@mac.com>
Date:       17-Mar-2009
Tabsize:    4
Copyright:  None
License:    None
Revision:   $Id$
Target CPU: ATmega168/328

Content:    Simple single-note music player, loosely based on IBM/GW BASIC
            interpreter PLAY strings
------------------------------------------------------------------------------*/

// Invocation rate for player_service()

#define PLAYER_TICKS_PER_SECOND  200

// Type definitions

typedef enum {          // Timer prescaler options
    PRESCALE_STOP = 0,  //   Timer stopped 
    PRESCALE_1 = 1,     //   F_CPU / 1
    PRESCALE_8 = 2,     //   F_CPU / 8
    PRESCALE_64 = 3,    //   F_CPU / 64
    PRESCALE_256 = 4,   //   F_CPU / 256
    PRESCALE_1024 = 5,  //   F_CPU / 1024
    PRESCALE_EXT_L = 6, //   External, falling edge
    PRESCALE_EXT_H = 7  //   External, rising edge
} prescale_t;

typedef enum {          // Player string memory space fetch options
    PLAYER_STOP = 0,    //   Stop fetching, always reads as 0
    MEM_RAM = 1,        //   Fetch player string from RAM
    MEM_PGM = 2,        //   Fetch player string from FLASH/program memory
    MEM_EEPROM = 3      //   Fetch player string from EEPROM
} player_space_t;

//------------------------------------------------------------------------------

// Function prototypes

extern void beep_period(uint16_t period, uint8_t prescale);

extern void beep_mute(uint8_t mute);

extern void beep_gain(uint8_t gain);

extern void beeper_init(void);

extern void player_init(const char *str, player_space_t mem_space);

extern uint8_t player_is_stopped(void);

extern void player_service(void);

#endif  // BEEPER_H
