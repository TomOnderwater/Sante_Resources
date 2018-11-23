void setup() {
  println(toInt("-100"));
  println(toInt("459039"));
  println(toInt("-1113"));
  println(toInt("h009"));
  splitData(1, true, 1000);
}


void splitData(int id, boolean all, int n) {
  String data = "";
  String lines[] = loadStrings("data/data.txt");
  int[] IDs = new int[0];
  int percent = int((float)lines.length / 100);
  int amount = all ? lines.length : n;
  int progress = 0;
  for (int i = 0; i < amount; i++) {
    if (lines.length % i == 0) {
      println(progress + "%");
      progress ++;
    }
    String[] line = split(lines[i], ',');
    int thisID = toInt(line[0]);
    if (thisID == id) {
      data += lines[i] + "/";
    }

    if (i == 0) {
      IDs = append(IDs, thisID);
    } else {
      boolean newID = true;
      for (int j = 0; j < IDs.length; j++) {
        if (thisID == IDs[j]) {
          newID = false;
        }
      }
      if (newID) {
        IDs = append(IDs, thisID);
      }
    }
  }
  print("IDs found: ");
  for (int i = 0; i < IDs.length; i++) {
    print(IDs[i] + " ");
  }
  String[] outData = split(data, "/");
  String saveLocation = "data/" + id +".txt";
  saveStrings(saveLocation, outData);
  println("done");
}

int toInt(String data) {
  int mult = 1;
  int out = 0;
  boolean NaN = false;
  for (int i = 0; i < data.length(); i++) {
    char c = data.charAt(i);
    if (c == 45) {
      mult *= -1;
    } else if (c >= 48 && c <= 57) {
      out *= 10;
      out += (c-48);
    } else {
      NaN = true;
    }
  }
  out *= mult;
  return NaN ? 0 : out;
}