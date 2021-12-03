class Vertex {
  //Data type to represent the pixels in the Jigsaw pieces and to enable us to use BFS.
  PVector pos; //key
  color col; //color of input image at this.pos.
  //localNbhd
  Vertex nUp;
  Vertex nDown;
  Vertex nRight;
  Vertex nLeft;
  ArrayList<Vertex> localNbhd;

  //color id
  boolean valid = false; //true if the pixel belongs to the connected component of a certain puzzle piece

  //constructor
  Vertex(PVector _pos) {
    pos = _pos;
    if (brightness(get((int)pos.x, (int)pos.y)) > 153) valid = true; //check color criterion
  }

  //add existent neighbours to localNbhd
  void initLocalNbhd() {
    localNbhd = new ArrayList<Vertex>();

    PVector posUp = new PVector(pos.x, pos.y-1);
    PVector posDown = new PVector(pos.x, pos.y+1);
    PVector posRight = new PVector(pos.x+1, pos.y);
    PVector posLeft = new PVector(pos.x-1, pos.y);

    if (graph.map.containsKey(posUp)) {
      nUp = graph.map.get(posUp);
      localNbhd.add(nUp);
    }
    if (graph.map.containsKey(posDown)) {
      nDown = graph.map.get(posDown);
      localNbhd.add(nDown);
    }
    if (graph.map.containsKey(posRight)) {
      nRight = graph.map.get(posRight);
      localNbhd.add(nRight);
    }
    if (graph.map.containsKey(posLeft)) {
      nLeft = graph.map.get(posLeft);
      localNbhd.add(nLeft);
    }
  }

  void printlocalNbhd() {
    println("localNbhd of: " + pos.toString());
    for (Vertex v : localNbhd) {
      println(v.pos.toString());
    }
  }

  void disp(color col) {
    fill(col);
    noStroke();
    circle(pos.x, pos.y, 2);
  }
}
