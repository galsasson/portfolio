
Ocean ocean;
SineFish myFish;
ArrayList<SineFish> fish;

final int FISH_NUM = 10;
final float LIQUID_DRAG = 0.5;

boolean keyUp = false;
boolean keyRight = false;
boolean keyDown = false;
boolean keyLeft = false;

void setup()
{
  size(600, 400);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  frameRate(40);
  
  ocean = new Ocean();
  
  fish = new ArrayList();
  
  for (int i=0; i<FISH_NUM; i++)
  {
    float x = random(width*2) - width;
    float y = random(height*2) - height;
    float size = random(2, 16);
    int legs = (int)random(5, 20);
    fish.add(new SineFish(new PVector(x, y), size, legs, color(random(150)+140, 57, 100)));
  }
  
  myFish = new SineFish(new PVector(0, 0), 5, 10, color(56, 91, 100));
    
  
  background(0);
}

void draw()
{
  pushMatrix();
  
  translate(-myFish.pos.x+width/2, -myFish.pos.y+height/2);
  ocean.draw();
  
  for (int i=0; i<fish.size(); i++)
  {
    SineFish f = fish.get(i);
    
    f.setAllArmsSpeed(0.02);
    if (f.pos.dist(myFish.pos) < 50)
    {
      f.move(PVector.sub(f.pos,myFish.pos));
    }
    
    f.applyDrag(LIQUID_DRAG);
    
    f.update();
    f.draw();
  }
  
  myFish.setAllArmsSpeed(0.04);
  
  if (keyLeft)
    myFish.move(new PVector(-1, 0));
  if (keyUp)
    myFish.move(new PVector(0, -1));
  if (keyRight)
    myFish.move(new PVector(1, 0));
  if (keyDown)
    myFish.move(new PVector(0, 1));
  
  myFish.applyDrag(LIQUID_DRAG);
  
  myFish.update();
  
  myFish.draw();
  
  popMatrix();
  
}

void keyPressed()
{
  if (keyCode == UP)
    keyUp = true;
  else if (keyCode == RIGHT)
    keyRight = true;
  else if (keyCode == DOWN)
    keyDown = true;
  else if (keyCode == LEFT)
    keyLeft = true;
}

void keyReleased()
{
  if (keyCode == UP)
    keyUp = false;
  else if (keyCode == RIGHT)
    keyRight = false;
  else if (keyCode == DOWN)
    keyDown = false;
  else if (keyCode == LEFT)
    keyLeft = false;
}

class Ocean
{
  ArrayList<PVector> points;
  
  public Ocean()
  {
    points = new ArrayList();
    
    for (int i=0; i<500; i++)
    {
      points.add(new PVector(random(2000)-1000, random(2000)-1000));
    }
  }
  
  public void draw()
  {
    background(231, 100, 20);
    fill(0, 0, 100, 20);
    
    for (int i=0; i<points.size(); i++)
    {
      ellipse(points.get(i).x, points.get(i).y, 2, 2);
    }
  }
  
}



class SineArm
{
  final int ARM_LENGTH = 15;
  final float WAVE_DENSITY = 0.15;
  
  PVector pos;
  float speed;
  float rot;
  float t;
  
  float length;
  float armWidth;
  
  color tipColor;
  
  public SineArm(float rot, color tipColor)
  {
    this.pos = new PVector();
    this.rot = rot;
    this.tipColor = tipColor;
    
    t = random(0,100);
    speed = 0.02;
    length = ARM_LENGTH + random(4) - 2;
    armWidth=2;
  }
  
  public void setSpeed(float s)
  {
    speed = s;
  }
  
  public void update(float size)
  {
    pos.x = cos(rot)*(size);
    pos.y = sin(rot)*(size);
    armWidth = size/4;
    
    t-=speed;
  }
  
  public void draw()
  {
    pushMatrix();
    stroke(0, 0, 100, 20);
    strokeWeight(armWidth);
    translate(pos.x, pos.y);
    rotate(rot);
    
    for (int i=0; i<length; i+=4)
    {
      line(i, cos(t+i*WAVE_DENSITY)*8*((float)i/length), i+3, cos(t+(i+3)*WAVE_DENSITY)*8*((float)(i+3)/length));
    }
    
    noStroke();
    fill(tipColor);
    ellipse(length+1, cos(t+(length+1)*WAVE_DENSITY)*8*((float)(length+1)/length), 3, 3);
    
    popMatrix();
  }
}

class SineFish
{
  PVector pos;
  PVector vel;
  PVector acc;
  
  float angAcc;
  float angVel;
  float ang;
  
  float initialSize;
  float size;
  float mass;
  
  color tipColor;
  
  float t;
  
  ArrayList<SineArm> arms;
  
  public SineFish(PVector pos, float initSize, int numOfLegs, color tipColor)
  {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    
    initialSize = initSize;
    size = initialSize;
    mass = size*2;
    
    this.tipColor = tipColor;
    
    ang = 0;
    angVel = 0;
    angAcc = 0;
    
    arms = new ArrayList<SineArm>();
    
    for (float i=0; i<PI*2-0.01; i+=(PI*2)/numOfLegs)
    {
      arms.add(new SineArm(i, tipColor));
    }
    
    t=0;
  }
  
  public void setArmsSpeed(float angle, float speed)
  {
    for (int i=0; i<arms.size(); i++)
    {
      float angleDiff = abs(angle - (ang+arms.get(i).rot));
      if (angleDiff > PI*2)
            angleDiff -= PI*2;
            
      if (angleDiff < PI/3 || angleDiff > 2*PI-(PI/3))
            arms.get(i).setSpeed(speed);
    }
  }
  
  public void setAllArmsSpeed(float speed)
  {
    for (int i=0; i<arms.size(); i++)
    {
      arms.get(i).setSpeed(speed);
    }    
  }
  
  public void applyDrag(float c)
  {
    float speed = vel.mag();
    float dragMag = c * speed * speed;
    
    PVector drag = vel.get();
    drag.mult(-1);
    drag.normalize();
    drag.mult(dragMag);
    applyForce(drag);
  }
  
  public void applyForce(PVector force)
  {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
  
  public void update()
  {
    vel.add(acc);
    pos.add(vel);
    
    acc.mult(0);
    t+=0.01;
    
    angVel += angAcc;
    ang += angVel;
    if (ang > PI*2)
          ang -= PI*2;
    angAcc = 0;
    
    // like friction for angular motion
    angVel *= 0.9;
          
    size = initialSize+noise(t)*3;
    
    for (int i=0; i<arms.size(); i++)
          arms.get(i).update(size);
    
  }
  
  public void draw()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(ang);
    
    fill(0, 0, 100, 20);
    noStroke();
    ellipse(0, 0, size*2, size*2);
    
    for (int i=0; i<arms.size(); i++)
          arms.get(i).draw();
    
    popMatrix();

  }
  
  public void move(PVector d)
  {
    d.normalize();
    applyForce(d);
    d.mult(-1);
    setArmsSpeed(d.heading2D(), 0.3);
    
    if (d.heading2D()>1)
      angAcc = -0.002;
    else
      angAcc = 0.002;    
  }
}

