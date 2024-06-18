import '../matrix.dart';
import './feedforward.dart';

class CalculationLayer implements Feedforward {
  Matrix weights;
  Matrix bias;

  Matrix? _input;

  CalculationLayer(int inputs, int outputs)
      : weights = Matrix.random(outputs, inputs),
        bias = Matrix.random(outputs, 1);

  @override
  Matrix forward(Matrix input) {
    _input = Matrix.clone(input);
    return weights.dot(input) + bias;
  }

  @override
  Matrix backward(Matrix outputGradient, double learningRate) {
    if (_input == null) {
      throw StateError('input is null');
    }

    weights -= outputGradient.dot(_input!.T).scale(learningRate);
    bias -= outputGradient.scale(learningRate);
    return weights.T.dot(outputGradient);
  }
}
