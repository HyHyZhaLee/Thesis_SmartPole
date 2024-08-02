#include <M5Atom.h>
#include <ACmearsureHelper.h>

void setup () 
{
    Serial.begin(115200);
    M5.begin(true, false, false);
    while (!(sensor.begin(&Wire, UNIT_ACMEASURE_ADDR, 26, 32, 100000UL)))
    {
        Serial.println("No module!");
    }
    Serial.println("ACmeasure sensor is ready!");
}

void loop () 
{
    updateACinfor();
    if (voltage > 200)
    {
        Serial.println("Have person!");
    } 
    else if (voltage < 100) 
    {
        Serial.println("Empty!");
    } 
    else 
    {
        Serial.println("Unknown!");
    }
    delay(1000);
}