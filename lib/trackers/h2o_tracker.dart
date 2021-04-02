import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculate_button.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/icon_content.dart';
import 'package:fooducate/reusable_card.dart';
import 'package:fooducate/round_icon_button.dart';
import 'package:fooducate/tracker.dart';
import 'package:fooducate/screens/home_screen.dart';
import '../calculator_brain.dart';

class H2OTracker extends StatefulWidget {
  static String id = 'h2oTrackerScreen';
  AppUser cAppUser;
  H2OTracker({Key key, this.cAppUser}) : super(key: key);
  @override
  _H2OTrackerState createState() => _H2OTrackerState();
}

class _H2OTrackerState extends State<H2OTracker> with Tracker {
  int userDrankH2O = 0; //user drank H2O
  double h2oProgress;
  AppUser cAppUser;
  CalculatorBrain cBrain;
  String h2oMSG = '';
  double calculateH2OProgress() {
    return h2oProgress = (userDrankH2O / cAppUser.getDailyH2O());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        title: Text('WATER TRACKER'),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
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
                                  h2oMSG = ' ';
                                } else {
                                  userDrankH2O = 0;
                                  h2oMSG = 'Water drank cant be negative';
                                }
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
                                userDrankH2O++;
                                h2oMSG = 'GOOD H2O is needed for proper body functions!';
                              });
                            },
                          )
                        ],
                      ),
                      Text(h2oMSG),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
