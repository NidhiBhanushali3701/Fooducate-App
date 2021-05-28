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
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'home_screen.dart';
import '../calculator_brain.dart';

class UserData extends StatefulWidget {
  static String id = "userBMIData";
  AppUser cAppUser;
  UserData({Key key, @required this.cAppUser}) : super(key: key);
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  int height = 155;
  int weight = 60;
  int age = 20;
  var gender;
  AppUser cAppUser;
  CalculatorBrain cBrain;
  int currentTabIndex = 4;
  final _fireBaseStore = FirebaseFirestore.instance;
  String cAppUserEmail;
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
        print('init state $appUserData');
        weight = await appUserData['weight'].toInt();
        height = appUserData['height'].toInt();
        age = appUserData['age'];
        gender = appUserData['gender'];
      }
    }
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
      cAppUser = arguments['CurrentAppUserData'];
      print('in BMI calc ${cAppUser.getEmail()},${cAppUser.getGender()}');
      cAppUserEmail = cAppUser.getEmail();
    }
    return FutureBuilder(
        future: _fireBaseStore.collection('clients').get(),
        builder: (context, snapshot) {
          var appUsers;
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasData) {
              for (appUsers in snapshot.data.docs) {
                if (appUsers['email'] == cAppUserEmail) {
                  try {
                    print(appUsers['bmi']);
                    height = appUsers['height'].toInt();
                    weight = appUsers['weight'].toInt();
                    age = appUsers['age'];
                  } catch (e) {
                    height = 155;
                    weight = 60;
                    age = 20;
                    print(e);
                  }
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
          }
          /*else {
            return CircularProgressIndicator(
              backgroundColor: kInactiveCardColour,
            );
          }*/
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('USER BMI PROFILE'),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "HEIGHT",
                            style: kLabelTextStyle,
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                height.toString(),
                                style: kNumberTextStyle,
                              ),
                              Text(
                                " cm",
                                style: kLabelTextStyle,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Slider(
                            value: height.toDouble(),
                            min: 120.0,
                            max: 220.0,
                            activeColor: Colors.purple,
                            inactiveColor: Colors.grey,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                                updateUserDataInFireBaseStore('height', height);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ReusableCard(
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WEIGHT",
                                  style: kLabelTextStyle,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  weight.toString(),
                                  style: kNumberTextStyle,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundIconButton(
                                      icon: FontAwesomeIcons.minus,
                                      onPressed: () {
                                        setState(() {
                                          if (weight > 0) {
                                            weight--;
                                            updateUserDataInFireBaseStore(
                                                'weight', weight);
                                          } else {
                                            weight = 0;
                                            updateUserDataInFireBaseStore(
                                                'weight', weight);
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    RoundIconButton(
                                      icon: FontAwesomeIcons.plus,
                                      onPressed: () {
                                        setState(() {
                                          weight++;
                                          updateUserDataInFireBaseStore(
                                              'weight', weight);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "AGE",
                                  style: kLabelTextStyle,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  age.toString(),
                                  style: kNumberTextStyle,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundIconButton(
                                      icon: FontAwesomeIcons.minus,
                                      onPressed: () {
                                        setState(() {
                                          if (age > 0) {
                                            age--;
                                            updateUserDataInFireBaseStore(
                                                'age', age);
                                          } else {
                                            age = 0;
                                            updateUserDataInFireBaseStore(
                                                'age', age);
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    RoundIconButton(
                                      icon: FontAwesomeIcons.plus,
                                      onPressed: () {
                                        setState(() {
                                          age++;
                                          updateUserDataInFireBaseStore(
                                              'age', age);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CalculateButton(
                    onTap: () {
                      cBrain = CalculatorBrain(
                          height: height,
                          age: age,
                          weight: weight,
                          gender: cAppUser.getGender(),
                          cUser: cAppUser);
                      cBrain.calculateBMI();
                      cBrain.calculateDailyH2O();
                      cBrain.calculateCalories();
                      cAppUser
                          .setDailyH2O(int.parse(cBrain.calculateDailyH2O()));
                      print('drink ${cBrain.calculateDailyH2O()} L');
                      updateUserDataInFireBaseStore(
                          'dailyH2O', int.parse(cBrain.calculateDailyH2O()));
                      updateUserDataInFireBaseStore('bmi', cAppUser.getBMI());
                      updateUserDataInFireBaseStore(
                          'caloriesIn', cAppUser.getCalorieIn());
                      setState(() {
                        //updateUserHealth(); //TODO:onTap update ui
                      });
                      //Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, HomeScreen.id,
                          arguments: {
                            'CurrentAppUserData': cAppUser,
                            'CurrentAppUserCB': cBrain
                          });
                    },
                    buttonTitle: "CALCULATE",
                  ),
                ],
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
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
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
          );
        });
  }
}
/*void updateUserData() {
    if (cAppUser.getWeight() != null) {
      weight = cAppUser.getWeight().toInt();
    }
    if (cAppUser.getHeight() != null) {
      height = cAppUser.getHeight().toInt();
    }
    if (cAppUser.getAge() != null) {
      age = cAppUser.getAge().toInt();
    }
  }

  void initState() {
    super.initState();
    //updateUserData();
  }*/
