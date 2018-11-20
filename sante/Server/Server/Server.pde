import websockets.*;
ArrayList<DataStream> dataStream = new ArrayList<DataStream>();
String rawData;
WebsocketServer ws;
long now;
Time time;
Button startButton;
boolean firstTimeSaving, hasSavedData;
int dataStreamAmount;
//ArrayList<Integer> currentStreams = new ArrayList<Integer>();

void setup() {
  size(200, 200, P2D);
  dataStreamAmount = 0;
  ws= new WebsocketServer(this, 8025, "/Sante");
  now=millis();
  time = new Time(hour(), minute(), second());
  startButton = new Button(50, 50, 100, "Start");
  rawData = "";
  firstTimeSaving = true;
  hasSavedData = false;
}
int messageCount = 0;
void draw() {
  background(0);
  startButton.displayButton();
  handleStream();
  if (millis()>now+1000) {
    // ws.sendMessage("Server message");
    println(messageCount + " messages received in last second");
    messageCount = 0;
    now=millis();
  }
}

void webSocketServerEvent(String msg) {
  //println(msg);
  println(msg);
  //delim(msg);
  storeRawData(msg);
  messageCount ++;
  msg = "";
}
void storeRawData(String msg) {
  rawData += time.getTime();
  rawData += ",";
  rawData += msg;
  rawData += "/";
}

void saveData() {
  String[] data = split(rawData, '/');
  saveStrings("data.txt", data);
}



void delim(String msg) {
  float[] vals = new float[5];
  int current = 0;
  String currentVal = "";
  for (int i = 0; i < msg.length(); i++) {
    char c = msg.charAt(i);
    //comma found, go fill next value
    if (c == 44) {
      vals[current] = float(currentVal);
      currentVal = "";
      current ++;
    } else {
      currentVal += c;
    }
  }
  int id = (int)vals[0];
  if (dataStream.size() == 0) { 
    dataStream.add(new DataStream(id));
    DataStream d = dataStream.get(0);
    d.addLine(vals);
  } else {
    for (int i = dataStream.size() -1; i >= 0; i--) {
      DataStream d = dataStream.get(i);
      if (d.getId() != id) {
        dataStream.add(new DataStream(id));
      }
      if (d.getId() == id) {
        d.addLine(vals);
        println(d.returnLastData());
      }
    }
  }
  //print(time.getTime());
 // print("---");
  //for (int i = 0; i < vals.length; i++) {
  //  print(vals[i]);
  //  print("---");
  //}
 // println();
}