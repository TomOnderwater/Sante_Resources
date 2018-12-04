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
  
  for (float i = 0; i < endTime - startTime; i += timeSkip) {
    data += "Time: ";
    data += floatToTime(i + startTime);
    data += " --- X: ";
    //println(participant[ID].getTotalMovement(i, i + timeSkip, 0)); 
    
    data += participant[ID].getTotalMovement(i, i + timeSkip, 0);
    data += " Y: ";
    data += participant[ID].getTotalMovement(i, i + timeSkip, 1);
    data += " Z: ";
    data += participant[ID].getTotalMovement(i, i + timeSkip, 2);
    data += " samples: ";
    data += participant[ID].getSamples(i, i+timeSkip);
    data += "/";
  }
  String[] outData = split(data, "/");
  String saveLocation = "results/" + id +"analysis.txt";
  saveStrings(saveLocation, outData);
}