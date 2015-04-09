import hypermedia.net.*;
import processing.net.*;
import processing.opengl.*;

UDP udp;
Server server;
float rotX=0;
float rotY=0;
float speed=0;
String data="";
String display="0,0";
String[] values={"0","0"};
float SPRING_CONSTANT=1;
long xlastmillis=0;
long ylastmillis=0;

void setup(){
  size(1000, 1000, OPENGL);
  server=new Server(this, 4444);
  udp=new UDP(this,4445);
  udp.log(true);
  udp.listen(true);
  
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

void receive(byte[] data){
  try{
    //String convert=new String(data);  
    int x=int(data[0]);
    int y=int(data[1]);
    println(x+","+y);
    //values=split(convert,";");
    //values=split(values[0],",");
    rotX=0; //acceleration(rotX,(max(min(((x-125)*2),255),-255)),rotX,millis()-xlastmillis);
    xlastmillis=millis();
    Float temp=float(values[1]);
    if (!temp.isNaN()){
      rotY=max(min(int(acceleration(((-y+125)*2),rotY,rotY,millis()-ylastmillis)),255),-255);
      ylastmillis=millis();
      }

  } catch (NullPointerException e){
    return;
  }catch (ArrayIndexOutOfBoundsException e){
    return;
  }
}


int acceleration(float target, float current, float velocity, float timestep){
  timestep=timestep/10000;
  float currentToTarget = target-current;
  float springForce = currentToTarget * SPRING_CONSTANT;
  float dampingForce = -velocity * 2 * sqrt(SPRING_CONSTANT);
  float force = springForce+dampingForce;
  velocity+=force*timestep;
  float displacement = velocity*timestep;
  return int(current+displacement);
}


