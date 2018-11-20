/**
 * WIFI code
 */
 #include <StaticThreadController.h>
#include <Thread.h>
#include <ThreadController.h>
#include <ESP8266WiFi.h>
#include "SocketIOClient.h"
#include <Wire.h>
#include <ADXL345.h>

SocketIOClient socket;
extern String UID;
extern String Rcontent;

//change per device
const char* ID = "subject_1";
//server credentials
const char* ssid = "ESP8266 Access Point";
const char* password = "thereisnospoon";

// Server address and port
char server[] = "http://esp8266.local";
int port = 81;

//Threads:
Thread* thread_sensorHandler;
Thread* thread_socketHandler;
ThreadController threadController;

//Accelerometer
ADXL345 adxl;

void setup() {
  Serial.begin(115200);
  delay(5000);

//setup a socket connection
Serial.println("Setting up connection with Server...");
WiFi.mode(WIFI_STA);
WiFi.begin(ssid, password);
Serial.println("Connected!");

//start accelerometer
wire.begin(D2, D1);
Serial.println("Starting Accelerometer...");
adxl.powerOn();
Serial.println("Accelerometer started");

//start Threads:
//Thread for Sensors
Serial.println("Starting Threads...");
 thread_sensorHandler = new Thread();
  thread_sensorHandler->enabled = true;
  thread_sensorHandler->setInterval(50); //interval time
  thread_sensorHandler->onRun(sensorHandler);

  //manager for the webSocket
  thread_socketHandler = new Thread();
  thread_socketHandler->enabled = true;
  thread_socketHandler->setInterval(50);
  thread_socketHandler->onRun(socketHandler);

  //add a threadController
  threadController = ThreadController();
  threadController.add(thread_sensorHandler);
  threadController.add(thread_socketHandler);
  Serial.println("Threads started");
  Serial.println("Setup Complete");
}

void loop() {
 threadController.run();
}
String getID() {
  String out = "";
  out += "I";
  out += ID;
  return out;
}

