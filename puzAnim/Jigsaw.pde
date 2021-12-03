class Jigsaw {
  //Data type to represent Jigsaw pieces. Each piece has an arrayList of vertices which included all pixels of the puzzle piece.

  ArrayList<Vertex> area; //resulting area
  PVector anchor; //center of mass of puzzle piece
  PVector home; //original position of puzzle piece in og img
  boolean isHome = false; // true if the piece is at original location
  PGraphics puzImg; //img of the puzzle piece

  //constructor
  Jigsaw() {
    area = new ArrayList<Vertex>();
  }
  //------------------------------- MOVEMENTS ----------------------------------------------------

  //move the puzzle piece by a certain vector
  void move(PVector change) {
    anchor.add(change.copy());
  }

  //drive the puzzle piece towards its original position. When close to it (d<speed), snap to the original position
  void moveHome(float speed) {
    if (!isHome) {
      PVector dir = (home.copy()).sub(anchor.copy());
      float d = dir.mag();
      dir.normalize();
      dir.mult(speed);
      move(dir);
      if (d<speed) { //snap
        isHome = true;
        PVector finalDistance = (home.copy()).sub(anchor.copy());
        move(finalDistance);
        anchor = home.copy();
      }
    }
  }

  //wiggle puzzle piece randomly around
  void wiggle(int mag) {
    move(new PVector(random(-mag, mag), random(-mag, mag)));
  }

  //drive puzzle piece towards mouse position with a certain speed
  void follow(int speed) {
    PVector toMouse = (new PVector(mouseX, mouseY)).sub(anchor.copy());
    toMouse.normalize();
    toMouse.mult(speed);
    move(toMouse);
  }
  //-------------------------------------- MOVEMENTS DONE--------------------------------------------------------------

  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ DISPLAY $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  
  //draw puzzple piece to screen at its anchor position. Since PGraphics performs calc's on whole arrays simultaniously
  //this is way more efficient than relocating individual pixels
  void disp() {
    image(puzImg, anchor.x, anchor.y);
  }

  //display found area red
  void dispArea(color col) {
    for (int i = 0; i<area.size(); i++) {
      area.get(i).disp(col);
    }
  }
  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ DISPLAY DONE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  //###################################### INITIALIZATIONS ##########################################
  //assign the areas pixels to a PGraphics object
  void initImg() {
    int sideX = int(stepsX + _rad);
    int sideY = int(stepsY + _rad);
    puzImg = createGraphics(sideX, sideY);
    puzImg.beginDraw();
    for (int x = (int)anchor.x-sideX/2; x<anchor.x + sideX/2; x++) { 
      for (int y = (int)anchor.y-sideY/2; y<anchor.y + sideY/2; y++) {
        PVector point = new PVector(x, y);
        Vertex v = graph.map.get(point);
        if (area.contains(v)) {
          puzImg.set(int(x-(anchor.x-sideX/2)), int(y-((int)anchor.y-sideY/2)), v.col);//subtraction of anchor-side/2 necessary in order to center image around anchor
        }
      }
    }
    puzImg.endDraw();
  }

  //init anchor, home is where piece was in og picture
  void initAnchor(PVector a) {
    anchor = a.copy();
    home = a.copy();
  }

  //assign the og picture pixels to the color property of the vertices
  void initCamo(PImage img) {
    img.loadPixels();
    for (int i = 0; i<area.size(); i++) {
      PVector loc = area.get(i).pos;
      color col = img.get((int)loc.x, (int)loc.y);
      area.get(i).col = col;
    }
  }
  //###################################### INITIALIZATIONS DONE ##########################################
}
