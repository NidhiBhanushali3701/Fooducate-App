import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'file:///C:/Users/Nidhi/Desktop/AndroidStudioProjects/fooducate/lib/screens/user_data_input_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_database/firebase_database.dart';//not present yet
import '../constants.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'start_screen.dart';
import '../main.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  static String id = 'homeScreen';
  //FirebaseUser currentUser;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  AppUser cAppUser = AppUser();
  String sBMI = ' ', sCalorie = ' ', sSteps = '0', sUserH2O = '0';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    verifyUserEmail();
    if (sBMI == null || sCalorie == null) {
      updateUserHealth();
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        //currentUser = user;
        cAppUser.setEmail(user.email);
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void verifyUserEmail() async {
    try {
      final user = await _auth.currentUser;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        print('Verification Mail Sent!');
      }
    } catch (e) {
      print(e);
    }
  }

  void updateUserHealth() {
    sBMI = cAppUser.getBMI().toStringAsFixed(1);
    sCalorie = cAppUser.getCalorieIn().floor().toString();
    sSteps = cAppUser.getStepsCount().toString();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      //if string data
      print(arguments['CurrentAppUserData']);
      //if you passed object
      //final cAppUser = arguments['CurrentAppUserData'];
      cAppUser = arguments['CurrentAppUserData'];
      print('in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      updateUserHealth();
      print('in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
    }
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          centerTitle: true,
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  await _auth.signOut();
                  Navigator.pushNamed(context, StartScreen.id);
                  //Navigator.pop(context);
                  //Navigator.pop(context);
                  setState(() {
                    showSpinner = false;
                  });
                }),
          ],
          title: Text(
            'FOODUCATE HOME',
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image(
                    image: AssetImage('images/start_img.png'),
                  ),
                  Container(
                    height: 200.0,
                    width: 200.0,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "CALORIES YOU NEED ",
                          style: kLabelTextStyle.copyWith(color: Colors.purple),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          //TODO: Update the actual Calories value here
                          sCalorie,
                          style: kLabelTextStyle.copyWith(color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200.0,
                    width: 200.0,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "YOUR BMI : ",
                          style: kLabelTextStyle.copyWith(color: Colors.purple),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          sBMI, //TODO: BMI
                          style: kLabelTextStyle.copyWith(color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200.0,
                    width: 200.0,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                        )
                      ],
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, StepTracker.id,
                            arguments: {'CurrentAppUserData': cAppUser});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "STEPS DONE ",
                            style:
                                kLabelTextStyle.copyWith(color: Colors.purple),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            sSteps, //TODO: updating steps
                            style:
                                kLabelTextStyle.copyWith(color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    width: 200.0,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                        )
                      ],
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, H2OTracker.id);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "WATER TRACKER ",
                            style:
                                kLabelTextStyle.copyWith(color: Colors.purple),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            sUserH2O, //TODO: updating steps
                            style:
                                kLabelTextStyle.copyWith(color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: IconButton(
                icon: Icon(Icons.home_rounded,
                    color: Colors.purple), //Icon(Icons.account_circle_rounded)
                onPressed: () {
                  setState(() {
                    updateUserHealth();
                  });
                },
              ),
            ),
            BottomNavigationBarItem(
              label: 'Steps',
              icon: IconButton(
                icon: Icon(Icons.directions_walk_rounded,
                    color: Colors.purple), //Icon(Icons.account_circle_rounded)
                onPressed: () {
                  Navigator.pushNamed(context, StepTracker.id,
                      arguments: {'CurrentAppUserData': cAppUser});
                },
              ),
            ),
            BottomNavigationBarItem(
              label: 'Me',
              icon: IconButton(
                icon: Icon(Icons.account_circle_rounded, color: Colors.purple),
                onPressed: () {
                  Navigator.pushNamed(context, GenderSelect.id,
                      arguments: {'CurrentAppUserData': cAppUser});
                  setState(() {
                    //updateUserHealth();
                  });
                  //Navigator.pushNamed(context, routeName)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
