static int standardX = 600;
static int standardY = 400;

GUI gui;
Participant[] participant = new Participant[5];
float startTime, endTime;

void setup() {
  float time = timeToFloat("16,12,54,387");
  println(time);
  time *= 1.0;
  println(floatToTime(time));
    //splitData(1, true, 1000);
    //splitData(2, true, 1000);
    //splitData(3, true, 1000);
    //splitData(4, true, 1000);
    //splitData(5, true, 1000);
    //alterTime(1, 10);
   // alterTime(2, 10);
   // alterTime(3, 10);
   // alterTime(4, 10);
   // alterTime(5, 10);
   for (int i = 1; i < 6; i++) {
   //saveTimeAsFloat(i);
  // cleanData(i);
   participant[i-1] = new Participant(i);
   }
   size(600, 400);
   surface.setResizable(true);
   gui = new GUI(standardX, standardY);
     String allLines[] = loadStrings("data/data.txt");
    String[] firstDataLine = split(allLines[0], ",");
    String[] lastDataLine = split(allLines[allLines.length-1], ",");
    String eTime = lastDataLine[5] + "," + lastDataLine[6] + "," + lastDataLine[7] + "," + lastDataLine[8];
  String sTime = firstDataLine[5] + "," + firstDataLine[6] + "," + firstDataLine[7] + "," + firstDataLine[8];
   startTime = timeToFloat(sTime);
   endTime = timeToFloat(eTime);
   
   //createHighLightDocument(1, 2);
   participant[2].calculateBeats();
   createHighLightDocument(3, 60);
   println(participant[2].getBeatAmount());
  //println(participant[1].getTotalMovement(10, 20, 0));
}

void draw() {
  gui.display();
}


void splitData(int id, boolean all, int n) {
  String data = "";
  String lines[] = loadStrings("data/data.txt");
  int[] IDs = new int[0];
  int percent = int((float)lines.length / 100);
  int amount = all ? lines.length : n;
  int progress = 0;
  for (int i = 0; i < amount; i++) {
    if (i % percent == 0) {
      println(progress + "%");
      progress ++;
    }
    String[] line = split(lines[i], ',');
    int thisID = toInt(line[0]);
    if (thisID == id) {
      data += lines[i] + "/";
    }

    if (i == 0) {
      IDs = append(IDs, thisID);
    } else {
      boolean newID = true;
      for (int j = 0; j < IDs.length; j++) {
        if (thisID == IDs[j]) {
          newID = false;
        }
      }
      if (newID) {
        IDs = append(IDs, thisID);
      }
    }
  }
  print("IDs found: ");
  for (int i = 0; i < IDs.length; i++) {
    print(IDs[i] + " ");
  }
  String[] outData = split(data, "/");
  String saveLocation = "data/" + id +".txt";
  saveStrings(saveLocation, outData);
  println("done");
}

void alterTime(int id, int minutesOff) {
  String data = "";
  String input = "data/" + id + ".txt";
  String lines[] = loadStrings(input);
  int percent = int((float)lines.length / 100);
  int amount = lines.length;
  int progress = 0;

  float startTime;
  float endTime;
  float factor = 0;
  String[] firstDataLine = split(lines[0], ",");
  String[] lastDataLine = split(lines[amount-1], ",");
 // amount = 100;

  String sTime = firstDataLine[5] + "," + firstDataLine[6] + "," + firstDataLine[7] + "," + firstDataLine[8];
  String eTime = lastDataLine[5] + "," + lastDataLine[6] + "," + lastDataLine[7] + "," + lastDataLine[8];
  startTime = timeToFloat(sTime);
  endTime = timeToFloat(eTime);
  factor = ((endTime - startTime) + (minutesOff * 60)) / (endTime - startTime);
  println("factor is : " + factor);

//  progress counter
  for (int i = 0; i < amount; i++) {
    if (i % percent == 0) {
      println(progress + "%");
      progress ++;
    }
    String[] thisLine = split(lines[i], ",");
    String tTime = thisLine[5] + "," + thisLine[6] + "," + thisLine[7] + "," + thisLine[8];
    float thisTime = timeToFloat(tTime) - startTime;
    thisTime *= factor;
    thisTime += startTime;
    tTime = floatToTime(thisTime);
    for (int j = 0; j < 5; j++) {
      data += thisLine[j];
      data += ",";
    }
    data += tTime;
    data += "/";
  }
  String[] outData = split(data, "/");
  String saveLocation = "data/" + id +"fxd.txt";
  saveStrings(saveLocation, outData);
  println("done");
}

