class SelectorButton {
  int x, y;
  boolean state;
  boolean toggle;
  int xsize, ysize;
  String t;
  SelectorButton(int x, int y, boolean state, String t) {
    this.x = x;
    this.y = y;
    this.state = state;
    toggle = state;
    xsize = 10;
    ysize = 10;
    this.t = t;
  }
  SelectorButton(int x, int y, boolean state, int xsize, int ysize, String t) {
    this.x = x;
    this.y = y;
    this.state = state;
    toggle = state;
    this.xsize = xsize;
    this.ysize = ysize;
    this.t = t;
  }
  void checkButton() {
    if (checkMousePress(x, y, xsize, ysize)) {
      if (state == toggle) { 
        state = !state;
      }
    } else {
      toggle = state;
    }
  }
  void showButton() {
    checkButton();
    if (state) {
      fill(180, 255, 180);
    } else {
      fill(255, 180, 180);
    }
    rect(x, y, xsize, ysize);
    fill(0);
    text(t, x + xsize + 5, y + ysize);
    //text(t, x, y);
  }
  void setXY(int x, int y) {
    this.x = x;
    this.y = y;
  }
  int getXsize() {
    return xsize;
  }
  int getYsize() {
    return ysize;
  }
  boolean getState() {
    return state;
  }
}

boolean checkMousePress(int x, int y, int w, int h) {
  return mousePressed && mouseX > x && mouseX < x+w && mouseY > y && mouseY < y + h;
}
