class Snowflake {
  
  //1. Instance variables: the data that each snowflake
  //                       needs to keep track of.
  float x, y, size, speed;
  
  //2. Constructor(s): initializes the instance variables.
  //   Rules: no return type (void), name matches class
  Snowflake() {
    x = random(0, width);
    y = random(0, height); 
    size = random(3,10);
    speed = size;
  }
  
  //3. Behaviour Functions: functions that describe how
  //                        Snowflakes act and look.
  void act() {
    y = y + speed;
    if (y > height) {
      y = 0;
      x = random(0,width);
    }
  }
  
  void show() {
    rect(x, y, size, size);
  }

}
