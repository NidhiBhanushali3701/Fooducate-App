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
  double _height, _weight, _bmi,targetWeight,calorieIn,calorieOut;
  int _age, _phoneNo;
  var _gender;
  List<String> MedCond = new List(5);
  List<String> FoodPref = new List(5);
  List<Food> food = new List(100);
  Goal _goal,_goalPerWeek;
  //Progress progress;

  void setHeight(double h) {
    _height = h;
  }

  void setWeight(double w) {
    _weight = w;
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
}
