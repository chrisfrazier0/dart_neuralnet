import 'dart:math';
import 'dart:typed_data';

class Matrix {
  final int rows;
  final int cols;
  final Float64List data;

  Matrix? _cache;

  Matrix.zero(this.rows, this.cols) : data = Float64List(rows * cols);

  Matrix.random(this.rows, this.cols) : data = Float64List(rows * cols) {
    for (int i = 0; i < data.length; i++) {
      data[i] = Random().nextDouble();
    }
  }

  Matrix.fromList(List<double> vector)
      : rows = vector.length,
        cols = 1,
        data = Float64List.fromList(vector);

  Matrix.clone(Matrix src, [int? rowCount, int? colCount])
      : rows = rowCount ?? src.rows,
        cols = colCount ?? src.cols,
        data = Float64List.fromList(src.data);

  double get(int row, int col) => data[col + row * cols];

  void set(int row, int col, double value) => data[col + row * cols] = value;

  Matrix get T {
    _cache ??= _transpose(this);
    return _cache!;
  }

  Matrix operator +(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw TypeError();
    }

    final result = Matrix.zero(rows, cols);
    for (int i = 0; i < data.length; i++) {
      result.data[i] = data[i] + other.data[i];
    }
    return result;
  }

  Matrix operator -(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw TypeError();
    }

    final result = Matrix.zero(rows, cols);
    for (int i = 0; i < data.length; i++) {
      result.data[i] = data[i] - other.data[i];
    }
    return result;
  }

  // Hadamard product
  Matrix operator *(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw TypeError();
    }

    final result = Matrix.zero(rows, cols);
    for (int i = 0; i < data.length; i++) {
      result.data[i] = data[i] * other.data[i];
    }
    return result;
  }

  // dot product
  Matrix dot(Matrix other) {
    if (cols != other.rows) {
      throw TypeError();
    }

    final result = Matrix.zero(rows, other.cols);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < other.cols; j++) {
        for (int k = 0; k < cols; k++) {
          result.data[j + i * other.cols] +=
              data[k + i * cols] * other.data[j + k * other.cols];
        }
      }
    }
    return result;
  }

  // scalar multiplication
  Matrix scale(double other) {
    final result = Matrix.zero(rows, cols);
    for (int i = 0; i < data.length; i++) {
      result.data[i] = data[i] * other;
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
      'cols': cols,
      'data': data,
    };
  }
}

_transpose(Matrix matrix) {
  if (matrix.rows == 1 || matrix.cols == 1) {
    return Matrix.clone(matrix, matrix.cols, matrix.rows);
  }

  final result = Matrix.zero(matrix.cols, matrix.rows);
  for (int i = 0; i < matrix.cols; i++) {
    for (int j = 0; j < matrix.rows; j++) {
      result.data[j + i * matrix.rows] = matrix.data[i + j * matrix.cols];
    }
  }
  return result;
}
