import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculate_button.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/icon_content.dart';
import 'package:fooducate/reusable_card.dart';
import 'package:fooducate/round_icon_button.dart';
import 'package:fooducate/screens/food_search_screen.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/tracker.dart';
import 'package:fooducate/screens/home_screen.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../calculator_brain.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class H2OTracker extends StatefulWidget {
  static String id = 'h2oTrackerScreen';
  AppUser cAppUser;
  H2OTracker({Key key, this.cAppUser}) : super(key: key);
  @override
  _H2OTrackerState createState() => _H2OTrackerState();
}

class _H2OTrackerState extends State<H2OTracker> with Tracker {
  int userDrankH2O = 0; //user drank H2O
  double h2oProgress = -1;
  AppUser cAppUser;
  CalculatorBrain cBrain;
  String h2oMSG = '';
  int currentTabIndex = 3;
  String cAppUserEmail = '';
  final _fireBaseStore = FirebaseFirestore.instance;
  bool showSpinner = false;

  void updateUserDataInFireBaseStore(String updateField, var updatedValue) {
    _fireBaseStore
        .collection('clients')
        .doc(cAppUserEmail)
        .update({updateField: updatedValue});
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
        break;
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

  double calculateH2OProgress() {
    try {
      if (cAppUser.getDailyH2Odone() != null || cAppUser != null) {
        getUserDataFromFireBaseStore();
        return h2oProgress =
            ((cAppUser.getDailyH2Odone() / cAppUser.getDailyH2O()));
        //return h2oProgress = (tUserDrankH2O / (tUserH2ONeed));
      }
      return h2oProgress = ((userDrankH2O / cAppUser.getDailyH2O()));
    } catch (e) {
      print('error in h2o tracker \t $e');
      return 0.0;
    }
  }

  Path _buildRectPath() {
    return Path()
      ..moveTo(0, 200)
      ..lineTo(0, 90)
      ..lineTo(50, 90)
      ..lineTo(60, 90)
      ..lineTo(60, 90)
      ..lineTo(120, 90)
      ..lineTo(200, 90)
      ..lineTo(200, 200) //and back to the origin, could not be necessary #1
      ..close();
  }

  @override
  void initState() {
    super.initState();
    getUserDataFromFireBaseStore();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      //if string data
      print(arguments['CurrentAppUserData']);
      //if you passed object
      //final cAppUser = arguments['CurrentAppUserData'];
      calculateH2OProgress();
      cAppUser = arguments['CurrentAppUserData'];
      cBrain = arguments['CurrentAppUserCB'];
      print(
          'in h20 calc ${cAppUser.getEmail()},${cAppUser.getDailyH2Odone()},${cAppUser.getDailyH2O()}');
      calculateH2OProgress();
      cAppUserEmail = cAppUser.getEmail();
    }
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: null,
          title: Text('WATER TRACKER'),
          backgroundColor: Colors.purple,
        ),
        body: FutureBuilder(
            future: _fireBaseStore.collection('clients').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                showSpinner = false;
                // If we got an error
                if (snapshot.hasData) {
                  for (var appUsers in snapshot.data.docs) {
                    if (appUsers['email'] == cAppUserEmail) {
                      print('$userDrankH2O*-*${appUsers['dailyH2Odone']}');
                      userDrankH2O = (appUsers['dailyH2Odone']).toInt();
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
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ReusableCard(
                          cardChild: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "HOW MANY GLASSES OF WATER YOU DRANK ",
                                style: kLabelTextStyle,
                              ),
                              SizedBox(
                                height: 21.0,
                              ),
                              IconContent(
                                icon: FontAwesomeIcons.glassWhiskey,
                                label: '1 Glass = 250 ml',
                              ),
                              SizedBox(
                                height: 21.0,
                              ),
                              Text(
                                userDrankH2O.toString(),
                                style: kNumberTextStyle,
                              ),
                              SizedBox(
                                height: 21.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    onPressed: () {
                                      setState(() {
                                        if (userDrankH2O > 0) {
                                          userDrankH2O--;
                                          updateUserDataInFireBaseStore(
                                              'dailyH2Odone', userDrankH2O);
                                          h2oMSG = ' ';
                                        } else {
                                          userDrankH2O = 0;
                                          updateUserDataInFireBaseStore(
                                              'dailyH2Odone', 0);
                                          h2oMSG =
                                              'Water drank cant be negative';
                                        }
                                        calculateH2OProgress();
                                        cAppUser.setDailyH2Odone(userDrankH2O);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 21.0,
                                  ),
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    onPressed: () {
                                      setState(() {
                                        updateUserDataInFireBaseStore(
                                            'dailyH2Odone', (userDrankH2O + 1));
                                        userDrankH2O++;
                                        h2oMSG =
                                            'GOOD H2O is needed for proper body functions!';
                                        calculateH2OProgress();
                                        cAppUser.setDailyH2Odone(userDrankH2O);
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(h2oMSG,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          children: [
                            Text(
                              'YOUR DAILY H2O PROGRESS',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            ),
                            Container(
                              child: LiquidCustomProgressIndicator(
                                value: h2oProgress,
                                valueColor: AlwaysStoppedAnimation(Colors.cyan),
                                backgroundColor: Color(0xFFF3E5F5),
                                direction: Axis.vertical,
                                shapePath: _buildRectPath(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        CalculateButton(
                          onTap: () {
                            updateUserDataInFireBaseStore(
                                'dailyH2O', cAppUser.getDailyH2O());
                            updateUserDataInFireBaseStore(
                                'dailyH2Odone', cAppUser.getDailyH2Odone());
                            cAppUser.setDailyH2Odone(userDrankH2O);
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id, arguments: {
                              'CurrentAppUserData': cAppUser,
                              'CurrentAppUserCB': cBrain
                            });
                          },
                          buttonTitle: "CONTINUE",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.purple.shade100,
          elevation: 15,
          currentIndex: currentTabIndex,
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
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
                  Navigator.pushReplacementNamed(context, StepTracker.id,
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
                  Navigator.pushReplacementNamed(context, FoodScreen.id,
                      arguments: {
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
                  Navigator.pushReplacementNamed(context, H2OTracker.id,
                      arguments: {
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
                  Navigator.pushReplacementNamed(context, GenderSelect.id,
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
      ),
    );
  }
}
