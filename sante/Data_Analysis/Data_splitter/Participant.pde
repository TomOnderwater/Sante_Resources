class Participant {
  public int id;
  ArrayList<Timestamp> stamp = new ArrayList<Timestamp>();
  ArrayList<SelectorButton> showValue = new ArrayList<SelectorButton>();
  ArrayList<HeartbeatPeak> heartbeatPeaks = new ArrayList<HeartbeatPeak>();
  color[] colors = new color[4];
  float accelMin;
  float accelMax;
  int currentRead;

  Participant(int id) {
    String lines[] = loadStrings("data/" + id + "flt.txt");
    for (int i = 0; i < lines.length; i++) {
      if (i == 0) {
        println(lines[i]);
      }
      stamp.add(new Timestamp(lines[i]));

      colors[0] = color(255, 0, 0);
      colors[1] = color(0, 255, 0);
      colors[2] = color(0, 0, 255);
      colors[3] = color(0, 0, 0);

      accelMin = -50;
      accelMax =50;
      currentRead = 0;
      //}
    }
    this.id = id;
    showValue.add(new SelectorButton(0, 0, true, "X"));
    showValue.add(new SelectorButton(0, 0, true, "Y"));
    showValue.add(new SelectorButton(0, 0, true, "Z"));
    showValue.add(new SelectorButton(0, 0, true, "H"));
  }
  void lowerCurrentRead(float val) {
    currentRead += (int)(val * 50);
    currentRead = currentRead > 0 ? currentRead : 0;
  }
  void showParticipant(int xPos, float yPos, int xLength, float yHeight, float time) {
    stroke(0);
    line(xPos, yPos, xPos + xLength, yPos);
    text("participant: " + id, xPos + 5, yPos-20);
    selector(xPos, (int)yPos);
    //scaleLines(xPos, yPos, xLength, yHeight);
    //factor is time related, make it smaller to see more data at a time, larger for a more precise view of data
    int factor = 100;
    //second bars
    for (int i = xPos; i < xLength + xPos; i+=factor) {
      stroke(0);
      strokeWeight(1);
      line(i - (time*factor) % factor, yPos - 5, i - (time * factor) % factor, yPos+5);
      pushMatrix();
      translate(i - (time * factor) % factor, yPos - 10);
      rotate(-PI/2);
      // float val = time + ((float)xPos / 100);
      int val = int(time + (i / 100) - 3);
      text(val, 0, 3);
      popMatrix();
    }

    int end = currentRead + (xPos * 10);
    end = end > stamp.size() ? stamp.size() : end;
    boolean firstPass = true;
    // text("participant: " + id +"  "+  time + "  " + currentRead + "  " + end, xPos + 5, yPos-20);
    //show the heartBeats

    showBeats(time, xPos, yPos, xLength, yHeight, factor);

    for (int i = currentRead; i < end; i++) {
      if (i >= 1) {
        Timestamp s1 = stamp.get(i-1);
        Timestamp s2 = stamp.get(i);
        if (s1.getTime() > time && s1.getTime() < time + xLength) {
          if (firstPass) {
            currentRead = i;
            firstPass = false;
          }
          //float x1 = xPos + (factor * (s1.getTime()-time));
          //float x2 = xPos + (factor * (s2.getTime()-time));
          //float y1 = yPos - (yHeight / 2) + scaleLine(s1.getHeartBeat(), yHeight, 0, 1023);
          //float y2 = yPos - (yHeight / 2) + scaleLine(s2.getHeartBeat(), yHeight, 0, 1023);
          for (int j = 0; j < showValue.size(); j++) {
            SelectorButton s = showValue.get(j);
            if (s.getState()) {
              if ( j < 3) {
                float x1 = xPos + (factor * (s1.getTime()-time));
                float x2 = xPos + (factor * (s2.getTime()-time));
                float y1 = yPos - (yHeight / 2) + scaleLine(s1.getVals()[j], yHeight, accelMin, accelMax);
                float y2 = yPos - (yHeight / 2) + scaleLine(s2.getVals()[j], yHeight, accelMin, accelMax);
                stroke(colors[j]);
                line(x1, y1, x2, y2);
              } else {
                float x1 = xPos + (factor * (s1.getTime()-time));
                float x2 = xPos + (factor * (s2.getTime()-time));
                float y1 = yPos - (yHeight / 2) + scaleLine(s1.getHeartBeat(), yHeight, 0, 1023);
                float y2 = yPos - (yHeight / 2) + scaleLine(s2.getHeartBeat(), yHeight, 0, 1023);
                stroke(colors[j]);
                line(x1, y1, x2, y2);
                //for (int z = 0; z < heartbeatPeaks.size();
              }
              //show the line
            }
          }
          //  line(x1, y1, x2, y2);
          //line(xPos + (s1.getTime()-time), xPos + (s2.getTime()-time), yPos + 50, yPos + 20);
        }
      }
    } 
    for (int i = 0; i < stamp.size() && firstPass; i++) {
      Timestamp s = stamp.get(i);
      if (s.getTime() > time && s.getTime() < time + xLength) {
        if (firstPass) {
          currentRead = i;
          firstPass = false;
        }
      }
    }
  }
  void scaleLines(int x, float y, int xLength, float yHeight) {
    // line(x, y-yHeight/2, xLength, y-yHeight/2);
    // line(x, y+yHeight/2, xLength, y+yHeight/2);
  }

  void showBeats(float time, float xPos, float yPos, float xLength, float yHeight, int factor) {
    float bTime = time;
    float eTime = time + (xLength / factor);
    for (int i = 0; i < heartbeatPeaks.size(); i++) {
      HeartbeatPeak p = heartbeatPeaks.get(i);
      float t = p.getTime();
      if (t > bTime && t < eTime) {
        stroke(255, 0, 0);
        float x = xPos + (factor * (t-time));
        line(x, yPos - 10, x, yPos + 10);
      }
    }
  }

  void calculateBeats() {
    //float[] vals = getAVG(beginTime, eTime, 3);
    //for (int i = 0; i < stamp.size(); i++) {
    //  Timestamp s = stamp.get(i);
    //  //all data

    //}
    float checkTime = 4;
    int minimumSamples = 40;
    float StartTime = 0;
    float EndTime = endTime - startTime;
   // println("beginTime = " + StartTime + " endTime = " + EndTime);
   float minPeak = 40;
   float maxPeak = 150;
    for (float i = StartTime; i < EndTime-(checkTime/2); i+= checkTime/2) {
      //println(i);

      float[] vals = getAVG(i, i+checkTime, 3);
      if (vals[3] > minimumSamples) {
      //  println("minimum found: " + vals[3]); 
        boolean passAVG = false;
        float[] allVals = getAllVals(i, i+checkTime, 3);
        //println(allVals.length);
      //  println(vals);
       float recordLow = 0;
       float recordHigh = 0;
        for (int j = 0; j < allVals.length-1; j+= 2) {
          //check if value passed average
       //   println("c: " + j);
       //println(vals[0]);
          if (passAVG) {
            if (allVals[j] < vals[0]) {
              //currently value is below average
              passAVG = false;
              //look for bottom
              float currentLowest = allVals[j];
              recordLow = currentLowest;
              int n = j;
              //boolean notFound = true;
              for (int z = j; z < allVals.length-1; z+= 2) {
                if (allVals[z] < currentLowest) {
                  currentLowest = allVals[z];
                  n = z;
                } else {
               //   println("peak found at ");
                  //notFound = false;
                  break;
                }
              }
              recordLow = allVals[n];
            }
          } else {
            if (allVals[j] > vals[0]) {
              passAVG = true;
              //currently value is above average
              //start looking for the peak 
              float currentHighest = allVals[j];
              int n = j;
              //boolean notFound = true;
              for (int z = j; z < allVals.length-1; z+= 2) {
                if (allVals[z] > currentHighest) {
                  currentHighest = allVals[z];
                  n = z;
                } else {
               //   println("peak found at ");
                  //notFound = false;
                  break;
                }
              }
              recordHigh = allVals[n];
              //add the new heartbeat
              float PtP = recordHigh - recordLow;
              println(PtP + ", " + recordHigh + ", " + recordLow);
              if (PtP > minPeak && PtP < maxPeak) {
              heartbeatPeaks.add(new HeartbeatPeak(allVals[n+1]));
              }
            }
          }
        }
      }
    }
    //cleanup data
   // println("current peak amount = " + heartbeatPeaks.size());
    for (int i = heartbeatPeaks.size()-1; i >= 0; i--) {
      HeartbeatPeak thisPeak = heartbeatPeaks.get(i);
      for (int j = 0; j< heartbeatPeaks.size(); j++) {
        HeartbeatPeak thatPeak = heartbeatPeaks.get(j);
        if (thisPeak.getTime() == thatPeak.getTime() && j != i) {

          heartbeatPeaks.remove(i);
        }
      }
    }
   //     println("current peak amount = " + heartbeatPeaks.size());
  }
  void showMovementIntensity(int axis) {
  }
  int getBPM(float bTime, float eTime) {
   int out = 0;
   int count = 0;
   float AVG = 0;
   for (int i = 0; i < heartbeatPeaks.size()-1; i++) {
     HeartbeatPeak p1 = heartbeatPeaks.get(i);
     HeartbeatPeak p2 = heartbeatPeaks.get(i+1);
     if (p1.getTime() > bTime && p1.getTime() < eTime) {
     AVG += p2.getTime()-p1.getTime();
     count++;
     }
   }
   AVG = count > 0 ? AVG /= count : 0;
   out = round(60 / AVG);  
   return out;
  }
  float scaleLine(float input, float h, float minVal, float maxVal) {
    return map(input, maxVal, minVal, 0, h);
  }

  void selector(int x, int y) {
    int spacing = 50;
    for (int i = 0; i < showValue.size(); i++) {
      SelectorButton s = showValue.get(i);
      s.setXY((x + 5) + i * spacing, y+5);
      s.showButton();
    }
  }
 
  float[] getAVG(float beginTime, float eTime, int dataStream) {
    float[] out = {0, -10000, 10000, 0};
    //do stuff
    //Heartbeat data

    int count = 0;
    if (dataStream == 3) {
      for (int i = 0; i < stamp.size(); i++) {
        Timestamp s = stamp.get(i);
        if (s.getTime() > beginTime && s.getTime() < eTime) {
          count++;
          float val = s.getHeartBeat();
          if (val > out[1]) {
            out[1] = val;
          } 
          if (val < out[2]) {
            out[2] = val;
          }
          out[0] += val;
        }
      }
    } 
    //Accelerometer data
    else {
      for (int i = 0; i < stamp.size(); i++) {
        Timestamp s = stamp.get(i);
        if (s.getTime() > beginTime && s.getTime() < eTime) {
          count++;
          float val = s.getVals()[dataStream];
          if (val > out[1]) {
            out[1] = val;
          } 
          if (val < out[2]) {
            out[2] = val;
          }
          out[0] += val;
        }
      }
    }
    if (count > 0) {
      out[0] = out[0] / count;
      out[3] = count;
      return out;
    } else {
      return out;
    }
  }

  float[] getAllVals(float beginTime, float eTime, int dataStream) {
    float[] vals = new float[0];

    for (int i = 0; i < stamp.size(); i++) {
      Timestamp s = stamp.get(i);
      if (s.getTime() > beginTime && s.getTime() < eTime) {
        if (dataStream == 3) {
          vals = append(vals, s.getHeartBeat());
          vals = append(vals, s.getTime());
        } else {
          vals = append(vals, s.getVals()[dataStream]);
          vals = append(vals, s.getTime());
        }
      }
    }
    return vals;
  }

  float getTotalMovement(float beginTime, float eTime, int axis) {
    float out = 0;
    for (int i = 0; i < stamp.size(); i++) {
      Timestamp s = stamp.get(i);
      if (s.getTime() > beginTime && s.getTime() < eTime) {
        if (i == 0) {
          //do nothing
          //prev = s.getVals()[axis];
        } else {
          Timestamp s2 = stamp.get(i-1);
          float prev = s2.getVals()[axis];
          out += abs(s.getVals()[axis]-prev);
        }
      }
    }
    return out;
  }
  float getMovementIntensity(float beginTime, float eTime, int axis) {
    float out = 0;
    
    return out;
  }
  int getSamples(float beginTime, float eTime) {
    int out = 0;
    for (int i = 0; i < stamp.size(); i++) {
      Timestamp s = stamp.get(i);
      if (s.getTime() > beginTime && s.getTime() < eTime) {
        out ++;
      }
    }
    return out;
  }
  int getId() {
    return id;
  }
  int getBeatAmount() {
    return heartbeatPeaks.size();
  }
  float getHeartBeatPeakTime(int index) {
    HeartbeatPeak p = index <= heartbeatPeaks.size() ? heartbeatPeaks.get(index) : heartbeatPeaks.get(0);
    return p.getTime();
  }
}

class Timestamp {
  float vals[] = new float[3];
  int heartBeat;
  float time;
  Timestamp(String rawData) {
    String[] line = split(rawData, ',');
    for (int i = 1; i < 4; i ++) {
      vals[i-1] = toFloat(line[i]);
    }
    heartBeat = toInt(line[4]);
    time = toFloat(line[5]);
  }
  float getTime() {
    return time;
  }
  float[] getVals() {
    return vals;
  }
  int getHeartBeat() {
    return heartBeat;
  }
}

class HeartbeatPeak {
  public float time;

  HeartbeatPeak(float time) {
    this.time = time;
  }
  float getTime() {
    return this.time;
  }
  void setTime(float time) {
    this.time = time;
  }
}