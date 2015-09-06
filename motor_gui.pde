import processing.serial.*;
import javax.swing.*; 
float bx=100;
float by=50;

int boxSize = 125;
boolean overBox = false;
boolean locked = false, startMotor = false;

float padding = 10;
Serial port;
String inString;int end = 10;
float oldX = 0.0, oldY = 0.0, oldZ = 0.0;

int lf = 10, i = 0;
float translateX,translateY;
int paddingX = 0;

void setup() {
  size(1000, 1000, OPENGL);
  textSize(12);
  background(128);
  port = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  port.bufferUntil(lf);
  port.clear();
  buildGUI();
}


void draw() {
//     rotateX(-mouseY * 0.001);
//     rotateY(mouseX * 0.001);

 if(!(x == 0 && y == 0.0 && z ==0.0) && startMotor){
   translate(width/2, height/2);
   rotate(10.0,10.0,10.0,10.0);
   checkMin(x,y,z);
   line(oldX,oldY,oldZ,x,y,z);stroke(50);
   noFill();
   box(500);
   oldX = x; oldY = y; oldZ = z;
  // println(x+ "        "  +y+ "        "  +z);
 }
 x = 0;y =0;z=0;
}

float xMax = 0.0, yMax = 0.0, zMax = 0.0;

void checkMin(float x, float y, float z){
  if(abs(x) > xMax){
     xMax = abs(x);
     // println("MAX CHANGED " + xMax + " "  +yMax+ " "  +zMax);println();
  }
   
  if(abs(y) > yMax){
     yMax =  abs(y);
     // println("MAX CHANGED " + xMax + " "  +yMax+ " "  +zMax);println();
  }
     
  if(abs(z) > zMax){
     zMax =  abs(z);
     // println("MAX CHANGED " +  xMax + " "  +yMax+ " "  +zMax);println();
  }
     
     
}
void checkMouse(){
     if (mouseX > translateX - bx && mouseX < translateX + bx && 
          mouseY > 0 && mouseY <  by) {
        overBox = true;  
        if(!locked) { 
          //stroke(255); 
         // fill(153);
        } 
     } else if(mouseX > translateX + bx/2 + padding && mouseX < translateX + 3*bx/2 && 
          mouseY > 0 && mouseY <  by){
        port.write("stop1");
     }else
       {
       // stroke(153);
       // fill(153);
        overBox = false;
     }
}


void buildGUI(){
  
   pushMatrix();
   translateX = width/2;
   translateY= height/2;
   translate(translateX, 0);
   rect(0-bx/2, 0, bx, by,10); 
   rect(bx/2 + padding, 0, bx, by,10); 
   fill(204, 102, 0);
   text("START MOTOR", 0-bx/2 + padding/2, by/2);
   text("STOP MOTOR", bx/2 + 3*padding/2, by/2);
   popMatrix();
 }

 void serialEvent(Serial p) { 
     try{
        readCamera();
     }
     catch(RuntimeException e) {
      e.printStackTrace();
    }
  } 

void mousePressed() {
  rotateX(-mouseY * 0.001);
     rotateY(mouseX * 0.001);
  checkMouse();
  if(overBox) { 
    println("stop clicking me");
    port.write("start");
    locked = true;
    startMotor = true;
  } else {
    locked = false;
  }
}

void mouseReleased() {
  locked = false;
}
float x,y,z;
void readCamera(){
   //if (port != null && port.available() > 0) {
       inString = port.readString();
       //println(inString);
        if(inString != null && !inString.equals("null") 
          && inString != "" && inString != " " && !inString.isEmpty()){
            String[] coords = inString.split(" ");
            
            float phi = float(coords[0])* PI/180.0;
            float theta = float(coords[1]) * PI/180.0;
            float r = float(coords[2]);
             println(coords[0]); 
             x = r * sin(theta) * cos(phi);
             y = r * sin(theta) * sin(phi);
             z = r * cos(theta);
       }
  // }
  
}


