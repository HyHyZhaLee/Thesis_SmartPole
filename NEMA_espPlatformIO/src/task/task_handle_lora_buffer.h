#ifndef TASK_HANDLE_LORA_BUFFER_H
#define TASK_HANDLE_LORA_BUFFER_H

#include "globals.h"

struct process_ack_waitting
{
  int timer_factor = LORA_TIMER_FACTOR_MSG_RESEND;
  int counter_resend = LORA_MAX_TIMES_RESEND;
  // bool recved_ack = false;
  String deviceId;
  String deviceDimming;

  process_ack_waitting(int timer, int resend, String deviceId, String deviceDimming)
        : timer_factor(timer), counter_resend(resend), deviceId(deviceId), deviceDimming(deviceDimming) {}
};

extern SemaphoreHandle_t semaphoreLora;
extern std :: vector<String> lora_buffer;
extern std :: vector<process_ack_waitting> lora_waiting_ack_list;
void taskHandleLoraBuffer(void *pvParameter);
void taskWaitingAckProcess(void *pvParameter);
#endif // TASK_HANDLE_LORA_BUFFER_H