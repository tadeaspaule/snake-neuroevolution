class NeuralNet {
  
  protected ArrayList<Layer> layers = new ArrayList<Layer>();
  int inputN;
  int lastNnodes;
  
  public NeuralNet(int inputNodes) {
    inputN = inputNodes;
    lastNnodes = inputNodes;
  }
  
  public NeuralNet(String[] lines) {
    // load a net from a text file
    inputN = Integer.parseInt(lines[0]);
    lastNnodes = inputN;
    for (int i = 1; i < lines.length; i++) {
      String[] parts = lines[i].split("\\?");
      if (parts[0].equals("func")) {
        layers.add(new FuncLayer(parts[1],Float.parseFloat(parts[2])));
      }
      else {
        // weights layer
        String[] rows = parts[1].split("GG");
        int colcount = rows[0].split("G").length;
        MultLayer ml = new MultLayer(colcount,rows.length);
        ml.matrix = new float[rows.length][colcount];
        for (int y = 0; y < rows.length; y++) {
          String[] row = rows[y].split("G");
          for (int x = 0; x < colcount; x++) {
            ml.matrix[y][x] = Float.parseFloat(row[x]); 
          }
        }
        layers.add(ml);
      }
    }
  }
  
  public String[] getSaveStrings() {
    String[] strings = new String[layers.size()+1];
    strings[0] = inputN+""; // meta data
    for (int i = 0; i < layers.size(); i++) {
      strings[i+1] = layers.get(i).getSaveString();
    }
    return strings;
  }
    
  public NeuralNet getCopy() {
     NeuralNet n = new NeuralNet(inputN);
     for (Layer l : layers) {
        n.layers.add(l.getCopy());
     }
     return n;
  }
  
  // ---- add Dense layer with activation function ----
  public void addLayer(int nNodes, String activation) {
    layers.add(new MultLayer(lastNnodes,nNodes));
    layers.add(new FuncLayer(activation));
    lastNnodes = nNodes;
  }
  
  public void addLayer(int nNodes, String activation, float activationParam) {
    layers.add(new MultLayer(nNodes,lastNnodes));
    layers.add(new FuncLayer(activation,activationParam));
    lastNnodes = nNodes;
  }
  
  // ---- add Dense layer on its own ----
  public void addLayer(int nNodes) {
    layers.add(new MultLayer(lastNnodes,nNodes));
    lastNnodes = nNodes;
  }
  
  // ---- add FuncLayer on its own ----
  public void addLayer(String activation) {
    layers.add(new FuncLayer(activation));
  }
  
  public void addLayer(String activation, float activationParam) {
    layers.add(new FuncLayer(activation,activationParam));
  }
  
  public void mutate(float chance) {
    for (Layer l : layers) l.mutate(chance); 
  }
  
  public float[] predict(float[] input) {
     for (Layer l : layers) {
       input = l.applyLayer(input); 
     }
     return input;
  } 
}
