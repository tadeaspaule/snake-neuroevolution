int w = 10;
int h = 10;
int blockSize = 50;
Snake snake;

void setup() {
  size(500,500);
  frameRate(10);
  snake = new Snake(w,h);
}

void draw() {
  background(0);
  drawGrid();
  drawFood();
  drawSnake();
  snake.action((int)random(4));
  if (snake.dead) {
     snake = new Snake(w,h);
  }
}

void drawSnake() {
  fill(255);
  noStroke();
  for (Point p : snake.body) {
    rect(p.x*blockSize,p.y*blockSize,blockSize,blockSize);
  }
}

void drawFood() {
  fill(255,100,100);
  noStroke();
  rect(snake.food.x*blockSize,snake.food.y*blockSize,blockSize,blockSize);
}

void drawGrid() {
  stroke(125);
  strokeWeight(1);
  for (int i = 1; i < max(w,h); i++) {
    line(0,i*blockSize,width,i*blockSize);
    line(i*blockSize,0,i*blockSize,height);
  }
}
