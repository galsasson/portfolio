



ArrayList<Particle> particles = new ArrayList();
ArrayList<Emitter> emitters = new ArrayList();
ArrayList<BlowerForce> blowers = new ArrayList();

PVector gravity = new PVector(0, 0.5);

String drawMode = "emitter";
PVector click1, click2;
boolean drag = false;

PFont font = createFont("Monospaced-12.vlw", 12);

PGraphics buf;
PImage img;

void setup()
{
  colorMode(HSB, 360, 100, 100, 255);
  size(600, 400);
  smooth();
  
  buf = createGraphics(width, height);
  clearTrails();
  
  background(0);
  frameRate(30);
}

void clearTrails()
{
  buf.beginDraw();
  buf.smooth();
  buf.background(0);
  buf.strokeWeight(1);
  buf.stroke(255, 255, 255, 10);
  buf.textFont(font);
  buf.text("'e' - draw emitter mode (click&drag to draw)", 10, 20);
  buf.text("'w' - draw wind mode (click&drag to draw)", 10, 32);
  buf.text("'c' - clear forces", 10, 44);
  buf.text("'q' - clear particle trails", 10, 56);
  buf.endDraw();
}

void draw()
{
  /* draw the particles paths image */
  image(buf, 0, 0);

  /* draw the emitters and make them emit particles */
  for (int i=0; i<emitters.size(); i++)
  {
    Emitter e = emitters.get(i);
    e.draw();
    
    /* emit particle */
    Particle p = e.emit();
    if (p != null)
      particles.add(p);
  }
  
  /* draw the blowers */
  for (int i=0; i<blowers.size(); i++)
  {
    BlowerForce bf = blowers.get(i);
    bf.draw();
  }
  
  /* update and draw particles */
  int i=0;
  while (i<particles.size())
  {
    Particle p = particles.get(i);
    
    /* apply gravity force on the particle */
    p.applyForce(PVector.mult(gravity, p.mass));
    
    /* apply blower forces on the particle */
    for (int j=0; j<blowers.size(); j++)
    {
      BlowerForce bf = blowers.get(j);
      p.applyForce(bf.getForce(p.pos));
    }
    
    /* update the particle position */
    p.update();
    
    /* draw the particle on screen and its path on the off-screen buffer */
    buf.beginDraw();
    p.draw(buf);
    buf.endDraw();
    
    /* if the particle is off screen remove it from the list */
    if (!p.isAlive())
          particles.remove(i);
    else
          i++;
  }

  /* draw drag line */  
  if (drag)
  {
    strokeWeight(1);
    
    if (drawMode == "emitter")
          stroke(255, 255, 255, 255);
    if (drawMode == "wind") {
          stroke(200, 100, 80, 255);
          noFill();
          float size = sqrt(pow(mouseX-click1.x, 2) + pow(mouseY-click1.y, 2));
          ellipse(click1.x, click1.y, size*2, size*2);
    }
    
    line(click1.x, click1.y, mouseX, mouseY);
  }

}


void keyPressed()
{
  if (key == 'e')
        drawMode = "emitter";
  else if (key == 'w')
        drawMode = "wind";
  else if (key == 'c')
  {
        blowers.clear();
        emitters.clear();
  }
  else if (key == 'q')
  {
    clearTrails();
  }
}

void mousePressed()
{
  click1 = new PVector(mouseX, mouseY);
  drag = true;
}

void mouseReleased()
{
  if (drag)
  {
    click2 = new PVector(mouseX, mouseY);
    drag = false;
    
    if (drawMode == "emitter")
          emitters.add(new Emitter(click1.get(), PVector.sub(click2, click1)));
    else if (drawMode == "wind")
          blowers.add(new BlowerForce(click1.get(), PVector.sub(click2, click1)));
  }
}

class BlowerForce
{
  PVector pos;
  PVector direction;
  
  float strength;
  
  public BlowerForce(PVector pos, PVector force)
  {
    this.pos = pos;
    strength = force.mag();
    force.normalize();
    direction = force;
  }
  
  public PVector getForce(PVector ppos)
  {
    float distanceFromCenter = PVector.sub(ppos, pos).mag();
    
    if (distanceFromCenter < strength) 
        return PVector.div(PVector.mult(direction, strength*4),distanceFromCenter);
    else
        return new PVector(0, 0);
  }
  
  public void draw()
  {
    fill(200, 100, 80, 120);    
    noStroke();
    ellipse(pos.x, pos.y, strength*2, strength*2); 
    
    strokeWeight(2);
    stroke(200, 100, 80, 255);
    line(pos.x, pos.y, pos.x + strength*direction.x, pos.y + strength*direction.y);
  }
}

class Emitter
{
  PVector pos;
  PVector direction;
  
  int counter;
  
  float tSpeed, tMass;
  
  public Emitter(PVector pos, PVector direction)
  {
    this.pos = pos;
    this.direction = direction;
    
    tSpeed = 0;
    tMass = 10000;
    counter = 3;
  }
  
  public Particle emit()
  {
    if (counter-- == 0)
    {
      counter = 0;
      tSpeed += 0.1;
      tMass += 0.1;
    
      return new Particle(PVector.add(pos, direction), 
                          PVector.mult(direction, 0.2+noise(tSpeed)*0.1),
                          7*noise(tMass), color(10+random(50), 100, 80));
    }
    
    return null;
  }
  
  public void draw()
  {
    stroke(0, 0, 255, 200);
    strokeWeight(5);
    
    line(pos.x, pos.y, pos.x + direction.x, pos.y + direction.y);
  }
  
}

class Particle
{
  PVector pos;
  PVector vel;
  PVector acc;
  float mass;
  
  PVector prevPos;
  
  color c;
  
  public Particle(PVector pos, PVector vel, float mass, color c)
  {
    acc = new PVector(0, 0);
    
    this.pos = pos;
    prevPos = pos.get();
    this.vel = vel;
    this.mass = mass;
    this.c = c;
  }
  
  public void applyForce(PVector force)
  {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
  
  public void update()
  {
    prevPos = pos.get();
    
    vel.add(acc);
    pos.add(vel);
    
    acc.mult(0);
  }
  
  public void checkEdges()
  {
    if (pos.x < 20)
          applyForce(new PVector(40/abs(pos.x), 0));
    
    if (pos.x > width-20)
          applyForce(new PVector(-40/abs(width-pos.x), 0));
        
    if (pos.y < 20)
          applyForce(new PVector(0, 40/abs(pos.y)));
    
    if (pos.y > height-20)
          applyForce(new PVector(0, -40/abs(height-pos.y)));
  }
  
  public void draw(PGraphics buf)
  {
    noStroke();
    fill(c, 255);
    
    ellipse(pos.x, pos.y, 1+mass, 1+mass);
    
    /* draw the path on the off-screen buffer */
    buf.line(prevPos.x, prevPos.y, pos.x, pos.y);
  }
  
  public boolean isAlive()
  {
    if (pos.y > height)
          return false;
    
    return true;
  }
}


