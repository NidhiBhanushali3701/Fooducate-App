import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculator_brain.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'api_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Food {
  double calories, fat, carbs, protein;
  String name = '', foodImgURL = '';
  Food({this.calories, this.fat, this.carbs, this.protein, this.foodImgURL,this.name});
}
