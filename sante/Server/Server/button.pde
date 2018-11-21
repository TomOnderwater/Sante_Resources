class Button {
  public boolean state;
  private int posx, posy;
  private int size;
  private String text;
  private boolean firstPress;

  Button(int posx, int posy, int size, String text) {
    this.posx = posx;
    this.posy = posy;
    this.size = size;
    state = false;
    this.text = text;
    firstPress = true;
  }
  void displayButton() {
    checkPressed();
    fill(state ? 255 : 200);
    rect(posx, posy, size, size);
    fill(state ? 200 : 100);
   // textMode(CENTER);
    text(text, posx + (size/2)-10, posy + (size /2));
    if (state && firstTimeSaving) {
      firstTimeSaving = false;
    }
  }
  boolean mouseOver() {
    boolean out = false;
    if (mouseX > posx && mouseX < (posx + size)) {
      if (mouseY > posy && mouseY < (posy + size)) {
        out = true;
      }
    }
    return out;
  }
  void checkPressed() {
    if (mouseOver()) {
      if (mousePressed) {
        if (firstPress) {
          state = !state;
          firstPress = false;
        }
      }
    }
    if (mousePressed == false) {
      firstPress = true;
    }
  }
  public boolean getState() {
    return state;
  }
}