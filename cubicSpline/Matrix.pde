public static class LUPResult {
  private Matrix L;
  private Matrix U;
  private Matrix P;
  private int determinantSign;
  
  LUPResult(Matrix L_, Matrix U_, Matrix P_, int determinantSign_) {
    L = L_;
    U = U_;
    P = P_;
    determinantSign = determinantSign_;
  }
  
  LUPResult() {
    L = new Matrix(0, 0);
    U = new Matrix(0, 0);
    P = new Matrix(0, 0);
    determinantSign = 0;
  }
  
  Matrix getL() {
    return L;
  }
  
  Matrix getU() {
    return U;
  }
  
  Matrix getP() {
    return P;
  }
  
  int getDeterminantSign() {
    return determinantSign;
  }
  
  void print() {
    System.out.println("Lower: ");
    L.print();
    System.out.println("\nUpper: ");
    U.print();
    System.out.println("\nPermutation: ");
    P.print();
    System.out.print("\nDeterminant Sign: ");
    System.out.println(determinantSign);
  }
}

public static class Matrix {
  private Row[] rows;
  private int width;
  private int height;
  private LUPResult LUP;
  private boolean LUPOutdated;
  
  Matrix(Row... rows_) {
    height = rows_.length;
    width = rows_[0].getWidth();
    
    for(int i = 0; i < height; i++) {
      if(rows_[i].getWidth() != width) {
        System.out.println("Cannot create matrix: rows different widths");
        break;
      }
    }
    rows = rows_;
    LUPOutdated = true;
  }
  
  Matrix(double[][] rows_) {
    height = rows_.length;
    width = rows_[0].length;
    rows = new Row[height];
    
    for(int i = 0; i < height; i++) {
      rows[i] = new Row(rows_[i]);
    }
    LUPOutdated = true;
  }
  
  Matrix(int height_, int width_) {
    height = height_;
    width = width_;
    
    rows = new Row[height];
    for(int i = 0; i < height; i++) {
      rows[i] = new Row(width);
    }
    LUPOutdated = true;
  }
  
  Row getRow(int index) {
    //LUPOutdated = true;
    return rows[index];
  }
  
  void setRow(int index, Row value) {
    if(value.getWidth() == getWidth()) {
      rows[index] = value;
      //LUPOutdated = true;
    }
    else {
      System.out.println("Cannot set value: row width different from matrix width");
    }
  }
  
  Row getColumn(int index) {
    Row column = new Row(getHeight());
    for(int i = 0; i < getHeight(); i++) {
      column.setValue(i, getValue(i, index));
    }
    return column;
  }
  
  void setColumn(int index, Row value) {
    if(value.getWidth() == getHeight()) {
      for(int i = 0; i < getHeight(); i++) {
        setValue(i, index, value.getValue(i));
      }
      //LUPOutdated = true;
    }
    else {
      System.out.println("Cannot set value: row width different from matrix height");
    }
  }
  
  double getValue(int row, int column) {
    return getRow(row).getValue(column);
  }
  
  void setValue(int row, int column, double value) {
    getRow(row).setValue(column, value);
    //LUPOutdated = true;
  }
  
  int getWidth() {
    return width;
  }
  
  int getHeight() {
    return height;
  }
  
