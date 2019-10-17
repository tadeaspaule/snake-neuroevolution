class SnakeAgent {
  int mapX;
  int mapY;
  public Snake snake;
  protected NeuralNet nn;
  public int score = 0;
  int lastMove = -1;
  int beforeLastMove = -1;
  
  public SnakeAgent(int mapX, int mapY) {
    this.mapX = mapX;
    this.mapY = mapY;
    reset();
    nn = new NeuralNet(24);
    nn.addLayer(32,"sigmoid");
    nn.addLayer(16,"sigmoid");
    nn.addLayer(4,"softmax");
  }
  
  public SnakeAgent(int mapX, int mapY, String[] lines) {
    this.mapX = mapX;
    this.mapY = mapY;
    reset();
    nn = new NeuralNet(lines);     
  }
  
  public void play(int nEpisodes, int nSteps) {
     for (int ep = 0; ep < nEpisodes; ep++) {
       reset();
       for (int step = 0; step < nSteps; step++) {
          if (snake.dead) return;
          makeMove();
       }
     }
  }
  
  public void reset() {
    snake = new Snake(mapX,mapY);
  }
  
  public String[] getSaveStrings() {
    return nn.getSaveStrings(); 
  }
  
  public void copyNN(SnakeAgent another) {
    nn = another.nn.getCopy();
  }
  
  public void makeMove() {
    // score -= 1; // for staying alive
    float[] obs = snake.getObservation();
    float[] actionVals = nn.predict(obs);
    int i = 0;
    for (int j = 1; j < actionVals.length; j++) {
      if (actionVals[j] > actionVals[i]) i = j; 
    }
    //if (i != lastMove && i != beforeLastMove) {
    //   // trying to prevent the "go back and forth in one spot" behaviour
    //   score += 15;
    //}
    beforeLastMove = lastMove;
    lastMove = i;
    int status = snake.action(i);
    if (status == 1) {
      // ate food
      score += 350;
    }
    else if (status == -1) {
      // died
      score -= 350;
    }
  }
  
  public void mutate(float chance) {
    nn.mutate(chance); 
  }
}
