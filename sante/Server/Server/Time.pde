class Time {
  int hour, minute, second, millisecond;
  long timer;
  Time(int hour, int minute, int second) {
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    timer = 0;
  }
  String getTime() {
    String out = "";
    millisecond = millis() % 1000;
    if (millis() > timer + 1000) {
      timer += 1000;
      second ++;
    }
    if (second > 59) {
      second = second % 60;
      minute ++;
    }
    if (minute > 59) {
      minute = minute % 60;
      hour ++;
    }
    if (hour > 24) {
      hour = hour % 24;
    }
    out += hour;
    out += ",";
    out += minute;
    out += ",";
    out += second;
    out += ",";
    out += millisecond;
    return out;
  }
}