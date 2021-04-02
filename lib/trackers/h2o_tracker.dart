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
  H2OTracker({Key key, @required this.cAppUser}) : super(key: key);
  @override
  _H2OTrackerState createState() => _H2OTrackerState();
}

class _H2OTrackerState extends State<H2OTracker> with Tracker {
  int userDrankH2O; //user drank H2O
  double h2oProgress;
  AppUser cAppUser;
  double calculateH2OProgress() {
    return h2oProgress = (userDrankH2O / cAppUser.getDailyH2O());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
