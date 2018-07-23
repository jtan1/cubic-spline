public class Point {
  private double x;
  private double y;
  
  Point(double x_, double y_) {
    x = x_;
    y = y_;
  }
  
  double getX() {
    return x;
  }
  
  double getY() {
    return y;
  }
  
  void setX(double value) {
    x = value;
  }
  
  void setY(double value) {
    y = value;
  }
  
  void display() {
    strokeWeight(5);
    point((float)x, (float)y);
    strokeWeight(1);
  }
}

public class Spline {
  private ArrayList<Point> points;
  private int size;
  
  Spline() {
    points = new ArrayList<Point>();
    size = 0;
  }
  
  void addPoint(Point point) {
    points.add(point);
    size++;
  }
  
  void setPoint(int id, double x, double y) {
    points.get(id).setX(x);
    points.get(id).setY(y);
  }
  
  ArrayList<Point> getPoints() {
    return points;
  }
  
  void display() {
    for(Point point : points) {
      point.display();
    }
    
    if(size == 0) {
      return;
    }
    else if(size == 1) {
      point((float)points.get(0).getX(), (float)points.get(0).getY());
    }
    else if(size == 2) {
      line((float)points.get(0).getX(), (float)points.get(0).getY(), (float)points.get(1).getX(), (float)points.get(1).getY());
    }
    else {
      Matrix X = new Matrix(4 * (size - 1), 4 * (size - 1));
      Matrix Y = new Matrix(4 * (size - 1), 1);
      Point tempPoint;
      double xPow, x1, y1, x2, y2;
      
      x1 = points.get(0).getX();
      y1 = points.get(0).getY();
      x2 = points.get(1).getX();
      y2 = points.get(1).getY();
      if(x1 == x2) {
        x2 += 0.0001;
      }
      Y.setValue(0, 0, y1);
      Y.setValue(1, 0, (y2 - y1) / (x2 - x1) + 0.01);
      
      tempPoint = points.get(0);
      for(int exponent = 0; exponent < 4; exponent++) {
        xPow = (double)Math.pow(tempPoint.getX(), exponent);
        X.setValue(0, exponent, xPow);
        if(exponent < 3) {
          X.setValue(1, exponent + 1, (exponent + 1) * (double)Math.pow(tempPoint.getX(), exponent));
        }
      }
      
      x1 = points.get(size - 2).getX();
      y1 = points.get(size - 2).getY();
      x2 = points.get(size - 1).getX();
      y2 = points.get(size - 1).getY();
      if(x1 == x2) {
        x2 += 0.0001;
      }
      Y.setValue(2, 0, y2);
      Y.setValue(3, 0, (y2 - y1) / (x2 - x1) + 0.01);
      
      tempPoint = points.get(size - 1);
      for(int exponent = 0; exponent < 4; exponent++) {
        xPow = (double)Math.pow(tempPoint.getX(), exponent);
        X.setValue(2, 4 * (size - 2) + exponent, xPow);
        if(exponent < 3) {
          X.setValue(3, 4 * (size - 2) + exponent + 1, (exponent + 1) * (double)Math.pow(tempPoint.getX(), exponent));
        }
      }
      
      int row, colL, colR;
      for(int point = 1; point < size - 1; point++) {
        tempPoint = points.get(point);
        row = 4 * point;
        colL = 4 * (point - 1);
        colR = 4 * point;
        
        Y.setValue(row, 0, tempPoint.getY());
        Y.setValue(row + 1, 0, tempPoint.getY());
        Y.setValue(row + 2, 0, 0);
        Y.setValue(row + 3, 0, 0);
        
        for(int exponent = 0; exponent < 4; exponent++) {
          xPow = (double)Math.pow(tempPoint.getX(), exponent);
          X.setValue(row, colL + exponent, xPow);
          X.setValue(row + 1, colR + exponent, xPow);
          if(exponent < 3) {
            X.setValue(row + 2, colL + exponent + 1, (exponent + 1) * xPow);
            X.setValue(row + 2, colR + exponent + 1, -(exponent + 1) * xPow);
          }
          if(exponent < 2) {
            X.setValue(row + 3, colL + exponent + 2, (exponent + 2) * (exponent + 1) * xPow);
            X.setValue(row + 3, colR + exponent + 2, -(exponent + 2) * (exponent + 1) * xPow);
          }
        }
      }
      
      Row solution = X.solve(Y);
      for(int i = 0; i < size - 1; i++) {
        Polynomial segment = new Polynomial(solution.subrow(4 * i, 4 * i + 4));
        segment.display(points.get(i).getX(), points.get(i + 1).getX());
      }
    }
  }
}