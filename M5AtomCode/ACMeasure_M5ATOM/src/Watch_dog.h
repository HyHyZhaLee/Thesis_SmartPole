#ifndef WATCHDOG_H_
#define WATCHDOG_H_

#include <M5Atom.h>

extern hw_timer_t *timer;
void WatchdogInit();

void IRAM_ATTR resetModule();

#endif