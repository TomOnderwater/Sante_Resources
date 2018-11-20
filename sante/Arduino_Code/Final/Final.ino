#include <Wire.h>
#include <StaticThreadController.h>
#include <Thread.h>
#include <ThreadController.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <WebSocketsClient.h>
#include <Hash.h>
#include <ESP8266WebServer.h>

ESP8266WiFiMulti WiFiMulti;
WebSocketsClient webSocket;
bool isConnected = false;

#define DEBUG true
#define Serial if(DEBUG)Serial

//---------------------------START OF ACCEL---------------------------------

#define DEVICE (0x53) // Device address as specified in data sheet
float last_value = 0;
float prelast_value = 0;

int show_count = 0; 
int trigger_count = 0;
float trigger_value = -5; //DEFAULT VALUE ???
float current_value = 0;

#define ADXL345_MG2G_MULTIPLIER (0.004)
#define SENSORS_GRAVITY_STANDARD          (SENSORS_GRAVITY_EARTH)
#define SENSORS_GRAVITY_EARTH             (9.80665F)              /**< Earth's gravity in m/s^2 */

byte _buff[6];
char POWER_CTL = 0x2D;    //Power Control Register
char DATA_FORMAT = 0x31;
char DATAX0 = 0x32;    //X-Axis Data 0
char DATAX1 = 0x33;    //X-Axis Data 1
char DATAY0 = 0x34;    //Y-Axis Data 0
char DATAY1 = 0x35;    //Y-Axis Data 1
char DATAZ0 = 0x36;    //Z-Axis Data 0
char DATAZ1 = 0x37;    //Z-Axis Data 1

float max_x=0;
float min_x=0;
float cal_x, cal_y, cal_z =0;
float x = 0;

//-----------------------------END OF ACCEL-----------------------------------
//Threads:
Thread* thread_sensorHandler;
Thread* thread_socketHandler;
ThreadController threadController;

//ID
String ID = "5";


void setup() {
  //wait for beginning the calibration should be 10000
  delay(1000);
  
Serial.begin(115200);
//Setup the accelerometer
setupAccel();
//setup the threads
setupThreads(); 
//setup the WebSocket 
setupSocket();
}

void loop() {
  threadController.run();
}

