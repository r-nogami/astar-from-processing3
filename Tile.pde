class Tile
{
  int i;
  int j;
  int w;
  int h;

  float heuristic = 0;
  float g = 0;

  Tile parent;

  ArrayList<Tile> neighbours;

  Boolean obstacle = false;

  Tile(int i, int j, int w, int h)
  {
    this.i = i;
    this.j = j;
    this.w = w;
    this.h = h;
    this.neighbours = new ArrayList<Tile>();

    if (random(0, 1) < 0.25)
    {
      this.obstacle = true;
    }
  }

  void fillNeighbours(Tile[][] tileset)
  {
    neighbours.clear();
    if (i > 0)
    {
      neighbours.add(tileset[i-1][j]);
    }
    if (j > 0)
    {
      neighbours.add(tileset[i][j-1]);
    }
    if (i < width/w-1)
    {
      neighbours.add(tileset[i+1][j]);
    }
    if (j < height/h-1)
    {
      neighbours.add(tileset[i][j+1]);
    }
    //Diagonais
    if (i > 0 && j > 0) {
      this.neighbours.add(tileset[i - 1][j - 1]);
    }
    if (i < width/w - 1 && j > 0) {
      this.neighbours.add(tileset[i + 1][j - 1]);
    }
    if (i > 0 && j < height/h - 1) {
      this.neighbours.add(tileset[i - 1][j + 1]);
    }
    if (i < width/w - 1 && j < height/h - 1) {
      this.neighbours.add(tileset[i + 1][j + 1]);
    }
  } 

  void draw(int r, int g, int b)
  {
    fill(r, g, b);
    if (this.obstacle) fill(255, 120, 120);
    noStroke();
    ellipse(i*w+w/2, j*h+h/2, w/1.25, h/1.25);
    //rect(i*w, j*h,w,h);
  }

  void draw(int g) { 
    draw(g, g, g);
  }

  float f()
  {
    return heuristic + g;
  }
}
