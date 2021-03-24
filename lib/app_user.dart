import 'package:flutter/material.dart';
import 'dart:async';
import 'food.dart';
import 'goal.dart';

enum gender {
  female,
  male,
}

class AppUser {
  String _name, _email, _password;
  double _height, _weight, _bmi, targetWeight, _calorieIn, calorieOut;
  int _age, _phoneNo;
  var _gender;
  List<String> MedCond = new List(5);
  List<String> FoodPref = new List(5);
  List<Food> food = new List(100);
  Goal _goal, _goalPerWeek;
  //Progress progress;

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
}
