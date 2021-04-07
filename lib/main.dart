import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooducate/food.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/start_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/gender_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'screens/user_data_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:fooducate/app_user.dart';
import 'trackers/step_tracker.dart';
import 'package:http/http.dart';
import 'screens/food_search_screen.dart';
import 'screens/food_nutrition_data_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    //initialRoute: StartScreen.id,
    initialRoute: StartScreen.id,
    routes: {
      StartScreen.id: (context) {
        return StartScreen();
      },
      LogInScreen.id: (context) {
        return LogInScreen();
      },
      SignUpScreen.id: (context) {
        return SignUpScreen();
      },
      HomeScreen.id: (context) {
        return HomeScreen();
      },
      UserData.id: (context) {
        return UserData();
      },
      StepTracker.id: (context) {
        return StepTracker();
      },
      GenderSelect.id: (context) {
        return GenderSelect();
      },
      H2OTracker.id: (context) {
        return H2OTracker();
      },
      FoodScreen.id: (context) {
        return FoodScreen();
      },
      FoodNutritionalDataScreen.id: (context) {
        return FoodNutritionalDataScreen();
      },
    },
  ));
}
