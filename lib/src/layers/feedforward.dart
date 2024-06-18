import '../matrix.dart';

abstract class Feedforward {
  Matrix forward(Matrix input);
  Matrix backward(Matrix outputGradient, double learningRate);
}

mixin FeedforwardCompose implements Feedforward {
  final List<Feedforward> steps = [];

  @override
  Matrix forward(Matrix input) {
    return steps.fold(input, (data, step) => step.forward(data));
  }

  @override
  Matrix backward(Matrix outputGradient, double learningRate) {
    return steps.reversed.fold(outputGradient,
        (gradient, step) => step.backward(gradient, learningRate));
  }
}
