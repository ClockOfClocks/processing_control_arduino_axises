import processing.serial.*;
Serial port;

int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;

int minutesPos = 0;
int hoursPos = 90;
  

  void setup() {
  size(640, 360);
  stroke(0);
  
  int radius = min(width, height) / 2;
  
  secondsRadius = radius * 0.72;

  minutesRadius = radius * 0.60;
  hoursRadius = radius * 0.50;
  clockDiameter = radius * 1.5;
  
     
  cx = width / 2;
  cy = height / 2;

    println("Available serial ports:");
    println(Serial.list());

    try{
    //port = new Serial(this, Serial.list()[0], 9600);
    port = new Serial(this, "/dev/cu.wchusbserial1410", 9600);
    }catch(Exception e){
      System.err.println("Port busy???");
        exit(); 
    }
  }


JSONObject getJsonData(){
  JSONObject json = new JSONObject();
  json.setInt("m", minutesPos);
  json.setInt("h", hoursPos);
  
  return json;
}

  void draw() {
    
  background(255);
  
  // Draw the clock background
  fill(255);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);
  
  // Angles for sin() and cos() start at 3 o'clock;
  // subtract HALF_PI to make them start at the top
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
    
    
  m = map(minutesPos % 360, 0, 360, 0, TWO_PI) - HALF_PI;
  h = map(hoursPos % 360, 0, 360, 0, TWO_PI) - HALF_PI;
    
  // Draw the hands of the clock
  stroke(0);
  strokeWeight(10);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(15);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
  
  // Draw the minute ticks
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    vertex(x, y);
  }
  endShape();
  
  textSize(32);
  fill(0, 102, 153);
  text(hoursPos, 10, 30); 
  fill(0, 102, 153, 51);
  text(minutesPos, 10, 60);
  

  if (mousePressed) {
    float d = dist(width/2, height/2, mouseX, mouseY);
    float a = (degrees(atan2(mouseY-height/2, mouseX-width/2)) + 90 + 360) % 360;
    
    if( d < clockDiameter/2){
    hoursPos = parseInt(a);    
   }else{  
     minutesPos = parseInt(a);
   }
   
   port.write("R4500S" + minutesPos + "G" + hoursPos);

   
   
   //JSONObject json = getJsonData();
   //println(json.toString());
   while (port.available() > 0) {
    //println("ard");
    int inByte = port.read();
    println(inByte);
  }
  
      }
  }
