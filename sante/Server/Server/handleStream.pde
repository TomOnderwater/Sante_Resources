
void handleStream() {
  if (startButton.getState() == false) {
    if (firstTimeSaving == false) {
      //meaning it went off, so experiment ex.
      if (hasSavedData == false) {
        saveData();
        println("Saving Data...");
        hasSavedData = true;
      }
    }
  }
}