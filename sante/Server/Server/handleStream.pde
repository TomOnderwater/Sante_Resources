
void handleStream() {
  if (startButton.getState()) {
    if (streamOn == false) {
      time.setTime();
      println("recording started at: " + time.getTime());
      streamOn = true;
      hasSavedData = false;
    }
  }
      
  if (startButton.getState() == false) {
    //if (firstTimeSaving == false) {
      //meaning it went off, so experiment ex.
      if (hasSavedData == false) {
        println("Saving Data...");
        saveData();
        println("recording ended at: " + time.getTime());
        hasSavedData = true;
        streamOn = false;
      }
    }
//  }
}