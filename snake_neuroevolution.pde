int w = 10;
int h = 10;
int blockSize = 50;
SnakeAgent snakeAgent;
Population pop;
boolean drawingBest = false;
int generation = 0;
int step = 0;
int nSteps = 200;
int genStep = 10;

int screenCount = 0;

void setup() {
  size(500,500);
  frameRate(15);
  textAlign(CENTER,CENTER);
  textSize(17);
  pop = new Population(140,w,h,loadStrings("weights/gen1550.txt"));
}

void draw() {
  if (!drawingBest || (keyPressed && key == 's')) {
    int m1 = millis();
    for (int i = 0; i < genStep; i++) {
      pop.evolve(0.3,10,200);
      generation++;
    }
    int m2 = millis();
    println("Evolution took " + (m2-m1) + "ms");
    snakeAgent = pop.getBest();
    snakeAgent.reset();
    if (generation % 50 == 0) saveStrings("weights/gen"+generation+".txt",snakeAgent.getSaveStrings());
    drawingBest = true;
    step = 0;
    return;
  }
  background(0);
  drawGrid();
  drawFood();
  drawSnake();
  fill(255);
  text("Generation " + generation + "\nstep " + step + "\nPress 's' to skip",width/2,height-50);
  
  snakeAgent.makeMove();
  if (snakeAgent.snake.dead || step >= nSteps) {
     snakeAgent.score = 0;
     drawingBest = false;
  }
  else step++;
}

void drawSnake() {
  fill(180,180,255);
  noStroke();
  for (Point p : snakeAgent.snake.body) {
    rect(p.x*blockSize,p.y*blockSize,blockSize,blockSize);
  }
}

void drawFood() {
  fill(255,100,100);
  noStroke();
  rect(snakeAgent.snake.food.x*blockSize,snakeAgent.snake.food.y*blockSize,blockSize,blockSize);
}

void drawGrid() {
  stroke(125);
  strokeWeight(1);
  for (int i = 1; i < max(w,h); i++) {
    line(0,i*blockSize,width,i*blockSize);
    line(i*blockSize,0,i*blockSize,height);
  }
}
