import websockets.*;

WebsocketClient wsc;
long now;
String msg = "1,4.00,-2.45,10.25,495"

void setup(){
  size(200,200);
  
  wsc= new WebsocketClient(this, "ws://localhost:8025/Sante");
  now=millis();
}

void draw(){
  
  if(millis()>now+50){
    wsc.sendMessage(msg);
    now=millis();
  }
}

void webSocketEvent(String msg){
 println(msg);
}