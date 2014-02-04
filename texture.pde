// ******************************************************************************************************************
//
// MACROS
//
// ******************************************************************************************************************

final int CANVAS_WIDTH = 1280;
final int CANVAS_HEIGHT = 800;
final boolean FULLSCREEN = true;
final int SCREEN_CLEAR = 0;
final boolean DEBUG = false;
final int FRAMERATE = 60;
final int GRID_WIDTH = 35;
final int GRID_HEIGHT = 27;
final int PADDING = 0;
final float MAXVEC = 4.0;








// ******************************************************************************************************************
//
// CLASS DEFINITIONS
//
// ******************************************************************************************************************

class node {
  float x;
  float y;
  float vx;
  float vy;
  float maxv;
  node(float X, float Y, float VX, float VY, float maxvec){
    x = X;
    y = Y;
    vx = VX;
    vy = VY;
    maxv = maxvec;
  }
  float getx(){
    return x;
  }
  float gety(){
    return y;
  }
  float getvx(){
    return vx;
  }
  float getvy(){
    return vy;
  }
  void set(float varx, float vary){
    x = varx;
    y = vary;
  }
  void setv(float varx, float vary){
    vx = varx;
    vy = vary;
  }
};







// ******************************************************************************************************************
//
// GLOBAL VARIABLES
//
// ******************************************************************************************************************

int oldFrame = millis();
int newFrame = millis();
node[][] grid = new node[GRID_WIDTH][GRID_HEIGHT];
float brightness = 1.0;
int FPS = 0;
int frame = 0;





// ******************************************************************************************************************
//
// SETUP
//
// ******************************************************************************************************************

boolean sketchFullScreen(){
  return FULLSCREEN;
}

void setup(){
  size(CANVAS_WIDTH, CANVAS_HEIGHT);
  background(SCREEN_CLEAR);
  frameRate(FRAMERATE);
  float pad = (float) PADDING / 2;
  float wbuf = ((float) CANVAS_WIDTH - PADDING) / ((float) GRID_WIDTH - 1);
  float hbuf = ((float) CANVAS_HEIGHT - PADDING) / ((float) GRID_HEIGHT - 1);
  for(int i = 0; i < GRID_WIDTH; i++){
    for(int j = 0; j < GRID_HEIGHT; j++){
      grid[i][j] = new node(i * wbuf + pad, j * hbuf + pad, 0, 0, MAXVEC);
    }
  }
  stroke(255);
  //noStroke();
  textSize(70);
}













// ******************************************************************************************************************
//
// CORE METHODS
//
// ******************************************************************************************************************

void draw(){
  background(SCREEN_CLEAR);
  updateFPS();
  updateCity();
  drawCity();
  frame++;  
}

void updateFPS(){
  newFrame = millis();
  if(newFrame - oldFrame > 1000){
    print("FPS: ");
    print(FPS);
    print(" | Avg. frame time: ");
    print((newFrame - oldFrame)/FPS);
    print("ms\n");
    FPS = 0;
    oldFrame = newFrame;
  }
  FPS++;
  if(oldFrame < 0){
    oldFrame = 0;
    newFrame = 0;
  }
}