  boolean equals(Matrix matrix2) {
    if(getHeight() == matrix2.getHeight()) {
      for(int i = 0; i < getHeight(); i++) {
        if(!getRow(i).equals(matrix2.getRow(i))) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
  
  Matrix copy() {
    Matrix newMatrix = new Matrix(getHeight(), getWidth());
    for(int i = 0; i < getHeight(); i++) {
      newMatrix.setRow(i, getRow(i).copy());
    }
    return newMatrix;
  }
  
  Matrix negate() {
    Matrix result = copy();
    for(int i = 0; i < getHeight(); i++) {
      result.setRow(i, getRow(i).negate());
    }
    return result;
  }
  
  void addInPlace(Matrix matrix2) {
    if(getHeight() == matrix2.getHeight()) {
      for(int i = 0; i < getHeight(); i++) {
        getRow(i).addInPlace(matrix2.getRow(i));
      }
      //LUPOutdated = true;
    }
    else {
      System.out.println("Cannot add: matrices different heights");
    }
  }
  
  Matrix add(Matrix matrix2) {
    Matrix result = copy();
    result.addInPlace(matrix2);
    return result;
  }
  
  Matrix subtract(Matrix matrix2) {
    Matrix result = copy();
    result.addInPlace(matrix2.negate());
    return result;
  }
  
  Matrix multiply(Matrix matrix2) {
    if(getWidth() == matrix2.getHeight()) {
      Matrix product = new Matrix(getHeight(), matrix2.getWidth());
      for(int row = 0; row < getHeight(); row++) {
        for(int column = 0; column < matrix2.getWidth(); column++) {
          product.setValue(row, column, getRow(row).dotProduct(matrix2.getColumn(column)));
        }
      }
      return product;
    }
    else {
      System.out.println("Cannot multiply: matrix sizes incompatible");
      return new Matrix(0, 0);
    }
  }
  
  void multiplyInPlace(double constant) {
    for(int i = 0; i < getHeight(); i++) {
      getRow(i).multiplyInPlace(constant);
    }
    //LUPOutdated = true;
  }
  
  Matrix multiply(double constant) {
    Matrix result = copy();
    result.multiplyInPlace(constant);
    return result;
  }
  
  void print() {
    for(int i = 0; i < getHeight(); i++) {
      getRow(i).print();
    }
    System.out.println("");
  }
  
  void swapRows(int row1, int row2) {
    Row temp = getRow(row1);
    setRow(row1, getRow(row2));
    setRow(row2, temp);
    //LUPOutdated = true;
  }
  
  static Matrix identity(int size) {
    Matrix result = new Matrix(size, size);
    for(int i = 0; i < size; i++) {
      result.setValue(i, i, 1);
    }
    return result;
  }
  
  Matrix transpose() {
    Matrix result = new Matrix(getWidth(), getHeight());
    for(int i = 0; i < getWidth(); i++) {
      result.setRow(i, getColumn(i));
    }
    return result;
  }
  
  Matrix getMinor(int row, int column) {
    Matrix result = new Matrix(getHeight() - 1, getWidth() - 1);
    for(int i = 0; i < row; i++) {
      result.setRow(i, getRow(i).removeValue(column));
    }
    for(int i = row + 1; i < getHeight(); i++) {
      result.setRow(i - 1, getRow(i).removeValue(column));
    }
    return result;
  }
  
  double trace() {
    if(getHeight() == getWidth()) {
      double result = 1;
      for(int i = 0; i < getHeight(); i++) {
        result *= getValue(i, i);
      }
      return result;
    }
    else {
      System.out.println("Cannot calculate trace: matrix not square");
      return 0;
    }
  }
  
  double determinant() {
    if(getHeight() == getWidth()) {
      if(getHeight() == 2) {
        return getValue(0, 0)*getValue(1, 1) - getValue(1, 0)*getValue(0, 1);
      }
      else if(getHeight() <= 5) {
        double value = 0;
        int sign = 1;
        for(int column = 0; column < getWidth(); column++) {
          value += sign * getValue(0, column) * getMinor(0, column).determinant();
          sign = -sign;
        }
        return value;
      }
      else {
        //if(LUPOutdated) {
        //  LUP = LUPDecompose();
        //}
        LUPResult LUP = LUPDecompose();
        return LUP.getL().trace() * LUP.getU().trace() * LUP.getDeterminantSign();
      }
    }
    else {
      System.out.println("Cannot calculate determinant: matrix not square");
      return 0;
    }
  }
  
  Matrix inverse() {
    if(getHeight() == getWidth()) {
      //if(LUPOutdated) {
      //  LUP = LUPDecompose();
      //}
      LUPResult LUP = LUPDecompose();
      Matrix L = LUP.getL();
      Matrix U = LUP.getU().copy();
      Matrix P = LUP.getP();
      Matrix LInv = Matrix.identity(getHeight());
      Matrix UInv = Matrix.identity(getHeight());
      
      for(int i = 0; i < getHeight(); i++) {
        for(int j = i + 1; j < getHeight(); j++) {
          LInv.getRow(j).addInPlace(LInv.getRow(i).multiply(-L.getValue(j, i)));
        }
      }
      
      double diagonalValueRecip;
      for(int i = getHeight() - 1; i >= 0; i--) {
        diagonalValueRecip = 1 / U.getValue(i, i);
        U.getRow(i).multiplyInPlace(diagonalValueRecip);
        UInv.getRow(i).multiplyInPlace(diagonalValueRecip);
        for(int j = i - 1; j >= 0; j--) {
          UInv.getRow(j).addInPlace(UInv.getRow(i).multiply(-U.getValue(j, i)));
        }
      }
      
      return UInv.multiply(LInv.multiply(P));
    }
    else {
      System.out.println("Cannot invert: matrix not square");
      return new Matrix(0, 0);
    }
  }
  
  Row solve(Matrix y) {
    Matrix newY;
    if(y.getHeight() == 1) {
      newY = y.transpose();
    }
    else {
      newY = y;
    }
    return inverse().multiply(newY).getColumn(0);
  }

  LUPResult LUPDecompose() {
    if(getHeight() == getWidth()) {
      Matrix L = new Matrix(getHeight(), getHeight());
      Matrix U = copy();
      Matrix P = Matrix.identity(getHeight());
      double multiplier = 0;
      int determinantSign = 1;
      
      double currentValue, maxValue;
      int maxRow;
      for(int i = 0; i < getHeight(); i++) {
        maxValue = 0;
        maxRow = i;
        for(int j = i; j < getHeight(); j++) {
          currentValue = Math.abs(U.getValue(j, i));
          if(currentValue > maxValue) {
            maxValue = currentValue;
            maxRow = j;
          }
        }
        if(maxRow != i) {
          L.swapRows(i, maxRow);
          U.swapRows(i, maxRow);
          P.swapRows(i, maxRow);
          determinantSign = -determinantSign;
        }
        
        for(int k = i + 1; k < getHeight(); k++) {
          multiplier = U.getValue(k, i) / U.getValue(i, i);
          U.getRow(k).addInPlace(U.getRow(i).multiply(-multiplier));
          L.setValue(k, i, multiplier);
        }
      }
      
      L.addInPlace(Matrix.identity(getHeight()));
      return new LUPResult(L, U, P, determinantSign);
    }
    else {
      System.out.println("Cannot perform LUP: matrix not square");
      return new LUPResult();
    }
    
  }
}