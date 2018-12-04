void createHighLightDocument(int id, float timeSkip) {
  int ID = 0;
  //search for our participant
  for (int i = 0; i < participant.length; i++) {
    if (participant[i].getId() == id) {
      ID = i;
    }
  }
  
  String data = "";
  data += "TimeSkip = ";
  data += timeSkip;
  data += "/";
  data += "/";
  data += "begin = ";
  data += floatToTime(startTime);
  data += "/end = ";
  data += floatToTime(endTime);
  data += "/";
  data += "/";
  
  for (float i = startTime; i < endTime; i += timeSkip) {
    data += "Time: ";
    data += floatToTime(i);
    data += " X: ";
    data += participant[ID].getTotalMovement(i, i + timeSkip, 0);
    data += " Y: ";
    participant[ID].getTotalMovement(i, i + timeSkip, 1);
    data += " Z: ";
    participant[ID].getTotalMovement(i, i + timeSkip, 2);
    data += "/";
  }
  String[] outData = split(data, "/");
  String saveLocation = "results/" + id +"analysis.txt";
  saveStrings(saveLocation, outData);
}