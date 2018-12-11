class GUI {
  int xSize;
  int ySize;
  int minSize;
  float partition;
  int maxTextSize;
  int textSize;
  
  float currentTime;
  Input input;
  
  ParticipantSelector selectParticipants;
  ParticipantStream participantStream;
  GUI(int x, int y) {
    xSize = x;
    ySize = y;
    minSize = 400;
    partition = 0.3;
    maxTextSize = 300;
    textSize = 16;
    selectParticipants = new ParticipantSelector(new int[]{1, 2, 3, 4, 5});
    participantStream = new ParticipantStream();
    currentTime = 1500;
    input = new Input(maxTextSize);
  }

  void display() {
    xSize = width;
    ySize = height;
    //noStroke();
    int finalX = (int)(xSize * partition);
    finalX = finalX > maxTextSize ? maxTextSize : finalX;
   // println(finalX);
    displayBackGround(finalX);
    selectParticipants.showSelector(finalX, 0);
    participantStream.display(finalX, currentTime, selectParticipants.isSelected());
    showStuff(finalX);
    
  }
  
  
  void displayBackGround(int finalX) {
    fill(255);
    stroke(1);
    rect(0, 0, xSize, ySize);
    fill(0);
    stroke(0);
    rect(0, 0, finalX, ySize);
  }
  void flowTime(float timeInput) {
    currentTime += timeInput;
    currentTime = currentTime < 0 ? 0 : currentTime;
  }
    void showStuff(int finalX) {
    text(floatToTime(currentTime), finalX + 5, height - 20);
    text(floatToTime(startTime + currentTime), finalX + 5, height - 35);
    }
}

class ParticipantStream {
  boolean[] showParticipant = new boolean[5];
  ParticipantStream() {
    for (int i = 0; i < 5; i++) {
      showParticipant[i] = false;
    }
  }
  void display(int xPos, float time, boolean [] selected) {
    int selectedAmount = 0;
    for (int i = 0; i < selected.length; i++) {
      selectedAmount = selected[i] ? selectedAmount + 1 : selectedAmount;
    }
    float currentHeight = selectedAmount > 0 ? (height - 50) / selectedAmount : 0;
    int currentX = xPos;
    int currentLength = width - xPos;
    float currentY = height / (selectedAmount + 1);
    for (int i = 0; i < participant.length; i++) {
      if (selected[i]) {
      participant[i].showParticipant(currentX, currentY, currentLength, currentHeight, time);
      currentY += height / (selectedAmount + 1);
      }
    }
    
  }
}

class ParticipantSelector {
  int amount;
  int spacing;
  ArrayList<SelectorButton> buttons = new ArrayList<SelectorButton>();
  ParticipantSelector(int[] participants) {
    for (int i = 0; i < participants.length; i++) {
      buttons.add(new SelectorButton(0, 0, false, "" + participants[i]));
    }
    spacing = 50;
    amount = participants.length;
  }
  void showSelector(int x, int y) {
    int xStart = x + 5;
    int yStart = 5;
    int distanceBetween = 20;

    for (int i = 0; i < buttons.size(); i ++) {
      SelectorButton b = buttons.get(i);
      b.setXY((xStart + ((distanceBetween + b.getXsize()) * i+1)), (yStart));
      b.showButton();
    }
  }
  boolean isSelected(int id) {
    SelectorButton b = buttons.get(id);
    return b.getState();
  }
  boolean[] isSelected() {
    boolean[] out = new boolean[amount];
    for (int i = 0; i < amount; i++) {
      SelectorButton b = buttons.get(i);
      out[i] = b.getState();
    }
    return out;
  }
}