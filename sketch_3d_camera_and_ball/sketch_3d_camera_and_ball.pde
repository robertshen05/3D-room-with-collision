import java.awt.Robot;

//color pallette
color black = #000000; //oak planks 
color white = #FFFFFF;  //empty space
color dullBlue = #7092BE; //mossyBricks


//textures
PImage diamond;
PImage mossyStone;
PImage oakPlanks;

//Map variables
int gridSize;
PImage map;

ArrayList<Snowflake> snowList;

Robot rbt;

boolean wkey, akey, skey, dkey;

//rotation variable
float leftRightAngle;
float upDownAngle;

float eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz;

void setup() {
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  diamond = loadImage("diamon.png");
  oakPlanks = loadImage("Oak_Planks.png");
  textureMode(NORMAL);

  noCursor();
  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  leftRightAngle = 0;
  upDownAngle = 0;

  size (displayWidth, displayHeight, P3D);

  //snowList = new ArrayList<Snowflake>();
  //int i = 0;
  //while (i < 100) {
  //  snowList.add( new Snowflake() );
  //  i = i + 1;
  //}

  eyex = width/2;
  eyey = 9*height/10;
  eyez = height/2;

  focusx = width/2;
  focusy = height/2;
  focusz = height/2 - 300;

  upx = 0;
  upy = 1;
  upz = 0;

  //initializing map
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0); 

  //int i = 0;
  //while (i < 100) {
  //  Snowflake mySnowflake = snowList.get(i);
  //  mySnowflake.act();
  //  mySnowflake.show();
  //  i = i + 1;
  //}  

  pointLight(255, 255, 255, eyex, eyey, eyez);
  camera(eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz);
  move();

  drawAxis();
  drawFloor(-2000, 2000, height, gridSize); //floor
  drawFloor(-2000, 2000, height-gridSize*4, gridSize); //ceiling
  drawMap();

  drawInterface();
}

void drawInterface() {
  stroke (255);
  strokeWeight(5);
  line(width/2-15, height/2, width/2+15, height/2);
  line(width/2, height/2-15, width/2, height/2+15);
}


void drawAxis() {
  stroke(255, 0, 0);
  strokeWeight(3);
  line(0, 0, 0, 1000, 0, 0); //x axis
  line(0, 0, 0, 0, 1000, 0); //y axis
  line(0, 0, 0, 0, 0, 1000); //z axis
}

void move() {

  pushMatrix();
  translate(focusx, focusy, focusz);
  sphere(10);
  popMatrix();

  if (akey && canMoveLeft()) {
    eyex += cos(leftRightAngle - PI/2)*10;
    eyez += sin(leftRightAngle - PI/2)*10;
  }
  if (dkey && canMoveRight()) {
    eyex += cos(leftRightAngle + PI/2)*10;
    eyez += sin(leftRightAngle + PI/2)*10;
  }
  if (wkey && canMoveForward() ) {
    eyex += cos(leftRightAngle)*10;
    eyez += sin(leftRightAngle)*10;
  }
  if (skey && canMoveBackward()) {
    eyex -= cos(leftRightAngle)*10;
    eyez -= sin(leftRightAngle)*10;
  }


  focusx = eyex + cos(leftRightAngle)*300;
  focusy = eyey + tan(upDownAngle)*300;
  focusz = eyez + sin(leftRightAngle)*300;

  leftRightAngle = leftRightAngle + (mouseX - pmouseX)*0.01;
  upDownAngle = upDownAngle + (mouseY - pmouseY)*0.01;

  if (upDownAngle >  PI/2.5 ) upDownAngle = PI/2.5;
  if (upDownAngle < -PI/2.5 ) upDownAngle = -PI/2.5;

  if (mouseX > width-2) rbt.mouseMove(3, mouseY);
  if (mouseX < 2) rbt.mouseMove(width-3, mouseY);
}

boolean canMoveForward() {
  float fwdx, fwdy, fwdz;
  float leftx, lefty, leftz;
  float rightx, righty, rightz;
  int mapx, mapy;

  fwdx = eyex + cos(leftRightAngle)*100;
  //leftx = eyex + cos(leftRightAngle+radians(20))*100;
  //rightx = eyex + cos(leftRightAngle-radians(20))*100;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle)*100;

  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;

  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveLeft() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyex + cos(leftRightAngle - PI/2)*100;
  //leftx = eyex + cos(leftRightAngle+radians(20))*100;
  //rightx = eyex + cos(leftRightAngle-radians(20))*100;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle - PI/2)*100;

  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;

  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveRight() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyex + cos(leftRightAngle + PI/2)*100;
  //leftx = eyex + cos(leftRightAngle+radians(20))*100;
  //rightx = eyex + cos(leftRightAngle-radians(20))*100;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle + PI/2)*100;

  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;

  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveBackward() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyex - cos(leftRightAngle - PI/2)*100;
  //leftx = eyex + cos(leftRightAngle+radians(20))*100;
  //rightx = eyex + cos(leftRightAngle-radians(20))*100;
  fwdy = eyey;
  fwdz = eyez - sin(leftRightAngle- PI/2)*100;

  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;

  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}


void drawFloor(int floorStart, int floorEnd, int floorHeight, int floorSpacing) {
  stroke(255);
  strokeWeight(1);
  int x = floorStart;
  int z = floorStart;
  while (z < floorEnd) {
    texturedCube(x, floorHeight, z, oakPlanks, floorSpacing);
    //line(x, floorHeight, floorStart, x, floorHeight, floorEnd); 
    //line(floorStart, floorHeight, z, floorEnd, floorHeight, z); 

    x = x + floorSpacing;
    if (x>= floorEnd) {
      x = floorStart; 
      z = z + floorSpacing;
    }
  }
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossyStone, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, oakPlanks, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, oakPlanks, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, oakPlanks, gridSize);
      }
    }
  }
}
