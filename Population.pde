import java.util.Comparator;
import java.util.Collections;

class Population {
  ArrayList<SnakeAgent> agents = new ArrayList<SnakeAgent>();
  
  public Population(int nAgents, int mapX, int mapY) {
    for (int i = 0; i < nAgents; i++) {
      agents.add(new SnakeAgent(mapX,mapY));
    }
  }
  
  public Population(int nAgents, int mapX, int mapY, String[] lines) {
    for (int i = 0; i < nAgents; i++) {
      agents.add(new SnakeAgent(mapX,mapY,lines));
    }
  }
  
  public void evolve(float chance, int nEpisodes, int nSteps) {
     for (SnakeAgent sa : agents) {
        sa.play(nEpisodes,nSteps);
     }
     Collections.sort(agents, new ScoreComparator());
     for (int i = 0; i < agents.size(); i++) {
       agents.get(i).score = 0;
       if (i >= 10) {
         agents.get(i).copyNN(agents.get((int)random(10))); 
         agents.get(i).mutate(chance);
       }
     }
  }
  
  public SnakeAgent getBest() {
    return agents.get(0); 
  }
}

class ScoreComparator implements Comparator<SnakeAgent> {
    @Override
    public int compare(SnakeAgent a, SnakeAgent b) {
        return a.score < b.score ? 1 : a.score == b.score ? 0 : -1;
    }
}
