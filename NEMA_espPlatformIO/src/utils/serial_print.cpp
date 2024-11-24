#include "serial_print.h"


void printData(String FeedName, String message)
{
  #ifdef _DEBUG_MODE_
    Serial.print(message);
  #endif
  if (strcmp(FeedName.c_str(), "") != 0)
  {
    publishData(FeedName, message);
  }
}

void printlnData(String FeedName, String message)
{
  #ifdef _DEBUG_MODE_
    Serial.println(message);
  #endif
  if (strcmp(FeedName.c_str(), "") != 0)
  {
    publishData(FeedName, message);
  }
}