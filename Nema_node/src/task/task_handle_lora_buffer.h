#ifndef TASK_HANDLE_LORA_BUFFER_H
#define TASK_HANDLE_LORA_BUFFER_H

#include "globals.h"

struct process_ack_waitting
{
  int timer_factor = LORA_TIMER_FACTOR_MSG_RESEND;
  int counter_resend = LORA_MAX_TIMES_RESEND;
  bool is_recv_ack = false;
  LightControl device;

  process_ack_waitting(int timer, int resend, bool recv, const LightControl& ctl)
        : timer_factor(timer), counter_resend(resend), is_recv_ack(recv), device(ctl) {}
};

struct ack_recved_list
{
  String device_id;
  String dimming;
};

extern std :: vector<String> lora_buffer;
extern std :: vector<process_ack_waitting> lora_waiting_ack_list;
void taskHandleLoraBuffer(void *pvParameter);

#endif // TASK_HANDLE_LORA_BUFFER_H