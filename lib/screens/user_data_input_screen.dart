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
  int height = 180;
  int weight = 60;
  int age = 20;
  var gender;
  AppUser cAppUser;
  CalculatorBrain cBrain;
  int currentTabIndex = 4;
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
    }
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
                                    } else {
                                      weight = 0;
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
                                    } else {
                                      age = 0;
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
                print('drink ${cBrain.calculateDailyH2O()} L');
                setState(() {
                  //updateUserHealth(); //TODO:onTap update ui
                });
                //Navigator.of(context).pop();
                Navigator.pushNamed(context, HomeScreen.id, arguments: {
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
                Navigator.pushNamed(context, StepTracker.id, arguments: {
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
                Navigator.pushNamed(context, GenderSelect.id, arguments: {
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