import './activate.dart';
import './calculate.dart';
import './feedforward.dart';

class GenericLayer with FeedforwardCompose {
  GenericLayer(int inputs, int outputs, Activation act, Activation actPrime) {
    steps.add(CalculationLayer(inputs, outputs));
    steps.add(ActivationLayer(act, actPrime));
  }

  Map<String, dynamic> toJson() {
    final calc = steps.first as CalculationLayer;
    return {
      'weights': calc.weights,
      'bias': calc.bias,
    };
  }
}
