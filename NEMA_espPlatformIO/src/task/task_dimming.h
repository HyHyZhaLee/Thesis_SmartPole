#ifndef TASK_DIMMING_H
#define TASK_DIMMING_H

#include "globals.h"

void setupPWM(int);
void DimmingLight(int);
void taskTestDimming(void *pvParameters);

#endif // TASK_DIMMING_H