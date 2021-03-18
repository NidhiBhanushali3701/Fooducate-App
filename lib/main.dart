import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooducate/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'start_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: 'startScreen',
    routes: {
      StartScreen.id: (context) {
        return StartScreen();
      },
      LogInScreen.id: (context) {
        return LogInScreen();
      },
      SignUpScreen.id : (context) {
        return SignUpScreen();
      },
      HomeScreen.id : (context){
        return HomeScreen();
      }
    },
  ));
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