import '../matrix.dart';
import './feedforward.dart';

typedef Activation = Matrix Function(Matrix input);

class ActivationLayer implements Feedforward {
  final Activation _act;
  final Activation _actPrime;
  Matrix? _input;

  ActivationLayer(this._act, this._actPrime);

  @override
  Matrix forward(Matrix input) {
    _input = Matrix.clone(input);
    return _act(input);
  }

  @override
  Matrix backward(Matrix outputGradient, double learningRate) {
    if (_input == null) {
      throw StateError('input is null');
    }

    return outputGradient * _actPrime(_input!);
  }
}
