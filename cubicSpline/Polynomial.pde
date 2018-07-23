public class Polynomial extends Row {
  Polynomial(double... coefficients) {
    super(coefficients);
  }
  
  Polynomial(Row coefficients) {
    super(coefficients.getValues());
  }
  
  double getY(double x) {
    double sum = 0;
    for(int i = 0; i < getWidth(); i++) {
      sum += getValue(i) * Math.pow(x, i);
    }
    return sum;
  }
  
  void display(double leftBound, double rightBound) {
    display(leftBound, rightBound, 100, 0);
  }
  
  void display(double leftBound, double rightBound, int segments) {
    display(leftBound, rightBound, segments, 0);
  }
  
  void display(double leftBound, double rightBound, int segments, double xOffset) {
    double dx = (rightBound - leftBound) / segments;
    for(int i = 0; i < segments; i++) {
      double x1 = leftBound + i*dx;
      double x2 = leftBound + (i+1)*dx;
      line((float)(xOffset + x1), (float)getY(x1), (float)(xOffset + x2), (float)getY(x2)); 
    }
  }
}