void saveTimeAsFloat(int id) {
  String data = "";
  String input = "data/" + id + ".txt";
  String lines[] = loadStrings(input);
  String allLines[] = loadStrings("data/data.txt");
  int percent = int((float)lines.length / 100);
  int amount = lines.length;
  int progress = 0;

 // amount = 100;
 String[] firstDataLine = split(allLines[0], ",");

  String sTime = firstDataLine[5] + "," + firstDataLine[6] + "," + firstDataLine[7] + "," + firstDataLine[8];
  float startTime = timeToFloat(sTime);


//  progress counter
  for (int i = 0; i < amount; i++) {
    if (i % percent == 0) {
      println(progress + "%");
      progress ++;
    }
    String[] thisLine = split(lines[i], ",");
    String tTime = thisLine[5] + "," + thisLine[6] + "," + thisLine[7] + "," + thisLine[8];
    float thisTime = timeToFloat(tTime) - startTime;
   // thisTime *= factor;
    //thisTime += startTime;
   // tTime = floatToTime(thisTime);
    for (int j = 0; j < 5; j++) {
      data += thisLine[j];
      data += ",";
    }
    data += thisTime;
    data += "/";
  }
  String[] outData = split(data, "/");
  String saveLocation = "data/" + id +"float.txt";
  saveStrings(saveLocation, outData);
  println("done");
  
}

float timeToFloat(String data) {
  float out = 0;
  String[] line = split(data, ",");
  out += toInt(line[0]) * 3600;
  out += toInt(line[1]) * 60;
  out += toInt(line[2]);
  out += (float)toInt(line[3]) / 1000f;
  return out;
}
String floatToTime(float time) {
  float timeRemaining = time;
  String out = "";
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  hours = (int) time / 3600;
  timeRemaining = time - (hours * 3600);
  minutes = (int) timeRemaining / 60;
  timeRemaining = timeRemaining - (minutes * 60);
  seconds = (int)timeRemaining;
  timeRemaining = timeRemaining - seconds;
  milliseconds = (int) (timeRemaining * 1000);
  out = hours + "," + minutes + "," + seconds + "," + milliseconds;
  return out;
}

int toInt(String data) {
  int mult = 1;
  int out = 0;
  boolean NaN = false;
  for (int i = 0; i < data.length(); i++) {
    char c = data.charAt(i);
    if (c == 45) {
      mult *= -1;
    } else if (c >= 48 && c <= 57) {
      out *= 10;
      out += (c-48);
    } else {
      NaN = true;
    }
  }
  out *= mult;
  return NaN ? 0 : out;
}

void cleanData(int id) {
String data = "";
  String input = "data/" + id + "float.txt";
  String lines[] = loadStrings(input);
  int percent = int((float)lines.length / 100);
  int amount = lines.length;
  int progress = 0;

 // amount = 100;

float highestVal = 0;
//loop
  for (int i = 0; i < amount; i++) {
    //progress counter
    if (i % percent == 0) {
      println(progress + "%");
      progress ++;
    }
    //end of progress counter
    String[] thisLine = split(lines[i], ",");
    
    float thisTime = toFloat(thisLine[5]);
    if (thisTime > highestVal) {
      highestVal = thisTime;
      //let it be saved, no errors found
          for (int j = 0; j < 5; j++) {
      data += thisLine[j];
      data += ",";
    }
    data += thisTime;
    data += "/";
    }
  }
  String[] outData = split(data, "/");
  String saveLocation = "data/" + id +"flt.txt";
  saveStrings(saveLocation, outData);
  println("done");
}

float toFloat(String data) {
  int mult = 1;
  int preComma = 0;
  float afterComma = 0;
  int numbersAfterComma = 1;
  float out = 0;
  boolean dotFound = false;
  boolean NaN = false;
  for (int i = 0; i < data.length(); i++) {
    char c = data.charAt(i);
    //negative number, found a '-'
    if (c == 45) {
      mult *= -1;
    }
    //found a '.'
    else if (c == 46 && dotFound == false) {
      dotFound = true;
    }
    // found a number
    else if (c >= 48 && c <= 57) {
      if (dotFound) {
        numbersAfterComma *= 10;
        float val = c -48;
        val /= numbersAfterComma;
        afterComma += val;
      } else {
        preComma *= 10;
        preComma += (c-48);
      }
    } else {
      NaN = true;
    }
  }
  out = preComma + afterComma;
  out *= (float)mult;
  return NaN ? 0 : out;
}