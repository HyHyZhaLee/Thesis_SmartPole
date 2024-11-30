#ifndef LIGHT_CONTROL_H
#define LIGHT_CONTROL_H
#include "globals.h"

class LightControl{
  private:
    String station_id;
    String station_name;
    String action;
    String device_id;
    
    String from;
    String to;
    String dimming;

  public:
    LightControl(){};
    LightControl(String strJson);
    LightControl(DynamicJsonDocument& doc);
    LightControl(
      String station_id, 
      String station_name, 
      String action, 
      String device_id, 
      String from,
      String to,
      String dimming
    ) : station_id(station_id), 
        station_name(station_name), 
        action(action), 
        device_id(device_id), 
        from(from), 
        to(to), 
        dimming(dimming)  {}
    ~LightControl(){};
    String getStationId(){ return station_id; }
    void setStationId(String station_id){ this->station_id = station_id; }
    String getStationName(){ return station_name; }
    void setStationName(String station_name){ this->station_name = station_name; }
    String getAction(){ return action; }
    void setAction(String action){ this->action = action; }
    String getDeviceId(){ return device_id; }
    void setDeviceId(String device_id){ this->device_id = device_id; }
    void setFrom(String from){ this->from = from; }
    String getFrom(){ return from; }
    void setTo(String to){ this->to = to; }
    String getTo(){ return to; }
    void setDimming(String dimming){ this->dimming = dimming; }
    String getDimming(){ return dimming; }
    String genStringFromJson();
    void publish(String feedName);
  };

#endif