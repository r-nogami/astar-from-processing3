int hTiles = 40;
int vTiles = 40;
int tileWidth, tileHeight;

Tile[][] tileset;

ArrayList<Tile> closedSet;
ArrayList<Tile> openSet;
ArrayList<Tile> path;

Tile start;
Tile end;

float heuristic(Tile a, Tile b)
{
  return dist(a.i, a.j, b.i, b.j);
}

void setup()
{
  size(800, 800);
  tileWidth = width / hTiles;
  tileHeight = height / vTiles;
  tileset = new Tile[hTiles][vTiles];
  for(int i = 0; i < hTiles; i++)
  {
    for(int j = 0; j < vTiles; j++)
    {
      tileset[i][j] = new Tile(i,j,tileWidth, tileHeight);
    }
  }
  for(int i = 0; i < hTiles; i++)
  {
    for(int j = 0; j < vTiles; j++)
    {
      tileset[i][j].fillNeighbours(tileset);
    }
  }
  closedSet = new ArrayList<Tile>();
  openSet = new ArrayList<Tile>();
  path = new ArrayList<Tile>();
  
  start = tileset[(int)random(0, hTiles-1)][(int)random(0, vTiles-1)];
  end = tileset[(int)random(0, hTiles-1)][(int)random(0, vTiles-1)];
  
  start.obstacle = false;
  end.obstacle = false;
  
  openSet.add(start);
}
boolean paused = false;
void draw()
{
  if(paused)
  {
    noStroke();
    fill(0);
    rect(0,0,width,height);
    fill(255);
    text("Paused",50,50);
    return;
  }
  background(255);
  strokeWeight(1);
  if(openSet.size() == 0) {
    noLoop();
  } else {
    Tile current = openSet.get(0);
    for(Tile t : openSet)
    {
      if(t.f() < current.f()) current = t;
    }
    if(current == end)
    {
      openSet.clear();
      closedSet.clear();
      path.clear();
      Tile origin = current;
      path.add(origin);
      while(origin.parent != null)
      {
        path.add(origin.parent);
        origin = origin.parent;
      }
    } else {
      openSet.remove(current);
      closedSet.add(current);
      
      for(Tile neighbour : current.neighbours)
      {
        if(!closedSet.contains(neighbour) && !neighbour.obstacle)
        {
          float g = current.g + (heuristic(neighbour, current));
          if(!openSet.contains(neighbour))
          {
            openSet.add(neighbour);
            neighbour.g = g;
            neighbour.heuristic = heuristic(neighbour, end);
            neighbour.parent = current;
          } else {
            if(g < neighbour.g)
            {
              neighbour.g = g;
              neighbour.parent = current;
              neighbour.heuristic = heuristic(neighbour, end);
            }
          }
        }
      }
    }
    
    path.clear();
    Tile origin = current;
    path.add(origin);
    while(origin.parent != null)
    {
      path.add(origin.parent);
      origin = origin.parent;
    }
    
  }
  
  
  for(int i = 0; i < hTiles; i++)
  {
    for(int j = 0; j < vTiles; j++)
    {
      Tile t = tileset[i][j];   
      t.draw(200);
    }
  }
  stroke(25,100,200f);
  strokeWeight(4);
  noFill();
  beginShape();
  for(Tile t : path)
  {
    vertex(t.i*tileWidth+tileWidth/2, t.j*tileHeight+tileHeight/2);
  }
  endShape();
  strokeWeight(1);
  start.draw(200,120,200);
  end.draw(120,200,120);
}

void mousePressed()
{
  paused = !paused;
}