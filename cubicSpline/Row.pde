public static class Row {
  private double[] values;
  private int width;
  
  Row(double... values_) {
    values = values_;
    width = values.length;
  }
  
  Row(int width_) {
    values = new double[width_];
    width = width_;
  }
  
  double getValue(int index) {
    return values[index];
  }
  
  void setValue(int index, double value) {
    values[index] = value;
  }
  
  double[] getValues() {
    return values;
  }
  
  int getWidth() {
    return width;
  }
  
  boolean equals(Row row2) {
    if(getWidth() == row2.getWidth()) {
      for(int i = 0; i < getWidth(); i++) {
        if(getValue(i) != row2.getValue(i)) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
  
  Row copy() {
    Row copy = new Row(getWidth());
    for(int i = 0; i < getWidth(); i++) {
      copy.setValue(i, getValue(i));
    }
    return copy;
  }
  
  void negateInPlace() {
  }
  
  Row negate() {
    Row result = copy();
    for(int i = 0; i < getWidth(); i++) {
      result.setValue(i, -result.getValue(i));
    }
    return result;
  }
  
  void addInPlace(Row row2) {
    if(getWidth() == row2.getWidth()) {
      for(int i = 0; i < getWidth(); i++) {
        setValue(i, getValue(i) + row2.getValue(i));
      }
    }
    else {
      System.out.println("Cannot add: rows different widths");
    }
  }
  
  Row add(Row row2) {
    Row result = copy();
    result.addInPlace(row2);
    return result;
  }
  
  Row subtract(Row row2) {
    Row result = copy();
    result.addInPlace(row2.negate());
    return result;
  }
  
  void multiplyInPlace(double constant) {
    for(int i = 0; i < getWidth(); i++) {
      setValue(i, getValue(i) * constant);
    }
  }
  
  Row multiply(double constant) {
    Row result = copy();
    result.multiplyInPlace(constant);
    return result;
  }
  
  double dotProduct(Row row2) {
    double sum = 0;
    if(getWidth() == row2.getWidth()) {
      for(int i = 0; i < getWidth(); i++) {
        sum += getValue(i) * row2.getValue(i);
      }
    }
    else {
      System.out.println("Cannot dot product: rows different lengths");
    }
    return sum;
  }
  
  void print() {
    for(int i = 0; i < getWidth(); i++) {
      System.out.print(getValue(i));
      System.out.print("\t");
    }
    System.out.println("");
  }
  
  Row removeValue(int index) {
    Row result = new Row(getWidth() - 1);
    for(int i = 0; i < index; i++) {
      result.setValue(i, getValue(i));
    }
    for(int i = index + 1; i < getWidth(); i++) {
      result.setValue(i - 1, getValue(i));
    }
    return result;
  }
  
  // Like substring, start inclusive and end exclusive
  Row subrow(int start, int end) {
    Row result = new Row(end - start);
    for(int i = start; i < end; i++) {
      result.setValue(i - start, getValue(i));
    }
    return result;
  }
}