/* -- PUZZLE ANIMATION --

What: A program that does the following:
1.) Generate a blank jigsaw puzzle with a horizontal and vertical piece density, indents and outdents are created randomly
2.) Create a grid graph with each pixel being one vertex. The graph is implemented as a hashmap with PVectors as keys and vertices as values.
    Each vertex has 4,3 or 2 neigbhours, dependig if its at the border, in the corner or none of the two. Each vertex has its neighbourhood as membervariables.
3.) Each blank puzzle piece is generated at a seed location. By performing a BFS at each seed, a list of vertices/pixels can be assigned to each puzzle piece, containing the connected component of the pixels of this puzzple piece.
4.) Operating on each vertex in each puzzple piece is mad inefficient. Thats why each puzzle piece gets converted into a PGraphics object, whose manipulation is more efficient.
5.) Two visually interesting functions, wiggle and follow, are implemented to let the user play with the puzzle pieces. 
When: September 2021
Who: Jaú Gretler
Where: Montjaux and Campus Hönggerberg
*/

ArrayList<Jigsaw> pieces;//list of puzzle pieces
ArrayList<PVector> seeds; //pointers to puzzle piece centers
PImage img; //image to divide into puzzle pieces
boolean wiggle = false; //turn random wiggling motion of puzzle pieces on and off
boolean follow = false; //turn on following of mouse
Graph graph; //data structure to hold pixel vertices

//puzzle generation  -----------------------------
int numPuz = 20; //number of puzzle pieces per row and per column
int _rad; //diameter of indents and outdets of puzzle pieces
float stepsX;//rectangle width of puzzle pieces
float stepsY;//rectangle height of puzzle pieces
//puz gen done ------------------------------

void setup() {
  //size has to be proportional to img dimensions
  size(828, 1044);

  //og img load and resize
  img = loadImage("me.png");
  img.resize(828, 1044);

  //anim settings
  frameRate(60);
  imageMode(CENTER);

  //puzzle generation setup ---------------------
  stepsX = width/numPuz;
  stepsY = height/numPuz;
  _rad = int(min(stepsX, stepsY)/2.75); //2.75 gives a natural looking ratio of indent/outdent-radius to puzzle size
  genPuz(_rad); //draw a puzzle piece matrix
  //puz gen setup done ------------------

  //init globals
  pieces = new ArrayList<Jigsaw>();
  seeds = new ArrayList<PVector>();
  graph = new Graph();

  //init important data structures
  initGraph();
  initSeeds();
  initPieces();
  println("INIT done");
  println("Press w to wiggle and f to have fun");
}

void draw() {
  background(0);

  for (Jigsaw p : pieces) {
    p.disp();
    if (wiggle) p.wiggle(20); //argument is speed of wiggling
    if (follow) p.follow(10); //argument is speed of following
  }
  for (Jigsaw p : pieces) {
    if (!follow && !wiggle) p.moveHome(3); //argumet is speed of moving home
  }
}

void keyPressed() {
  if (key == 'w' || key =='W') {
    wiggle = !wiggle;
  } else if (key == 'f' || key =='F') {
    follow = !follow;
  }
  if (wiggle == false && follow == false) for (Jigsaw p : pieces) p.isHome = false;
}

//perform bfs on vertex located at seed, assign the resulting connected components to the input Jigsaw piece
void BFS(Jigsaw piece, PVector seed) {
  //growing set of neighbouring pixels
  ArrayList<Vertex> nbhd = new ArrayList<Vertex>();

  //set seed vertex
  nbhd.add(graph.map.get(seed));

  int it = 0; //iterator
  int num = 200; //number of iterations
  while (it<num) {

    //BFS
    ArrayList<Vertex> tempArea = new ArrayList<Vertex>();//store future nbhd
    for (Vertex v : nbhd) {
      for (Vertex w : v.localNbhd) {
        if (!piece.area.contains(w) && w.valid) {
          piece.area.add(w);
          tempArea.add(w);
        }
      }
    }
    nbhd = tempArea;
    it++;
  }
}

//------------------------- INITIALIZATIONS ----------------------------

void initGraph() {
  print("Initializing graph");
  //add vertices (Pixels) to graph
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PVector tempPos = new PVector(x, y);
      graph.addNewVertex(new Vertex(tempPos));
    }
  }
  //init nbhds of pixels
  for (PVector v : graph.map.keySet()) {
    graph.map.get(v).initLocalNbhd();
  }
  println(" -DONE");
}

//draw a blank puzzle with randomly in- or outdented borders. Piece resolution is set in setup()
void genPuz(int rad) {
  print("Initializing puzzle");
  for (int x = 0; x < width; x+=stepsX) {
    for (int y = 0; y< height; y+= stepsY) {
      //rect
      strokeWeight(3);
      stroke(0);
      noFill();
      rect(x, y, stepsX, stepsY);
      //indents
      float dec1 = random(0, 1);
      float dec2 = random(0, 1);
      //vertical indents
      boolean xCheck = x > 0 && x < width-20;
      boolean yCheck = y > 0 && y < height-20;
      if (xCheck) {
        fill(255);
        noStroke();
        circle(x, y + stepsY/2, rad);
        stroke(0);
        if (dec1 > 0.5) {
          arc(x, y + stepsY/2, rad, rad, -HALF_PI, HALF_PI);
        } else {
          arc(x, y + stepsY/2, rad, rad, HALF_PI, 3*HALF_PI);
        }
      }
      //horizontal indents
      if (yCheck) {
        fill(255);
        noStroke();
        circle(x + stepsX/2, y, rad);
        stroke(0);
        if (dec2 > 0.5) {
          arc(x + stepsX/2, y, rad, rad, 0, PI);
        } else {
          arc(x + stepsX/2, y, rad, rad, PI, TWO_PI);
        }
      }
    }
  }
  println(" -DONE");
}

void initPieces() {
  print("Initializing pieces");
  for (PVector s : seeds) {
    Jigsaw piece = new Jigsaw();
    BFS(piece, s);
    piece.initAnchor(s);
    piece.initCamo(img);
    piece.initImg();
    //piece.disp();
    pieces.add(piece);
  }
  println(" -DONE");
}

void initSeeds() {
  print("Initializing seeds");
  for (int x = (int)stepsX/2; x < width; x+=stepsX) {
    for (int y = (int)stepsY/2; y< height; y+= stepsY) {
      seeds.add(new PVector(x, y));
    }
  }
  println(" -DONE");
}
//------------------------- INITIALIZATIONS DONE ----------------------------
