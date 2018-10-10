void setupRTC() {
  year = 2018;
  month = 10;
  day = 11;
  hour = 12;
  minute = 0;
  second = 0;
  millisecond = 0;
}
int monthLength[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
unsigned long timer = 0;
void timeHandler() {
  millisecond = millis() % 1000;
  if (millis() + 1000 > timer) {
    timer = millis();
    if (second < 59) {
      second ++;
    } else {
      second = 0;
      minute++;
    }
  }
  if (minute > 59) {
    minute = 0;
    hour ++;
    if (hour > 23) {
      hour = 0;
      day++;
      if (day > monthLength[month-1]) {
        day = 1;
        month ++;
        if (month > 12) {
          month = 1;
          year++;
        }
      }
    }
  }
}

