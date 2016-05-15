console.log("aaa");

var Stem = function(maxHeight)
{
  this.maxHeight = maxHeight;
  this.maxWidth = 0.8*maxHeight;
  this.x = 0;
  this.y = 0;

  this.src = createVector(0, 0);
  this.dst = createVector(0, 0);
  this.c1 = new p5.Vector(0, 0);
  this.c2 = new p5.Vector(0, 0);
    
  this.c2Delta = new p5.Vector(14, 0);
  this.time = random(100);
    
  this.breathSpeed = random(0.02, 0.04);
  this.maxSpeed = random(0.06, 0.1);
  this.active = 0;
  
  this.update = function()
  {
    var mouse = createVector(mouseX-this.x, mouseY-this.y);
    
    this.src.x = 0;
    this.src.y = 0;
    var prevHead = createVector(this.dst.x, this.dst.y);
    var newHead = new p5.Vector(0.7*clamp(mouse.x, -this.maxWidth, this.maxWidth),
        clamp(mouse.y, -this.maxHeight, 20));
    
    var headOffset = p5.Vector.sub(newHead,prevHead).mult(this.maxSpeed);
    this.dst.add(headOffset);
    this.active += headOffset.mag();
    
    this.c1.x = 0;
    this.c1.y = -0.3*maxHeight;
    
    var oldC2 = this.c2;
    var opMouse = p5.Vector.sub(this.dst, mouse);
    opMouse.limit(0.3*this.maxHeight);
    var newC2 = p5.Vector.add(opMouse.mult(1.0), this.dst);
    var c2Offset = p5.Vector.sub(newC2, oldC2).mult(this.maxSpeed*2);
    this.c2.add(c2Offset);
    this.active += c2Offset.mag();
    
    this.c2Delta.rotate(this.breathSpeed*(this.active*0.01));
    
    this.time += 0.002;
    if (this.active < 1) {
      this.active = 1;
    }
    else {
      this.active *= 0.99;
    }
    
  }
  
  this.draw = function(mousePressed)
  {
    push();
    translate(this.x, this.y);
    
    var finalDest = p5.Vector.add(this.dst, createVector(0, 20*(noise(this.time)-0.5))); 
    
    if (mousePressed) {
      noFill();
      strokeWeight(0.5);
      stroke(255, 0, 0);
      line(this.src.x, this.src.y, this.c1.x, this.c1.y);
      line(finalDest.x, finalDest.y, this.c2.x+this.c2Delta.x, this.c2.y+this.c2Delta.y);
      line(finalDest.x, finalDest.y, this.c2.x, this.c2.y);
      fill(255, 0, 0);
      ellipse(this.c1.x, this.c1.y, 2, 2);
      ellipse(this.c2.x, this.c2.y, 3, 3);
      ellipse(this.c2.x+this.c2Delta.x, this.c2.y+this.c2Delta.y, 2, 2);
      noFill();
      ellipse(this.c2.x, this.c2.y, this.c2Delta.mag()*2, this.c2Delta.mag()*2);
    }

    //noStroke();
    stroke(0, 0, 0);
    fill(0, 0, 0);
    strokeWeight(2);
    beginShape();
    vertex(this.src.x, this.src.y);
    bezierVertex(this.c1.x, this.c1.y, 
        this.c2.x+this.c2Delta.x, this.c2.y+this.c2Delta.y, 
        finalDest.x, finalDest.y);
    bezierVertex(this.c2.x+this.c2Delta.x, this.c2.y+this.c2Delta.y,
        this.c1.x, this.c1.y, 
        this.src.x+log(0.90)*this.maxHeight, this.src.y);
    endShape(true);
    
    var headSize = Math.log(0.96)*this.maxHeight;
    fill(0, 0, 0);
    ellipse(finalDest.x, finalDest.y, headSize, headSize);
    
    pop();
  }
  
  var clamp = function(v, min, max)
  {
    return (v<min)?min:(v>max)?max:v;
  }
}