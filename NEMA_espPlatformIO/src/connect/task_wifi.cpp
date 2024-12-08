#include "task_wifi.h"
void taskWifi(void *pvParameters)
{
    addTaskToWatchdog(NULL);
    WiFi.mode(WIFI_STA);
    String ssid = WIFI_SSID;
    String password = WIFI_PASS;
    WiFi.begin(ssid.c_str(), password.c_str());

    while (WiFi.status() != WL_CONNECTED)
    {
        printlnData(MQTT_FEED_NOTHING, "Connecting to WiFi");
        vTaskDelay(delay_wifi / portTICK_PERIOD_MS);
    }

    printlnData(MQTT_FEED_NOTHING, "Connected to WiFi");

    while (true)
    {
        if (WiFi.status() != WL_CONNECTED)
        {
            WiFi.disconnect();
            WiFi.begin(ssid.c_str(), password.c_str());

            while (WiFi.status() != WL_CONNECTED)
            {
                printlnData(MQTT_FEED_NOTHING, "Reconnecting to WiFi...");
                vTaskDelay(delay_wifi / portTICK_PERIOD_MS);
            }
            printlnData(MQTT_FEED_NOTHING, "Reconnected to WiFi...");
        }
        resetWatchdog();
        vTaskDelay(delay_wifi / portTICK_PERIOD_MS);
    }
    
    removeTaskFromWatchdog(NULL);
    vTaskDelete(NULL);
}

void wifi_init()
{
    xTaskCreate(taskWifi, "TaskWifi", 4096, NULL, 1, NULL);
}