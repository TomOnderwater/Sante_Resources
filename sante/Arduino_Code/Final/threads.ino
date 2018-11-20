String message = "";
void sensorHandler() {
  //do nothing
  message += ID;
  message += ",";
  message += getAccel();
  message += ",";
  message += getHeart();
}
void socketHandler() {
  //send the packet
  if (isConnected) {
    webSocket.loop();
  }
  Serial.print("Message is: ");
  Serial.println(message);
  if (isConnected) {
    webSocket.sendTXT(message);
  } 
  message = "";
}


void setupThreads() {
  Serial.println("Starting Threads...");
  thread_sensorHandler = new Thread();
  thread_sensorHandler->enabled = true;
  thread_sensorHandler->setInterval(25); //interval time
  thread_sensorHandler->onRun(sensorHandler);

  //manager for the webSocket
  thread_socketHandler = new Thread();
  thread_socketHandler->enabled = true;
  thread_socketHandler->setInterval(25);
  thread_socketHandler->onRun(socketHandler);

  //add a threadController
  threadController = ThreadController();
  threadController.add(thread_sensorHandler);
  threadController.add(thread_socketHandler);
  Serial.println("Threads started");
  Serial.println("Setup Complete");
}

