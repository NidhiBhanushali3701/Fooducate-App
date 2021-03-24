import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'user_data_input.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'screens/start_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'userData',
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
      },
    ),
  );
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FOODUCATE",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroScreen(),
    );
  }
}
*/
