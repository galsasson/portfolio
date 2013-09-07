
int MAX_INTENSITY=30;


int enableDraw=1;

float scale;
PVector position;
PVector speed;

ArrayList trees;

void setup()
{
	size(900,640);
	background(30,30,30);
	smooth();
	frameRate(60);
	
	trees = new ArrayList();
	
	clearScreen();

	ellipseMode(CENTER);
	
}

void mousePressed()
{
	if (mouseX<100 && mouseY>height-50) {
		trees.clear();
	}
	else if (mouseX>width-100 && mouseY>height-50) {
		for (int i=0 ; i<trees.size() ; i++)
		{
			Tree t = (Tree)trees.get(i);
			t.startFall();
		}
	}
	else 
	{
		tree = new Tree(new PVector(mouseX, mouseY));
		trees.add(tree);
	}
}

void clearScreen()
{
	background(30);

	fill(40,40,40,255);
	strokeWeight(1);
	stroke(255,255,255,255);
	rect(0,height-50,100,49);	
	rect(width-100,height-50,100,49);	

	noStroke();	
}

void draw()
{
	clearScreen();

	for (int i=0 ; i<trees.size() ; i++)
	{
		Tree t = (Tree)trees.get(i);
		t.draw();
		t.tick();
	}
}

class Tree
{
	float branchTwistMaxAngle = 20;
	float branchTwistProb = 10;		// probability as percentage
	float splitAngleMin = 15;
	float splitAngleMax = 35;

	int splitStartMin = 60;
	int splitStartMax = 100;
	int splitEveryMin = 25;
	int splitEveryMax = 45;

	int startScale = 20;
	int branchLife = 350;

	Branch mainBranch;

	Tree(PVector position)
	{
		mainBranch = new Branch(this, position, new PVector(0, -1), 0);
	}

	void setScale(float scale)
	{
		int originalBranchLife = branchLife;

		startScale = (int)(scale*startScale);
		branchLife = pow(startScale, 2);
		if (branchLife<0) branchLife = 0;

		float factor = branchLife/originalBranchLife;

		//branchTwistMaxAngle *= scale;
		//branchTwistProb *= scale;		// probability as percentage
		//splitAngleMin *= scale;
		//splitAngleMax *= scale;

		splitStartMin = (int)(factor*splitStartMin);
		splitStartMax = (int)(factor*splitStartMax);
		splitEveryMin = (int)(factor*splitEveryMin);
		splitEveryMax = (int)(factor*splitEveryMax);


		mainBranch = new Branch(this, mainBranch.position, new PVector(0, -1), 0);
	}

	void startFall()
	{
		mainBranch.startFall();
	}

	void setStartScale(int scale)
	{
		startScale = scale;
		branchLife = pow(scale,2);
	}

	void setBranchTwist(float maxAngle, float prob)
	{
		branchTwistMaxAngle = maxAngle;
		branchTwistProb = prob;
	}

	void setSplitAngleRange(float min, float max)
	{
		splitAngleMin = min;
		splitAngleMax = max;
	}

	void setFirstSplitRange(int min, int max)
	{
		splitStartMin = min;
		splitStartMax = max;
	}

	void setSplitRange(int min, int max)
	{
		splitEveryMin = min;
		splitEveryMax = max;
	}

	void tick()
	{
		mainBranch.tick();
	}

	void draw()
	{
		mainBranch.draw();
	}

	float getSplitAngle()
	{
		int direction = random(2);
		float angle = random(splitAngleMax - splitAngleMin) + splitAngleMin;
		if (direction<1) angle*=-1;

		return angle;
	}

	int getFirstSplitCounter()
	{
		return (int)random(splitStartMax-splitStartMin) + splitStartMin;
	}

	int getSplitCounter()
	{
		return (int)random(splitEveryMax-splitEveryMin) + splitEveryMin;
	}

	bool shouldTwist()
	{
		int r = (int)random(100);
		return (r<branchTwistProb);
	}

