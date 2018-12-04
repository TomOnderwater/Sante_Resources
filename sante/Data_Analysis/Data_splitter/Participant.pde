class Participant {
  public int id;
  ArrayList<Timestamp> stamp = new ArrayList<Timestamp>();
  ArrayList<SelectorButton> showValue = new ArrayList<SelectorButton>();
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
    line(xPos, yPos, xPos + xLength, yPos);
    text("participant: " + id +"  "+  time, xPos + 5, yPos-20);
    selector(xPos, (int)yPos);
    int factor = 100;
    for (int i = xPos; i < xLength + xPos; i+=factor) {
      stroke(0);
      strokeWeight(1);
      line(i - (time*factor) % factor, yPos - 5, i - (time * factor) % factor, yPos+5);
    }

    int end = currentRead + (xPos * 10);
    end = end > stamp.size() ? stamp.size() : end;
    boolean firstPass = true;
    // text("participant: " + id +"  "+  time + "  " + currentRead + "  " + end, xPos + 5, yPos-20);
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

  float scaleLine(float input, float h, float minVal, float maxVal) {
    return map(input, minVal, maxVal, 0, h);
  }

  void selector(int x, int y) {
    int spacing = 50;
    for (int i = 0; i < showValue.size(); i++) {
      SelectorButton s = showValue.get(i);
      s.setXY((x + 5) + i * spacing, y+5);
      s.showButton();
    }
  }
  float getAVG(float beginTime, float endTime, int dataStream) {
    float out = 0;
    //do stuff

    return out;
  }

  float getTotalMovement(float beginTime, float endTime, int axis) {
    float out = 0;
    for (int i = 0; i < stamp.size(); i++) {
      Timestamp s = stamp.get(i);
      if (s.getTime() > beginTime && s.getTime() < endTime) {
        if (i == 0) {
          //prev = s.getVals()[axis];
        } else {
          Timestamp s2 = stamp.get(i-1);
          float prev = s2.getVals()[axis];
          out += s.getVals()[axis] - prev;
        }
      }
    }
    return out;
  }
  int getId() {
    return id;
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