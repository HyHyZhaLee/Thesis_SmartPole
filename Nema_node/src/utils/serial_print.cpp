#include "serial_print.h"


void printData(String FeedName, String message)
{
  #ifdef _DEBUG_MODE_
    Serial.print(message);
  #endif

}

void printlnData(String FeedName, String message)
{
  #ifdef _DEBUG_MODE_
    Serial.println(message);
  #endif

}