#include <StaticThreadController.h>
#include <Thread.h>
#include <ThreadController.h>
#include <SoftwareSerial.h>

//room for defines
#define BATTERYPIN  2
#define USBPIN 12
//room for variables

//softwareSerial
SoftwareSerial bluetooth(10, 11); //RX, TX

//RTC needs a real rtc component
int year, month, day, hour, minute, second, millisecond;

//room for threads
Thread* thread_sensorHandler;
Thread* thread_batteryLevelHandler;

ThreadController threadController;

void setup() {  
  Serial.begin(115200);

  //increase speed if 9600 is insufficient
  bluetooth.begin(9600);

  //setup 
  pinMode(BATTERYPIN, OUTPUT);
  pinMode(USBPIN, INPUT);
  //HEARTBEAT
  thread_sensorHandler = new Thread();
  thread_sensorHandler->enabled = true;
  thread_sensorHandler->setInterval(25); //interval time
  thread_sensorHandler->onRun(sensorHandler);

  //manager for the battery level, needs low frequency
  thread_batteryLevelHandler = new Thread();
  thread_batteryLevelHandler->enabled = true;
  thread_batteryLevelHandler->setInterval(1000);
  thread_batteryLevelHandler->onRun(batteryLevelHandler);

  //add a threadController
  threadController = ThreadController();
  threadController.add(thread_sensorHandler);
  threadController.add(thread_batteryLevelHandler);

  //begin the RTC
 setupRTC();
}
void loop(){
  threadController.run();
}

