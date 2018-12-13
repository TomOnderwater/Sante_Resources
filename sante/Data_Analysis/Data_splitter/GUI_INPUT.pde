class Input {
  int Width;
  ArrayList<String> results;
  TextField textField;
  
  String[] commands = new String[5 * int(180 / 30)];
  
  //set to let program run commands
  boolean saveplots = false;
  
  int count = 0;
  Input(int Width) {
    int sTime = 0;
    int eTime = 0;
    int stepSize = 10800 / (commands.length / participant.length);
    println(stepSize);
    println(commands.length);
    for (int i = 0; i < commands.length / participant.length; i++) {
      eTime += stepSize;
      for (int j = 0; j < participant.length; j++) {
        int n = j + (i * participant.length);
       // println(n);
       int index = j+1;
       int plotnumber = i+1;
        commands[n] = "makescatter " + index + " " + sTime + " " + eTime + " participant" + index + "/halfhourplots/plot" + plotnumber;
       // println(commands[n]);
      }
      sTime += stepSize;
    }
    count = saveplots ? 0 : commands.length;
    this.Width = Width;
    textField = new TextField();
    results = new ArrayList<String>();

    results.add(new String("setttime HH MM"));
    results.add(new String("settime HH MM SS"));
    results.add(new String("settime seconds")); 
    results.add(new String("makescatter p s e f"));
    results.add(new String("getbeat p s e"));
    results.add(new String("--------------"));
    results.add(new String("f = filename"));
    results.add(new String("e = endtime"));  
    results.add(new String("s = starttime"));
    results.add(new String("p = participant"));
    results.add(new String("COMMANDS:"));
  }
  void handleInput(int Width) {
    this.Width = Width;
    textField.drawField();
    String cmd = textField.getOutput();
    
    if (count < commands.length) {
     textField.setOutput(commands[count]);
     count ++;
    }
    if (cmd.length() > 0) {
      String[] cmds = split(cmd, " ");
      println(cmds);
      switch(cmds[0]) {
      case "getbeat":
        try {
          // println("calculating BPM");
          String result = "";
          result += "BPM = ";
          result += participant[toInt(cmds[1])-1].getBPM(toFloat(cmds[2]), toFloat(cmds[3]));
          result += " at: ";
          result += floatToTime(toFloat(cmds[2]));
          results.add(new String(result));
        } 
        catch(Exception e) {
          results.add(new String("unkown command"));
        }
        break;
      case "makescatter":
        try {
          String result = "";
          int[] axes = {0, 1};
          participant[toInt(cmds[1])-1].createScatter(axes, toFloat(cmds[2]), toFloat(cmds[3]), cmds[4]);
          //saveScatter(100,100,"test");
          result += "saved as ";
          result += cmds[4];
          results.add(new String(result));
        } 
        catch(Exception e) {
          results.add(new String("unkown command"));
        }
        break;
      case "settime":
        try {
          String[] input = new String [3];
          boolean flt = false;
          try {
            //String[] lines = split(cmds[1], " ");
            input[2] = "00";
            if (cmds.length > 2) {
              for (int i = 1; i < cmds.length; i++) {
                input[i-1] = cmds[i];
              }
            } else {
              //results.add(new String("haha"));
              input[0] = cmds[1];
              flt = true;
            }
          } 
          catch (Exception e) {
            input[0] = cmds[1];
            flt = true;
          }
          if (flt) {
            try {
              gui.currentTime = toFloat(input[0]);
            } 
            catch (Exception e) {
              results.add(new String("invalid number"));
            }
          } else {
            try {
              float t = 0;
              t += toFloat(input[2]);
              t += toFloat(input[1]) * 60;
              t += toFloat(input[0]) * 3600;
              gui.currentTime = t;
            } 
            catch (Exception e) {
              results.add(new String("invalid time"));
            }
          }
        } 
        catch(Exception e) {
          results.add(new String("unknown command"));
        }
        break;
      default:
        results.add(new String("unknow command"));

        break;
      }
    }
    fill(255);
    for (int i = 0; i < results.size(); i++) {
      String r = results.get((results.size()-1) - i);
      text(r, 20, 80 + (i * 20));
    }
  }
  class TextField {
    boolean selected;
    String input;
    String output;
    boolean keyReleased;
    TextField() {
      selected = false;
      input = "";
      output = "";
      keyReleased = true;
    }
    void drawField() {
      handleMouse();
      handleInput();
      if (selected) {
        fill(255);
      } else {
        fill(200);
      }
      rect(20, 20, Width-40, 30);
      fill(0);
      text(input, 25, 40);
    }
    void handleMouse() {
      if (mousePressed) {
        if (checkMousePress(20, 20, Width-40, 30)) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }
    void handleInput() {
      if (selected) {
        if (keyPressed) {
          if (keyReleased) {
            // println((int)key);
            if (key == 10) {
              output = input;
              input = "";
              //  println("enter");
            } else if (key == 8 && input.length() > 0) {
              input = input.substring(0, input.length()-1);
            } else {
              input += key;
            }
          }
          keyReleased = false;
        } else {
          keyReleased = true;
        }
      }
    }
    String getOutput() {
      String out = output;
      output = "";
      return out;
    }
    void setOutput(String output) {
      this.output = output;
    }
  }
}