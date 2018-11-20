void webSocketEvent(WStype_t type, uint8_t * payload, size_t length) {

  switch(type) {
    case WStype_DISCONNECTED:
      Serial.printf("[WSc] Disconnected!\n");
      break;
    case WStype_CONNECTED: {
      Serial.printf("[WSc] Connected to url: %s\n", payload);

      // send message to server when Connected
      webSocket.sendTXT("Connected");
    }
      break;
    case WStype_TEXT:
      Serial.printf("[WSc] get text: %s\n", payload);

      // send message to server
      // webSocket.sendTXT("message here");
      break;
    case WStype_BIN:
      Serial.printf("[WSc] get binary length: %u\n", length);
      hexdump(payload, length);

      // send data to server
      // webSocket.sendBIN(payload, length);
      break;
  }
}
void setupSocket() {
  WiFiMulti.addAP("Sante", "hallotesters");
  
  //timeOut = millis();
  //WiFi.disconnect();
  while (WiFiMulti.run() != WL_CONNECTED) {
    Serial.println("Connecting.");
    delay(100);
    //Serial.print("...");
  }
  isConnected = true;
  Serial.println("Connected");
  //192.168.1.158
  webSocket.begin("192.168.1.158", 8020, "/Sante");
  webSocket.onEvent(webSocketEvent);
 
//  if (WL_CONNECTED) {
//    Serial.println("Connected!");
//    //isConnected = true;
//    delay(500);
//    Serial.println("Setting up Socket...");
//
//   // webSocket.beginSocketIO("ws://169.254.55.39:8025/Sante",8025);
//   
//    webSocket.begin("192.168.1.158", 8025, "/Sante");
//    //webSocket.begin("169.254.55.39", 8025, "ws://169.254.55.39:8025/Sante");
//    //webSocket.setAuthorization("user", "Password"); // HTTP Basic Authorization
//    webSocket.onEvent(webSocketEvent);
//    Serial.print("Websocket connected!");
//  }
}

