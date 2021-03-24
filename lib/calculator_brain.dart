import 'dart:math';

class CalculatorBrain {
  CalculatorBrain({this.height, this.weight});
  final int height;
  final int weight;
  double _bmi;
  double _calories;

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String calculateCalories() {
    _calories = weight * 24 * 0.98 * 1.65;
    return _calories.toStringAsFixed(0);
  }
}
