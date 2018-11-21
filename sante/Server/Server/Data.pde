//class DataStream {
//  ArrayList<String> dataLines = new ArrayList<String>();
//  public int id;
//  String fileName;
//  DataStream(int id) {
//    this.id = id;
//    fileName = this.id + ".txt";
//  }

//  public void addLine(float[] vals) {
//    String data = "";
//    data += time.getTime();
//    data += ",";
//    for (int i = 1; i < vals.length; i++) {
//      data+= vals[i];
//      data+= ",";
//    }
//    dataLines.add(new String(data));
//    //  data += ",";
//    //  data += millis();
//  }
//  public int getId() {
//    return id;
//  }
//  public String returnLastData() {
//    String d = dataLines.size() > 0 ? dataLines.get(dataLines.size()-1) : "null";
//    return d;
//  }
//  //public void saveData() {
//  //  //saveStrings
//  //}
//}