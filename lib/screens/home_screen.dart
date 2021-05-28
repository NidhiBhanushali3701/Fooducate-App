import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculator_brain.dart';
import 'package:fooducate/food.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/trackers/calorie_tracker.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'food_search_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _fireBaseStore = FirebaseFirestore.instance;
  bool showSpinner = false;
  AppUser cAppUser = AppUser();
  CalculatorBrain cBrain = CalculatorBrain();
  String sBMI = ' ',
      sCalorie = ' ',
      sSteps = '0',
      sUserH2O = '0',
      sFoodCal = '0';
  int currentTabIndex = 0;
  String cAppUserEmail = '';
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    verifyUserEmail();
    getUserDataFromFireBaseStore();
    /*
    if (sBMI == null || sCalorie == null) {
      updateUserHealth(cAppUser);
    }
    */
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        //currentUser = user;
        cAppUser.setEmail(user.email);
        //cAppUser.setPassword();
        print(user.email);
        cAppUserEmail = user.email;
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

  void update_UserDataInFireBaseStore(String updateField, var updatedValue) {
    _fireBaseStore
        .collection('clients')
        .doc(cAppUserEmail)
        .update({updateField: updatedValue});
  }

  void updateUserHealth(var cAppUserData) async {
    sBMI = await cAppUserData['bmi'].toStringAsFixed(1);
    sCalorie = cAppUserData['caloriesIn'].floor().toString();
    sSteps = cAppUserData['stepCount'].toString();
    sUserH2O = (cAppUserData['dailyH2Odone'].toInt()).toString();
  }

  void foodUserDataFireBaseStore() {
    //update_UserDataInFireBaseStore('food', List<Map>());
    List<Food> food = cAppUser.getAllMeals();
    _fireBaseStore.collection('clients').doc(cAppUser.getEmail()).update({
      'food': FieldValue.arrayUnion(
          cAppUser.getAllFood()) //cAppUser.getAllMeals()[0])
    });
  }

  void addUserDataToFireBaseStore() {
    _fireBaseStore.collection('clients').doc(cAppUser.getEmail()).set({
      'email': cAppUser.getEmail(),
      'password': cAppUser.getPassword(),
      'bmi': cAppUser.getBMI(),
      'height': cAppUser.getHeight(),
      'weight': cAppUser.getWeight(),
      'age': cAppUser.getAge(),
      'caloriesIn': cAppUser.getCalorieIn(),
      'dailyH2O': cAppUser.getDailyH2O(),
      'dailyH2Odone': cAppUser.getDailyH2Odone(),
      'gender': cAppUser.getGender().toString(),
      'name': cAppUser.getName(),
      'phoneNo': cAppUser.getPhoneNo(),
      'stepCount': cAppUser.getStepsCount(),
    });
  }

  void updateUserDataInFireBaseStore(
      FirebaseFirestore _fireBaseStore, AppUser cAppUser) {
    _fireBaseStore.collection('clients').doc(cAppUser.getEmail()).update({});
  }

  void getUserDataFromFireBaseStore() async {
    var appUsers = await _fireBaseStore.collection('clients').get();
    for (var appUser in appUsers.docs) {
      var appUserData = appUser.data();
      print(appUserData);
      if (cAppUserEmail == appUserData['email']) {
        print(appUserData);
        cAppUser.setEmail(appUserData['email']);
        cAppUser.setDailyH2Odone(appUserData['dailyH2Odone'].toInt());
        cAppUser.setWeight(appUserData['weight'].toDouble());
        cAppUser.setHeight(appUserData['height'].toDouble());
        cAppUser.setAge(appUserData['age']);
        cAppUser.setGender(appUserData['gender']);
        cAppUser.setDailyH2O(appUserData['dailyH2O']);
        cAppUser.setStepsCount(appUserData['stepCount']);
        cAppUser.setCalorieIn(appUserData['caloriesIn']);
        cAppUser.setBMI(appUserData['bmi']);
        updateUserHealth(appUserData);
      }
    }
  }

  dynamic getStreamUserDataFromFireBaseStore(
      FirebaseFirestore _fireBaseStore, AppUser cAppUser) async {
    await for (var appUsers
        in _fireBaseStore.collection('clients').snapshots()) {
      for (var appUser in appUsers.docs) {
        print(appUser.data());
      }
    }
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
      cBrain = arguments['CurrentAppUserCB'];
      print(
          'in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      //updateUserHealth(cAppUser);
      print(
          'in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      cAppUserEmail = cAppUser.getEmail();
      //updateUserHealth(cAppUser);
    }
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: FutureBuilder(
          future: _fireBaseStore.collection('clients').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              showSpinner = false;
              // If we got an error
              if (snapshot.hasData) {
                for (var appUsers in snapshot.data.docs) {
                  if (appUsers['email'] == cAppUserEmail) {
                    updateUserHealth(appUsers);
                    print(appUsers['stepCount']);
                    print('foods eaten  = $sFoodCal');
                    cAppUser.removeAllFood();
                    cAppUser.setFood(
                        cAppUser.foodMapToFoodObjectArray(appUsers['food']));
                    sFoodCal =
                        cAppUser.totalCaloriesOfFood().toInt().toString();
                    print(sFoodCal);
                    break;
                  }
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
            } else {
              showSpinner = true;
            }
            return Scaffold(
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
                        //clearSession();
                        //Navigator.pop(context,true);
                        Navigator.popUntil(
                            context, ModalRoute.withName(StartScreen.id));
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
                                style: kLabelTextStyle.copyWith(
                                    color: Colors.purple),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                //TODO: Update the actual Calories value here
                                ('$sCalorie kCal'),
                                style: kLabelTextStyle.copyWith(
                                    color: Colors.purple),
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
                                style: kLabelTextStyle.copyWith(
                                    color: Colors.purple),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                sBMI, //TODO: BMI
                                style: kLabelTextStyle.copyWith(
                                    color: Colors.purple),
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
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, StepTracker.id,
                                  arguments: {
                                    'CurrentAppUserData': cAppUser,
                                    'CurrentAppUserCB': cBrain
                                  });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "STEPS DONE ",
                                  style: kLabelTextStyle.copyWith(
                                      color: Colors.purple),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  sSteps, //TODO: updating steps
                                  style: kLabelTextStyle.copyWith(
                                      color: Colors.purple),
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
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, H2OTracker.id,
                                  arguments: {
                                    'CurrentAppUserData': cAppUser,
                                    'CurrentAppUserCB': cBrain
                                  });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WATER TRACKER ",
                                  style: kLabelTextStyle.copyWith(
                                      color: Colors.purple),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  (' ${sUserH2O}/${cAppUser.getDailyH2O().toString()} glasses'), //TODO: updating steps
                                  style: kLabelTextStyle.copyWith(
                                      color: Colors.purple),
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
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, CalorieTracker.id, arguments: {
                                'CurrentAppUserData': cAppUser,
                                'CurrentAppUserCB': cBrain
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "YOUR CALORIE INTAKE IS",
                                  style: kLabelTextStyle.copyWith(
                                      color: Colors.purple),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  (' $sFoodCal kCal'), //TODO: updating steps
                                  style: kLabelTextStyle.copyWith(
                                      color: Colors.purple),
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
                selectedItemColor: Colors.purple,
                unselectedItemColor: Colors.purple.shade100,
                elevation: 15,
                currentIndex: currentTabIndex,
                onTap: (int index) {
                  setState(() {
                    currentTabIndex = index;
                    addUserDataToFireBaseStore();
                    getUserDataFromFireBaseStore();
                    //currentPage = pages[index];
                  });
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                    icon: IconButton(
                      icon: Icon(
                        Icons.home_outlined,
                      ), //Icon(Icons.account_circle_rounded)
                      onPressed: () {
                        setState(() {
                          //updateUserHealth();
                        });
                      },
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Steps',
                    icon: IconButton(
                      icon: Icon(
                        Icons.directions_walk_rounded,
                      ), //Icon(Icons.account_circle_rounded)

                      onPressed: () {
                        Navigator.pushNamed(context, StepTracker.id,
                            arguments: {
                              'CurrentAppUserData': cAppUser,
                              'CurrentAppUserCB': cBrain
                            });
                      },
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Food',
                    icon: IconButton(
                      icon: Icon(
                        Icons.restaurant_menu,
                      ), //Icon(Icons.account_circle_rounded)
                      onPressed: () {
                        Navigator.pushNamed(context, FoodScreen.id, arguments: {
                          'CurrentAppUserData': cAppUser,
                          'CurrentAppUserCB': cBrain
                        });
                      },
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Water Tracker',
                    icon: IconButton(
                      icon: Icon(
                        Icons.wine_bar_sharp,
                      ), //Icon(Icons.account_circle_rounded)

                      onPressed: () {
                        Navigator.pushNamed(context, H2OTracker.id, arguments: {
                          'CurrentAppUserData': cAppUser,
                          'CurrentAppUserCB': cBrain
                        });
                      },
                    ),
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(Icons.account_circle_rounded),
                    label: 'Me',
                    icon: IconButton(
                      icon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, GenderSelect.id,
                            arguments: {
                              'CurrentAppUserData': cAppUser,
                              'CurrentAppUserCB': cBrain
                            }); //arguments: {'CurrentAppUserData': cAppUser}
                        setState(() {
                          //updateUserHealth();
                        });
                        //Navigator.pushNamed(context, routeName)
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

/*

void addUserDataToFireBaseStore(
    FirebaseFirestore _fireBaseStore, AppUser cAppUser) {
  _fireBaseStore.collection('clients').doc(cAppUser.getEmail()).set({
    'email': cAppUser.getEmail(),
    'password': cAppUser.getPassword(),
    'bmi': cAppUser.getBMI(),
    'height': cAppUser.getHeight(),
    'weight': cAppUser.getWeight(),
    'age': cAppUser.getAge(),
    'caloriesIn': cAppUser.getCalorieIn(),
    'dailyH2O': cAppUser.getDailyH2O(),
    'dailyH2Odone': cAppUser.getDailyH2Odone()/4,
    'gender': cAppUser.getGender().toString(),
    'name': cAppUser.getName(),
    'phoneNo': cAppUser.getPhoneNo(),
    'stepCount': cAppUser.getStepsCount(),
  });
}

void updateUserDataToFireBaseStore(
    FirebaseFirestore _fireBaseStore, AppUser cAppUser) {
  _fireBaseStore.collection('clients').doc(cAppUser.getEmail()).update({});
}

void getUserDataFromFireBaseStore(FirebaseFirestore _fireBaseStore,
    AppUser cAppUser, String cAppUserEmail) async {
  var appUsers = await _fireBaseStore.collection('clients').get();
  for (var appUser in appUsers.docs) {
    var appUserData = appUser.data();
    print(appUserData);
    if (cAppUserEmail == appUserData['email']) {
      print(appUserData);
      cAppUser.setEmail(appUserData['email']);
      cAppUser.setDailyH2Odone(appUserData['dailyH2Odone'].toInt());
      cAppUser.setWeight(appUserData['weight']);
      cAppUser.setHeight(appUserData['height']);
      cAppUser.setAge(appUserData['age']);
      cAppUser.setGender(appUserData['gender']);
      cAppUser.setDailyH2O(appUserData['dailyH2O']);
      cAppUser.setStepsCount(appUserData['stepCount']);
      cAppUser.setCalorieIn(appUserData['caloriesIn']);
    }
  }
}

dynamic getStreamUserDataFromFireBaseStore(
    FirebaseFirestore _fireBaseStore, AppUser cAppUser) async {
  await for (var appUsers in _fireBaseStore.collection('clients').snapshots()) {
    for (var appUser in appUsers.docs) {
      print(appUser.data());
    }
  }
}

*/
