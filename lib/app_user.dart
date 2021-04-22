import 'package:flutter/material.dart';
import 'package:fooducate/calculator_brain.dart';
import 'dart:async';
import 'food.dart';
import 'goal.dart';
import 'calculate_button.dart';

enum gender {
  female,
  male,
}

class AppUser {
  String _name, _email, _password;
  double _height,
      _weight,
      _bmi,
      targetWeight,
      _calorieIn,
      _calorieOut,
      workOutTime,
      _totalCalorieIn;
  int _age, _phoneNo, _dailyH2O, _stepsCount, _dailyH2Odone;
  var _gender;
  List<String> MedCond = new List(5);
  List<String> FoodPref = new List(5);
  List<Food> _food = List();
  Goal _goal, _goalPerWeek;
  //Progress progress;
  //CalculatorBrain cAppUserCalculatorBrain;
  void addMeals(Food f) {
    _food.add(f);
  }

  void setFood(List<Food> f) {
    _food = f;
  }

  void removeMeals(Food f) {
    _food.remove(f);
  }

  void removeAllFood() {
    _food.clear();
  }

  List<Map<dynamic, dynamic>> getAllFood() {
    List<Map<dynamic, dynamic>> foodList = List<Map<dynamic, dynamic>>();
    for (var f in _food) {
      foodList.add({
        'name': f.name,
        'calories': f.calories,
        'quantity': f.quantity,
        'protein': f.protein,
        'fat': f.fat,
        'carbs': f.carbs,
        'foodImgURL': f.foodImgURL
      });
    }
    return foodList;
  }

  dynamic foodMapToFoodObjectArray(var fm) {
    List<Food> foodOA = List<Food>();
    for (var f_m in fm) {
      foodOA.add(Food(
          calories: f_m['calories'].toDouble(),
          fat: f_m['fat'].toDouble(),
          carbs: f_m['carbs'].toDouble(),
          protein: f_m['protein'].toDouble(),
          name: f_m['name'],
          quantity: f_m['quantity'].toDouble(),
          foodImgURL: f_m['foodImgURL']));
    }
    return foodOA;
  }

  double totalCaloriesOfFood() {
    _totalCalorieIn = 0.0;
    for (Food fo_od in _food) {
      _totalCalorieIn+=fo_od.calories;
    }
    return _totalCalorieIn;
  }

  int getAllFoodLength() {
    return _food.length;
  }

  dynamic getAllMeals() {
    return _food;
  }

  void printAllMeals() {
    print('I had\n');
    for (Food f in _food) {
      print('${f.name},${f.calories}');
    }
  }

  void setHeight(double h) {
    _height = h;
  }

  void setCalorieIn(double calorieIn) {
    _calorieIn = calorieIn;
  }

  void setWeight(double w) {
    _weight = w;
  }

  void setGender(var gender) {
    _gender = gender;
  }

  void setName(String n) {
    _name = n;
  }

  void setEmail(String e) {
    _email = e;
  }

  void setPassword(String p) {
    _password = p;
  }

  void setPhoneNo(int p) {
    _phoneNo = p;
  }

  void setAge(int age) {
    _age = age;
  }

  void setBMI(double bmi) {
    _bmi = bmi;
  }

  void setDailyH2O(int dailyH2O) {
    _dailyH2O = dailyH2O;
  }

  void setDailyH2Odone(int dailyH2Odone) {
    _dailyH2Odone = dailyH2Odone;
  }

  void setStepsCount(int stepCount) {
    _stepsCount = stepCount;
  }

  double getHeight() {
    return _height;
  }

  double getCalorieIn() {
    return _calorieIn;
  }

  double getWeight() {
    return _weight;
  }

  dynamic getGender() {
    return _gender;
  }

  String getName() {
    return _name;
  }

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }

  int getPhoneNo() {
    return _phoneNo;
  }

  int getAge() {
    return _age;
  }

  double getBMI() {
    return _bmi;
  }

  int getDailyH2O() {
    return _dailyH2O;
  }

  int getDailyH2Odone() {
    return _dailyH2Odone;
  }

  int getStepsCount() {
    return _stepsCount;
  }
  double getCalorieOut(){
    return _calorieOut;
  }
  void setCalorieOut() {
    _calorieOut = _stepsCount/_weight*0.57;
  }
  void setAppUser() {}
}