void updateCity(){
  float maxx, minx, maxy, miny;
  boolean toprow, bottomrow, rightcolumn, leftcolumn;
  for(int i = 0; i < GRID_WIDTH; i++){
    for(int j = 0; j < GRID_HEIGHT; j++){
      maxx = grid[i][j].getx();
      minx = maxx;
      miny = grid[i][j].gety();
      maxy = miny;
      toprow = (j == 0);
      bottomrow = (j == GRID_HEIGHT - 1);
      leftcolumn = (i == 0);
      rightcolumn = (i == GRID_WIDTH - 1);
      
      if(toprow){
        miny = 0;
        if(rightcolumn){
          maxx = CANVAS_WIDTH;
          minx = max(grid[i - 1][j].getx(), grid[i - 1][j + 1].getx());
          maxy = min(grid[i - 1][j + 1].gety(), grid[i][j + 1].gety());
        } else if(leftcolumn){
          maxx = min(grid[i + 1][j].getx(), grid[i + 1][j + 1].getx());
          minx = 0;
          maxy = min(grid[i][j + 1].gety(), grid[i + 1][j + 1].gety());
        } else {
          maxx = min(grid[i + 1][j].getx(), grid[i + 1][j + 1].getx());
          minx = max(grid[i - 1][j].getx(), grid[i - 1][j + 1].getx());
          maxy = min(grid[i - 1][j + 1].gety(), grid[i][j + 1].gety(), grid[i + 1][j + 1].gety());
        }
      } else if(bottomrow){
        maxy = CANVAS_HEIGHT;
        if(rightcolumn){
          maxx = CANVAS_WIDTH;
          minx = max(grid[i - 1][j].getx(), grid[i - 1][j - 1].getx());
          miny = max(grid[i - 1][j - 1].gety(), grid[i][j - 1].gety());
        } else if(leftcolumn){
          maxx = min(grid[i + 1][j].getx(), grid[i + 1][j - 1].getx());
          minx = 0;
          miny = max(grid[i][j - 1].gety(), grid[i + 1][j - 1].gety());
        } else {
          maxx = min(grid[i + 1][j - 1].getx(), grid[i + 1][j].getx());
          minx = max(grid[i - 1][j - 1].getx(), grid[i - 1][j].getx());
          miny = max(grid[i - 1][j - 1].gety(), grid[i][j - 1].gety(), grid[i + 1][j - 1].gety());
        }
      } else {
        if(rightcolumn){
          maxx = CANVAS_WIDTH;
          minx = max(grid[i - 1][j + 1].getx(), grid[i - 1][j].getx(), grid[i - 1][j + 1].getx());
          maxy = min(grid[i - 1][j + 1].gety(), grid[i][j + 1].gety());
          miny = max(grid[i - 1][j - 1].gety(), grid[i][j - 1].gety());
        } else if(leftcolumn){
          maxx = min(grid[i + 1][j + 1].getx(), grid[i + 1][j].getx(), grid[i + 1][j - 1].getx());
          minx = 0;
          maxy = min(grid[i + 1][j + 1].gety(), grid[i][j + 1].gety());
          miny = max(grid[i + 1][j - 1].gety(), grid[i][j - 1].gety());
        } else {
          maxx = min(grid[i + 1][j + 1].getx(), grid[i + 1][j].getx(), grid[i + 1][j - 1].getx());
          minx = max(grid[i - 1][j - 1].getx(), grid[i - 1][j].getx(), grid[i - 1][j + 1].getx());
          maxy = min(grid[i - 1][j + 1].gety(), grid[i][j + 1].gety(), grid[i + 1][j + 1].gety());
          miny = max(grid[i - 1][j - 1].gety(), grid[i][j - 1].gety(), grid[i + 1][j - 1].gety());
        }
      }
      
      
      if(toprow) maxy = 0;
      if(bottomrow) miny = CANVAS_HEIGHT;
      if(leftcolumn) maxx = 0;
      if(rightcolumn) minx = CANVAS_WIDTH;
            
      
      node n = grid[i][j];
      move(n, maxx, minx, maxy, miny);
    }
  }
}

void drawCity(){
  for(int i = 1; i < GRID_WIDTH; i ++){
    for(int j = 1; j < GRID_HEIGHT; j++){
      //connect(grid[i][j], grid[i - 1][j]);
      //connect(grid[i][j], grid[i][j - 1]);
      myfill(grid[i][j], grid[i][j - 1], grid[i - 1][j - 1], grid[i - 1][j]);
    }
    //connect(grid[i][0], grid[i - 1][0]);
  }
  for(int j = 1; j < GRID_HEIGHT; j++){
    //connect(grid[0][j], grid[0][j - 1]);
  }      
}



// ******************************************************************************************************************
//
// HELPER FUNCTIONS
//
// ******************************************************************************************************************

void connect(node i, node j){
  line(i.getx(), i.gety(), j.getx(), j.gety());
}

void move(node n, float maxx, float minx, float maxy, float miny){
  float randspeed = 0.2;
  float newx = n.getx() + n.getvx();
  float newy = n.gety() + n.getvy();
  float newvx = min(MAXVEC, max(-1 * MAXVEC, n.getvx() + random(randspeed) - randspeed/2));
  float newvy = min(MAXVEC, max(-1 * MAXVEC, n.getvy() + random(randspeed) - randspeed/2));
  if(newx > maxx || newx < minx) newvx = -1 * newvx;
  if(newy > maxy || newy < miny) newvy = -1 * newvy;
  newx = max(min(newx, maxx), minx);
  newy = max(min(newy, maxy), miny);
  n.set(newx, newy);
  n.setv(newvx, newvy);
}

void myfill(node n1, node n2, node n3, node n4){
  int c = (int) ((abs(n1.getx() - n3.getx()) + abs(n2.getx() - n4.getx())) * brightness);
    
  float d = ((float) c) / 255.0;
  //c = (int) (d * d * 255);
  int r, g, b;
  g = c;
  r = c/2;
  b = c;
  if(c > 150){
    b = min(b, 240) - min(70, c - 150);
    g = min((int) (g + (r - 75) * 1.5), 140);
  } else {
    b = (b + 150) / 2;
  }
  if(c < 110){
    r = 0;
  } else {
    r = (c - 110) * 5;
    g += (c - 110) * 2;
  }
  
  
  stroke(r, g, b);
  fill(r, g, b);
  quad(n1.getx(),
    n1.gety(),
    n2.getx(),
    n2.gety(),
    n3.getx(),
    n3.gety(),
    n4.getx(),
    n4.gety());
}
