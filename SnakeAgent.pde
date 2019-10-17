class SnakeAgent {
  Snake snake;
  NeuralNet nn;
  
  public SnakeAgent(int mapX, int mapY) {
    snake = new Snake(mapX,mapY);
    nn = new NeuralNet(24);
    nn.addLayer(32,"sigmoid");
    nn.addLayer(16,"sigmoid");
    nn.addLayer(4,"softmax");
  }
}
