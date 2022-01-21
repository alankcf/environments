//Alan Fung
//January 2022

import java.awt.Robot;

boolean skipFrame;

//colors
color black = #000000; //oak
color white = #FFFFFF; //empty space 
color blue = #7092BE;  //bricks

//textures
PImage stone;
PImage oak;

//Map
int gridSize;
PImage map;

//mouse controls
Robot rbt;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle; //side to side

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  upX = 0;
  upY = 1;
  upZ = 0;
  leftRightHeadAngle = radians(270); //upDownHeadAngle
  //noCursor();
  try {
    rbt = new Robot();
  }
  catch (Exception e) { //catch errors and stop crashes
    e.printStackTrace();
  }
  
  //map
  map = loadImage("map.png");
  gridSize = 100;
  
  //textures
  oak = loadImage("oak.jpg");
  stone = loadImage("stone.jpg");
  textureMode(NORMAL);  
  
  skipFrame = false;
}

void draw() {
  background(0);
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ); //light from a particular location
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  drawFloor(-2000, 2000, height, gridSize); //floor
  drawFloor(-2000, 2000, height-gridSize*4, gridSize); //ceiling
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
   for (int y = 0; y < map.height; y++) {
    color c = map.get(x, y);
    if (c == blue || c == black) {
      texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, stone, gridSize);
      texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, stone, gridSize); 
      texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, stone, gridSize); 
    }
    //if (c == black) {
    //  texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, oak, gridSize);
    //  texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, oak, gridSize); 
    //  texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, oak, gridSize); 
    //}
   }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix(); //translate ends 
}

void drawFloor(int start, int end, int level, int gap) { //int x, int y, int z, int rx) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
   //line(x, level, start, x, level, end);
   //line(start, level, z, end, level, z);
   texturedCube(x, level, z, oak, gap);
   x = x + gap;
   if (x >= end) {
     x = start;
     z = z + gap;
   }
  }
  //for (int x = -2000; x <= 2000; x = x + rx) {
  //  line(x, z, a, x, z, y);
  //  line(a, z, x, y, z, x);
  //}
}

void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2)*10;
  }
  
  //mouse controls
  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  
  //limits
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;
  
  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  
  if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    rbt.mouseMove(width-2, mouseY);
    skipFrame = true; 
  } else skipFrame = false;
}

void keyPressed() {
  if (keyCode == 'W' || key == 'w')   wkey = true;
  if (keyCode == 'S' || key == 's')   skey = true;
  if (keyCode == 'A' || key == 'a')   akey = true;
  if (keyCode == 'D' || key == 'd')   dkey = true;
}

void keyReleased() {
  if (keyCode == 'W' || key == 'w')   wkey = false;
  if (keyCode == 'S' || key == 's')   skey = false;
  if (keyCode == 'A' || key == 'a')   akey = false;
  if (keyCode == 'D' || key == 'd')   dkey = false;
} 
