void saveScatter(int w, int h, String name) {
  PImage output = createImage(w, h, RGB);
  PGraphics pg;
  pg = createGraphics(w, h);
  pg.beginDraw();
  pg.background(255);
  pg.line(0,0,w,h);
  pg.endDraw();
  output = pg;
  String path = "results/scatter/" + name + ".png";
  output.save(path);
}
