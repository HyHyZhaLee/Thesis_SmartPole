#include <Watch_dog.h>

hw_timer_t *timer = NULL;

void IRAM_ATTR resetModule() {
  ets_printf("Watchdog triggered, resetting...\n");
  esp_restart();
}

void WatchdogInit() {
  // Configure the hardware timer
  timer = timerBegin(0, 80, true);                    // 80 divider to get 1MHz clock, true count up
  timerAttachInterrupt(timer, &resetModule, true);    // Attach the reset function
  timerAlarmWrite(timer, 360000000, false);           // Set the alarm time (6 minutes in microseconds)
  timerAlarmEnable(timer);                            // Enable the alarm
}

