class NeuralNet {
  
  ArrayList<Layer> layers = new ArrayList<Layer>();
  int inputN;
  int lastNnodes;
  
  public NeuralNet(int inputNodes) {
    inputN = inputNodes;
    lastNnodes = inputNodes;
  }
  
  public void addLayer(int nNodes, String activation) {
    layers.add(new MultLayer(lastNnodes,nNodes));
    layers.add(new FuncLayer(activation));
  }
  
  public void addLayer(int nNodes, String activation, float activationParam) {
    layers.add(new MultLayer(lastNnodes,nNodes));
    layers.add(new FuncLayer(activation,activationParam));
  }
  
  public float[] predict(float[] input) {
     for (Layer l : layers) {
       input = l.applyLayer(input); 
     }
     return input;
  }
  
}

abstract class Layer {
  public abstract float[] applyLayer(float[] input);
  public abstract void mutate(float chance);
}

class FuncLayer extends Layer {
  
  String method;
  float extraParam;
  
  public FuncLayer(String method) {
     this.method = method;
  }
  
  public FuncLayer(String method, float param) {
     this.method = method;
     extraParam = param;
  }
  
  public void mutate(float chance) {} // do nothing
  
  public float[] applyLayer(float[] input) {
    switch (method) {
      case "softmax":
        float expSum = 0;
        for (float num : input) expSum += exp(num);
        for (int i = 0; i < input.length; i++) {
          input[i] = exp(input[i]) / expSum; 
        }
        break;
      case "sigmoid":
        for (int i = 0; i < input.length; i++) {
          input[i] = 1 / (1 + exp(-input[i]));
        }
        break;
      case "relu":
        for (int i = 0; i < input.length; i++) {
          input[i] = max(0,input[i]);
        }
        break;
      case "elu":
        for (int i = 0; i < input.length; i++) {
          input[i] = input[i] > 0 ? input[i] : extraParam*(exp(input[i])-1);
        }
        break;
      case "tanh":
        for (int i = 0; i < input.length; i++) {
          input[i] = (exp(input[i])-exp(-input[i]))/(exp(input[i])+exp(-input[i]));
        }    
        break;  
    }
    return input;
  }
  
}

class MultLayer extends Layer {
  
  float[][] matrix;
  int nNodes;
  
  public MultLayer(int inNodes, int outNodes) {
     nNodes = outNodes;
     matrix = new float[outNodes][inNodes];
     for (int y = 0; y < outNodes; y++) {
       for (int x = 0; x < inNodes; x++) {
         matrix[y][x] = random(-1,1);
       }
     }
  }
  
  public void mutate(float chance) {
    for (int y = 0; y < matrix.length; y++) {
       for (int x = 0; x < matrix[0].length; x++) {
         if (random(1) < chance) matrix[y][x] += random(-0.07,0.07);
       }
     } 
  }
  
  public float[] applyLayer(float[] input) {
    float[] output = new float[nNodes];
    for (int y = 0; y < nNodes; y++) {
      float sum = 0;
      for (int x = 0; x < input.length; x++) {
        sum += input[x] * matrix[y][x]; 
      }
      output[y] = sum;
    }
    return output;
  }
}
