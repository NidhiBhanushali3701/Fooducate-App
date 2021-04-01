import 'package:flutter/material.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/reusable_card.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fooducate/calculate_button.dart';
import 'file:///C:/Users/Nidhi/Desktop/AndroidStudioProjects/fooducate/lib/screens/user_data_input_screen.dart';

//enum gender { female, male }

class GenderSelect extends StatefulWidget {
  static String id = 'genderSelectScreen';
  AppUser cAppUser;
  GenderSelect({Key key,@required this.cAppUser}) : super(key: key);
  @override
  _GenderSelectState createState() => _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect> {
  var _gender;
  AppUser cAppUser;
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
        title: Text('USER PROFILE'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      _gender = gender.male;
                      print('male');
                      cAppUser.setGender(gender.male);
                      print('male');
                      Navigator.pushNamed(context, UserData.id,arguments: {'CurrentAppUserData': cAppUser});
                      setState(() {
                        _gender = gender.male;
                        print('male');
                        cAppUser.setGender(gender.male);
                        Navigator.pushNamed(context, UserData.id,arguments: {'CurrentAppUserData': cAppUser});
                      });
                    },
                    colour: _gender == gender.male
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.mars,
                      label: '  MALE  ',
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      _gender = gender.female;
                      print('female');
                      cAppUser.setGender(gender.female);
                      print('female');
                      Navigator.pushNamed(context, UserData.id,arguments: {'CurrentAppUserData': cAppUser});
                      setState(() {
                        _gender = gender.female;
                        print('female');
                        cAppUser.setGender(gender.female);
                        Navigator.pushNamed(context, UserData.id,arguments: {'CurrentAppUserData': cAppUser});
                      });
                    },
                    colour: _gender == gender.female
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.venus,
                      label: ' FEMALE ',
                    ),
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
