import processing.net.*;
import processing.opengl.*;

Server server;
float rotX=0;
float rotY=0;
float speed=0;
String data="";
String display="0,0";
String[] values={"0","0"};

void setup(){
  size(1000, 1000, OPENGL);
  server=new Server(this, 4444);
}

void draw(){
  background(160);
  display=rotX+","+rotY;
  text(display, 10, 10);
  text(speed, 90, 10);
  translate(500,500,0);
  rotate(radians(rotX/255*90+90));
  speed=-(rotY/255*3)+speed;
  speed=speed%360;
  rotateY(radians(speed));
  sphere(300); 
  Client incoming=server.available();
  try{
  if (incoming!=null){
    data=incoming.readString();
    values=split(data,";");
    values=split(values[0],",");
    rotX=(int(values[0])-64)*2;
    Float temp=float(values[1]);
    if (!temp.isNaN()){
      rotY=(int(values[1])-64)*4;
      }
    } 
  } catch (NullPointerException e){
    return;
  }catch (ArrayIndexOutOfBoundsException e){
    return;
  }
}
