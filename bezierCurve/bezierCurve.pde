public class Point {
  public float x;
  public float y;
  
  public Point(float x_, float y_) {
    x = x_;
    y = y_;
  }
}

public class Line {
  public float x1;
  public float y1;
  public float x2;
  public float y2;
  
  public Line(float x1_, float y1_, float x2_, float y2_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }
  
  public Line(Point p1, Point p2) {
    x1 = p1.x;
    y1 = p1.y;
    x2 = p2.x;
    y2 = p2.y;
  }
  
  public void disp() {
    line(x1, y1, x2, y2);
  }
  
  //pos = 5, sections = 8 will return the point 5/8ths of the way along the line from (x1, y1) 
  public Point getInterPoint(int pos, int sections) {
    return new Point(x1 + (x2 - x1)*pos/sections, y1 + (y2 - y1)*pos/sections);
  }
}

public class Bezier {
  public ArrayList<Line> lines;
  public ArrayList<Point> points = new ArrayList<Point>();
  public int segments; //number of segments the spline will have
  
  public Bezier(ArrayList<Line> lines_, int segments_) {
    lines = lines_;
    segments = segments_;
  }
  
  public void calculate() {
    for(int pos = 0; pos < segments; pos++) {
      ArrayList<Line> tempLines = lines;
      ArrayList<Point> tempPoints;
      while(tempLines.size() > 1) {
        tempPoints = new ArrayList<Point>();
        for(Line line : tempLines) {
          tempPoints.add(line.getInterPoint(pos, segments));
        }
        tempLines = new ArrayList<Line>();
        for(int pointID = 0; pointID < tempPoints.size() - 1; pointID++) {
          tempLines.add(new Line(tempPoints.get(pointID), tempPoints.get(pointID + 1)));
        }
      }
      points.add(tempLines.get(0).getInterPoint(pos, segments));
    }
  }
  
  public void disp() {
    calculate();
    
    //anchoring lines
    background(255);
    stroke(255, 0, 0);
    strokeWeight(1);
    for(Line line : lines) {
      line.disp();
    }
    
    //the curve itself
    stroke(0, 255, 0);
    strokeWeight(2);
    Point p1;
    Point p2;
    for(int pointID = 0; pointID < points.size() - 2; pointID++) {
      p1 = points.get(pointID);
      p2 = points.get(pointID + 1);
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
}

ArrayList<Line> lines = new ArrayList<Line>();
float prevX = -1257; //yay
float prevY = -1257;
float currentX = -1257;
float currentY = -1257;
int segments = 100;
Bezier bezier;

void setup() {
  size(800, 800);
  background(255);
}

void draw() {
  
}

void mouseClicked() {
  prevX = currentX;
  prevY = currentY;
  currentX = mouseX;
  currentY = mouseY;
  if(!(prevX == -1257 || prevY == -1257)) {
    lines.add(new Line(prevX, prevY, currentX, currentY));
    bezier = new Bezier(lines, segments);
    bezier.disp();
  }
}
