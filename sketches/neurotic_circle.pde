
NeuroticCircle nc;

void setup()
{
  size(550, 250);
  smooth();
  frameRate(40);
  noStroke();
  
  nc = new NeuroticCircle();  
}

void draw()
{
  background(nc.getAngerLevel()*50, 0, 0);
  
  nc.move();
  nc.draw();
}



class NeuroticCircle
{
  /* start shake and posibly chase the mouse at this level of anger */
  final float SHAKE_THRESHOLD = 0.6;
  
  /* always chase the mouse at this level of anger */
  final float CHASE_THRESHOLD = 0.95;
  
  PVector pos;
  float tVer, tHor, tShape, tShake, tChase;
  
  /* level of anger goes from 0 (calm) to 1 (angry!!!) */
  float angerLevel;
  
  public NeuroticCircle()
  {
    pos = new PVector(width/2, height/2);
    angerLevel = 0;
    
    tVer = 0;
    tHor = 10000;
    tShape = 20000;
    tShake = 30000;
    tChase = 40000;
  }
  
  public void move()
  {
    /* calculate the vector between the mouse and the circle */
    PVector evade = new PVector(pos.x-mouseX, pos.y-mouseY);
    
    /* find the distance between the mouse and the circle */
    float distance = evade.mag();
    
    /* Check if the mouse disturb the privacy of the circle.
     * The level of anger increases what is considered
     * to be invasion of privacy.
     */
    if (distance < 50+(angerLevel*100))
    {
      /* if angerLevel is above CHASE_THRESHOLD then always chase the mouse.
       * If angerLevel is above SHAKE_THRESHOLD give 50% for chase and 50% for evade.
       */
      if (angerLevel > CHASE_THRESHOLD ||
            (angerLevel > SHAKE_THRESHOLD && noise(tChase) > 0.5)) 
      {
            /* invert the evade vector making it a chase vector */
            evade.mult(-1);
            
            /* add the vector to the current position in proportion to the distance:
             * the circle will move towards the mouse faster when he is far away.
             */
            evade.normalize();            
            pos.add(PVector.mult(evade, distance/5));
      }
      else 
      {     
            /* evade from the mouse in proportion to the distance to him:
             * the circle will move away from the mouse faster when the mouse is close.
             */        
            evade.normalize();
            pos.add(PVector.mult(evade, 50/distance));
      }
      
      /* the mouse disturbs our privacy, increase anger level */
      if (angerLevel < 1)
            angerLevel += 0.002;
    }
    else {
      /* the mouse does not disturb our privacy, decrease anger level */
      if (angerLevel > 0)
            angerLevel -= 0.008;
    }
    
    
    /* add shake movement to the circle in proportion to the anger level */
    if (angerLevel > SHAKE_THRESHOLD) {
      tShake += 1.5;
      pos.x += sin(tShake)*(((angerLevel-SHAKE_THRESHOLD)/0.35)*10);
    }
    
    /* always add random noise (neuroza) to movement */
    PVector neuroza = new PVector(noise(tVer)-0.48, 
                                  noise(tHor)-0.48); 
    neuroza.mult(7+angerLevel*12);
    pos.add(neuroza);    
    
    /* increase perlin noise variables */    
    tVer += 0.2;
    tHor += 0.2;
    tChase += 0.1;
    
    /* keep the circle inside the screen */
    if (pos.x < 20)
          pos.x = 20;
    else if (pos.x > width-20)
          pos.x = width-20;
    
    if (pos.y < 20)
          pos.y = 20;
    else if (pos.y > height-20)
          pos.y = height-20;
  }
  
  public void draw()
  {
    /* more angry - more red */
    fill(100 + (angerLevel*155), 100-(angerLevel*100), 100-(angerLevel*100), 255);
    
    /* add individual circles with some noise
     * that depends on the anger level.
     */
    for (float i=0; i<PI*2; i+=0.05)
    {
      ellipse(pos.x + sin(i)*(20+noise(tShape)*(5+(angerLevel*8))), 
              pos.y + cos(i)*(20+noise(tShape)*(5+(angerLevel*8))), 2, 2);
              
      tShape += 0.2;
    }
  }
  
  public float getAngerLevel()
  {
    return angerLevel;
  }
}

