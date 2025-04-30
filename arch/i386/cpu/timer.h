#ifndef TIMER_H
#define TIMER_H

#include "../../../include/types.h"

void init_timer(u32 freq);

extern volatile u32 tick;

#endif
