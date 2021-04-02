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
      calorieOut,
      workOutTime;
  int _age, _phoneNo, _dailyH2O, _stepsCount, _dailyH2Odone;
  gender _gender;
  List<String> MedCond = new List(5);
  List<String> FoodPref = new List(5);
  List<Food> food = new List(100);
  Goal _goal, _goalPerWeek;
  //Progress progress;
  //CalculatorBrain cAppUserCalculatorBrain;

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
}
