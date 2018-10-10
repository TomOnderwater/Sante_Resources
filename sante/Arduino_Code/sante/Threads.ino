void sensorHandler() {
  timeHandler();
  String out = "";
  //timestamp
  out+="y";
  out+=year;
  out+="m";
  out+=month;
  out+="d";
  out+=day;
  out+="H";
  out+=hour;
  out+="M";
  out+=minute;
  out+="S";
  out+=second;
  out+="s";
  out+=millisecond;
  
  out += "A";
  out += getHeartBeatValue();
  //bluetooth.print(out);
  //Serial.print(out);
}

void batteryLevelHandler() {
  //turn of charging for accurate measurement
  digitalWrite(BATTERYPIN, LOW);
  //tiny delay for battery to unstress
  delay(1);
  //get measurement
  int batteryLevel = getBatteryLevel();
 //check if USB is connected
 if (USB_Connected()) {
  //start charging if the voltage is below 4V stop if it is above 4.3V
  if (batteryLevel < 4.3f) { digitalWrite(BATTERYPIN, HIGH);}
 }
}

int subSample[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
float getBatteryLevel() {
  //the batteryLevel tends to float a lot, subsample it to get a more precise reading
  for (int i = 9; i > 0; i--) {
    subSample[i] = subSample[i-1];
  }
  subSample[0] = analogRead(A1);
  //get the average
  float average = 0;
  for (int i = 0; i < 10; i++) {
    average += subSample[i];
  }
  average /= 10.0f;
  average /= 1023.0f;
  average *= 5.0f;
  
  return (average);
}
boolean USB_Connected() {
  return digitalRead(USBPIN);
}

