/* @pjs preload="img/gamerandomizer/game1.png"; */
/* @pjs preload="img/gamerandomizer/game2.png"; */
/* @pjs preload="img/gamerandomizer/game3.png"; */
/* @pjs preload="img/gamerandomizer/game4.png"; */
/* @pjs preload="img/gamerandomizer/game5.png"; */
/* @pjs preload="img/gamerandomizer/game6.png"; */
/* @pjs preload="img/gamerandomizer/game7.png"; */
/* @pjs font="img/gamerandomizer/futura.ttf"; */

ArrayList<PImage> images;
boolean go;
int currentGame;

String[] names = new String[7];

void setup()
{
  size(500, 600);
  smooth();
  frameRate(60);
  
  textFont(createFont("futura", 30));
  
  go = false;
  currentGame = 0;
  
  images = new ArrayList<PImage>();
  images.add(loadImage("img/gamerandomizer/game1.png"));
  images.add(loadImage("img/gamerandomizer/game2.png"));
  images.add(loadImage("img/gamerandomizer/game3.png"));
  images.add(loadImage("img/gamerandomizer/game4.png"));
  images.add(loadImage("img/gamerandomizer/game5.png"));
  images.add(loadImage("img/gamerandomizer/game6.png"));
  images.add(loadImage("img/gamerandomizer/game7.png"));
  
  names[0] = "Step On Foot";
  names[1] = "Hand Slaps";
  names[2] = "Ninja";
  names[3] = "Rock Paper Scissors";
  names[4] = "Sword Fight";
  names[5] = "Thumb War";
  names[6] = "Turtle Wushu";
}

void draw()
{
  background(255);
  stroke(0);
  fill(0);
  
  image(images.get(currentGame), 0, 0, 500, 500);
  text(names[currentGame], 30, 580);
  
  if (go)
  {
    currentGame = (int)random(images.size());
  }
}

void mousePressed()
{
  go = !go;
}

