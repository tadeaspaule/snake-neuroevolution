class Snake { 
  int mapX;
  int mapY;
  int x;
  int y;
  public boolean dead = false;
  public ArrayList<Point> body = new ArrayList<Point>();
  public Point food;
  float[] obs = new float[24]; // observation
  Point[] moves = new Point[]{
    new Point(-1,-1),new Point(0,-1),new Point(1,-1),new Point(1,0),
    new Point(1,1),new Point(0,1),new Point(-1,1),new Point(-1,0)
  }; 
  
  public Snake(int mapX, int mapY) {
     this.mapX = mapX;
     this.mapY = mapY;
     x = (int)random(mapX);
     y = (int)random(mapY);
     body.add(new Point(x,y));
     generateFood();
  }
  
  int action(int choice) {
    if (dead) return -1; 
    if (choice == 0) return move(0,-1);
    else if (choice == 1) return move(1,0);
    else if (choice == 2) return move(0,1);
    else return move(-1,0);
  }
  
  int move(int vx, int vy) {
    x += vx;
    y += vy;
    // check if hit a wall or body
    if (x < 0 || x >= mapX || y < 0 || y >= mapY || inBody(x,y)) {
      dead = true;
      return -1;
    }
    body.add(0,new Point(x,y));
    // check if ate food
    if (food.equals(x,y)){
      generateFood();
      return 1;
    }
    else {
      body.remove(body.size()-1);
      return 0;
    }
  }
  
  boolean inBody(int x, int y) {
    for (Point p : body) {
      if (p.equals(x,y)) return true; 
    }
    return false;
  }
    
  boolean isMaxedOut() {
    return body.size() == mapX * mapY; 
  }
  
  void generateFood() {
     for (int i = 0; i < 15; i++) {
        int x = (int)random(mapX);
        int y = (int)random(mapY);
        if (!inBody(x,y)) {
          food = new Point(x,y);
          return;
        }
     }
     // randomly picking didn't work, probably map is too full
     int n = (int)random(mapX*mapY);
     while (inBody(n/mapY,n%mapX)) n += 3;
     food = new Point(n/mapY,n%mapX);
  }

  public float[] getObservation() {
    int xdif = mapX-x-1;
    int ydif = mapY-y-1;
    obs[0] = min(x,y) + 1;      // top left
    obs[1] = y + 1;             // top
    obs[2] = min(xdif,y) + 1;   // top right
    obs[3] = xdif + 1;          // right
    obs[4] = min(xdif,ydif) + 1;// bottom right
    obs[5] = ydif + 1;          // bottom
    obs[6] = min(x,ydif) + 1;   // bottom left
    obs[7] = x + 1;             // left
    // +1 so that when you're right next to it, it's a 1 not a 0
    float[] body = new float[8];
    float[] food = new float[8];
    int x,y,counter;
    boolean foundFood,foundBody;
    for (int i = 0; i < 8; i++) {
       Point m = moves[i];
       x = this.x + m.x;
       y = this.y + m.y;
       foundFood = false;
       foundBody = false;
       counter = 1;
       while (x >= 0 && x < mapX && y >= 0 && y < mapY && !(foundFood && foundBody)) {
         if (!foundBody && inBody(x,y)) {
           body[i] = counter;
           foundBody = true;
         }
         else if (!foundFood && this.food.equals(x,y)) {
           food[i] = counter;
           foundFood = true;
         }
         counter++;
         x += m.x;
         y += m.y;
       }
    }
    for (int i = 0; i < 8; i++) {
      obs[8+i] = body[i];
      obs[16+i] = food[i];
    }
    return obs;
  }
}

// Helper class
class Point {
  public int x;
  public int y;
  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  boolean equals(Point p2) {
    return x == p2.x && y == p2.y;
  }
  boolean equals(int x, int y) {
    return this.x == x && this.y == y; 
  }
}
