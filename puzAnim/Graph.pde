import java.util.*;
/*
Data structure to store pixels. Every pixel in the output window is modelled as a Vertex object. 
The internal data structure is a hashmap, with PVectors as keys and vertices as values. 
Each vertex has four neighbouring vertices, 3 if its at the border and 2 if its in the corner of the screen. 
This neighbours make up the neighbourhood nbhd used in the bfs. The only "classic" graph theory functions implemented are:
containsVertex and countVertices. This sufficed for the purpose of this project but not to get more than a 4.25 in Diskmath.
*/

class Graph
{
  //creating an object of the Map class that stores the edges of the graph
  private Map<PVector,Vertex> map = new HashMap<>();
  //the method adds a new vertex to the graph

  public void addNewVertex(Vertex s)
  {
    map.put(s.pos,s);
  }

  //the method adds an edge between source and destination
  public void addNewEdge(PVector source, PVector destination)
  {
    //warnings
    if (!map.containsKey(source)) println(source.toString() + " does not exist as a Vertex");
    if (!map.containsKey(destination)) println(destination.toString() + " does not exist as a Vertex");
  }
  //the method counts the number of vertices
  public void countVertices()
  {
    System.out.println("Total number of vertices: "+ map.keySet().size());
  }

  //checks a graph has vertex or not
  public void containsVertex(Vertex s)
  {
    if (map.containsKey(s))
    {
      System.out.println("The graph contains "+ s.pos + " as a vertex.");
    } else
    {
      System.out.println("The graph does not contain "+ s.pos + " as a vertex.");
    }
  }
}
