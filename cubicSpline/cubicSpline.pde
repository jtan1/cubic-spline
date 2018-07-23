boolean inEditMode = false;
boolean mouseDown = false;
int nearestPointID;
Spline s1 = new Spline();

void setup() {
  size(800, 800);
}

void draw() {
  if(mouseDown) {
    s1.setPoint(nearestPointID, mouseX, mouseY);
    background(255);
    s1.display();
  }
}

void mouseClicked() {
  if(mouseDown) {
    mouseDown = false;
  }
  else if(!mouseDown && inEditMode) {
    ArrayList<Point> points = s1.getPoints();
    for(int i = 0; i < points.size(); i++) {
      Point point = points.get(i);
      if(Math.abs(mouseX - point.getX()) < 10 && Math.abs(mouseY - point.getY()) < 10) {
        mouseDown = true;
        nearestPointID = i;
      }
    }
  }
  else {
    Point p = new Point(mouseX, mouseY);
    s1.addPoint(p);
  }
  background(255);
  s1.display();
}

void keyPressed() {
  if(key == 'e') {
    inEditMode = true;
  }
}

void keyReleased() {
  if(key == 'e') {
    inEditMode = false;
  }
}