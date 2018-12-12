class Input {
  int Width;
  String result;
  ArrayList<String> results;
  TextField textField;
  Input(int Width) {
    this.Width = Width;
    textField = new TextField();
    result = "";
    results = new ArrayList<String>();
  }
  void handleInput(int Width) {
    this.Width = Width;
    textField.drawField();
    String cmd = textField.getOutput();
    if (cmd.length() > 0) {
      String[] cmds = split(cmd, ",");
      println(cmds);
      if (cmds.length == 3) {
        println("calculating BPM");
        result += "BPM = ";
        result += participant[toInt(cmds[0])-1].getBPM(toFloat(cmds[1]), toFloat(cmds[2]));
        result += " at: ";
        result += floatToTime(toFloat(cmds[1]));
        results.add(new String(result));
        result = "";
      } else if (cmds.length == 4) {
        int[] axes = {0, 1};
        participant[toInt(cmds[0])-1].createScatter(axes, toFloat(cmds[1]), toFloat(cmds[2]), toInt(cmds[3]));
        result += "created document: ";
        result += cmds[3];
        results.add(new String(result));
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
  }
}