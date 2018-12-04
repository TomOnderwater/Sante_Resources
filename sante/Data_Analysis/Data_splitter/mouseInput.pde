void mouseWheel(MouseEvent event) {
 float val = event.getCount() * -1;
 gui.flowTime(val);
 for (int i = 0; i < participant.length; i++) {
   if (val < 0) {
     participant[i].lowerCurrentRead(val);
   }
 }
}