	float getTwistAngle()
	{
		return (random(branchTwistMaxAngle) - (branchTwistMaxAngle/2));
	}

	color getNewColor()
	{
		color c;
//		c = color(204, random(255), 48);	// fire
//		c = color(0,0,0);			// black
		c = color(126, random(255), 187);	// glow
		return c;
	//	c = color(random(70), random(150), random(190));

	}

}

class Branch
{
	PVector position;
	PVector speed;
	float scale;
	color c;

	int counter;
	int splitCounter;
	int scaleCounter;
	int intensity;

	ArrayList branches;

	ArrayList circles;

	Tree parentTree;

	Branch(Tree tree, PVector startPos, PVector startSpeed, int _counter)
	{
		parentTree = tree;
		position = startPos;
		speed = startSpeed;
		counter = _counter;
	
		branches = new ArrayList();
		circles = new ArrayList();

		splitCounter = parentTree.getFirstSplitCounter();
		c = parentTree.getNewColor();
//		intensity=15;
		intensity=50;
	}

	void tick()
	{
		if (counter>parentTree.branchLife) return;

		// random rotation (swist)
		if (parentTree.shouldTwist())
		{
			// rotate speed
			float angle = parentTree.getTwistAngle();
			rotateBy(speed, angle);
		}
		
		if (splitCounter==0)
		{
			// create new branch
			float splitAngle = parentTree.getSplitAngle();
			
			PVector newSpeed = new PVector(speed.x, speed.y);
			PVector newPosition = new PVector(position.x, position.y);
			rotateBy(newSpeed, splitAngle);
			branches.add(new Branch(parentTree, newPosition, newSpeed, counter));

			// calculate new split counter
			splitCounter = parentTree.getSplitCounter();
		}

		for (int i=0 ; i<branches.size(); i++)
		{
			Branch b = (Branch)branches.get(i);
			b.tick();
		}

		// update me
		position.add(speed);
		if (intensity<MAX_INTENSITY) intensity++;

		counter++;
		splitCounter--;

		circles.add(new Circle(new PVector(position.x, position.y), parentTree.startScale-sqrt(counter), c, intensity));
	}

	void draw()
	{
//		if (counter > parentTree.branchLife) return;

		for (int i=0 ; i<branches.size(); i++)
		{
			Branch b = (Branch)branches.get(i);
			b.draw();
		}

		for (int i=0 ; i<circles.size(); i++)
		{
			Circle c = (Circle)circles.get(i);
			c.tick();
			c.draw();
		}

		//fill(c, intensity);
		//ellipse(position.x, position.y, (int)parentTree.startScale-sqrt(counter), (int)parentTree.startScale-sqrt(counter));
	}

	void startFall()
	{
		for (int i=0 ; i<branches.size(); i++)
		{
			Branch b = (Branch)branches.get(i);
			b.startFall();		
		}

		for (int i=0 ; i<circles.size(); i++)
		{
			Circle c = (Circle)circles.get(i);
			c.startFall();
		}
	}

	void drawFruit()
	{
		fill(color(193,193,193), 70);
		ellipse(position.x, position.y, parentTree.startScale/20*3, parentTree.startScale/20*3);
	}
}



void rotateBy(PVector vec, float degree)
{
	float angle = radians(degree);
	vec.x = vec.x * cos(angle) - vec.y * sin(angle);
	vec.y = vec.x * sin(angle) + vec.y * cos(angle);
//	vec.normalize();
}

class Circle
{
	color mColor;
	PVector mPosition;
	float mScale;
	float mIntensity;

	float mGravity;

	Circle(PVector pos, float s, color c, float intensity)
	{
		mPosition = pos;
		mScale = s;
		mColor = c;
		mIntensity = intensity;

		mGravity = 0;
	}

	void draw()
	{
		fill(mColor, mIntensity);
		ellipse(mPosition.x, mPosition.y, mScale, mScale);			
	}

	void startFall()
	{
		mGravity = random(10)+5;
	}

	void tick()
	{
		if (mPosition.y < height-20) mPosition.y+=mGravity;
	}
}

