import 'dart:math';
import 'app_user.dart';

enum gender {
  female,
  male,
}

class CalculatorBrain {
  final int height;
  final int weight;
  final int age;
  var gender;
  double _bmi;
  double _calories, _caloriesIn, _caloriesOut;
  AppUser cUser;
  int _dailyH2O;
  CalculatorBrain({this.height, this.weight, this.age, this.cUser});

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    cUser.setBMI(_bmi);
    cUser.setHeight(height.toDouble());
    cUser.setWeight(weight.toDouble());
    cUser.setAge(age);
    cUser.setGender('female');
    return _bmi.toStringAsFixed(1);
  }

  String calculateCalories() {
    _calories = weight * 24 * 0.98 * 1.65;
    print(_calories);
    double basicCal =
        10 * cUser.getWeight() + 6.25 * cUser.getHeight() - 5 * cUser.getAge();
    print(basicCal);
    try {
      if (cUser.getGender() == 'female') {
        cUser.setCalorieIn(basicCal - 161);
        print('female = ${basicCal - 161}');
      } else {
        cUser.setCalorieIn(basicCal + 5);
        print('male = ${basicCal + 5}');
      }
    }
    catch(e)
    {
      print('Here gender error');
      print(e);
    }
    cUser.setCalorieIn(_calories);
    return _calories.toStringAsFixed(0);
  }
  String calculateDailyH2O(){
    cUser.workOutTime = 0;//TODO: ask this from user
    _dailyH2O = (((cUser.getWeight()*2/3)+cUser.workOutTime*5/2)~/33.814);
    print(_dailyH2O);
    return _dailyH2O.toStringAsFixed(0);
  }

}
