String getHeartData() {
  String out = "";
  out += "H";
  out += analogRead(A0);
  return out;
}

