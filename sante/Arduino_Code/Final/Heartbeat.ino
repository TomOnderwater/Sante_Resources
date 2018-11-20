String getHeart() {
  String out = "";
 // out += "H";
  out += (String)analogRead(A0);
  return out;
}
