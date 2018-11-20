String message = "";
void sensorHandler() {
 //do nothing
 message += getID();
 message += getAccelData();
 message += getHeartData();
 
}
void socketHandler() {
  //send the packet
  Serial.print("Message is: ");
  Serial.println(message);
  socket.sendMessage(message);
  message = "";
}

