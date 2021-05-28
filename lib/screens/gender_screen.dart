import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/food.dart';
import 'package:fooducate/reusable_card.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fooducate/calculate_button.dart';

import 'user_data_input_screen.dart';

//enum gender { female, male }

class GenderSelect extends StatefulWidget {
  static String id = 'genderSelectScreen';
  AppUser cAppUser;
  GenderSelect({Key key, @required this.cAppUser}) : super(key: key);
  @override
  _GenderSelectState createState() => _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect> {
  var _gender;
  AppUser cAppUser;
  final _fireBaseStore = FirebaseFirestore.instance;
  String cAppUserEmail;
  void updateUserDataInFireBaseStore(String updateField, var updatedValue) {
    _fireBaseStore
        .collection('clients')
        .doc(cAppUserEmail)
        .update({updateField: updatedValue});
  }

  void addUserDataToFireBaseStore() {
    print('here new data base${cAppUser.getEmail()}');
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
        _gender = appUserData['gender'];
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

      try {
        if (arguments['newAppUser'] == true) {
          cAppUser.setEmail(arguments['email']);
          addUserDataToFireBaseStore();
          updateUserDataInFireBaseStore('height', 155);
          updateUserDataInFireBaseStore('weight', 65);
          updateUserDataInFireBaseStore('age', 20);
          updateUserDataInFireBaseStore('caloriesIn', 0);
          updateUserDataInFireBaseStore('bmi', 0);
          updateUserDataInFireBaseStore('dailyH2Odone', 0);
          updateUserDataInFireBaseStore('stepCount', 0);
          updateUserDataInFireBaseStore('food', List<Map>());
          //updateUserDataInFireBaseStore('food', {'calories':0,'name':'food','quantity':0});
        }
      } catch (e) {
        print('not new user $e');
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('USER PROFILE'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fireBaseStore.collection('clients').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasData) {
                for (var appUsers in snapshot.data.docs) {
                  if (appUsers['email'] == cAppUserEmail) {
                    print(appUsers['gender']);
                    cAppUser.setGender(appUsers['gender']);
                    print(appUsers['gender']);
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
            return SafeArea(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(
                          onPress: () {
                            _gender = gender.male;
                            print('male');
                            updateUserDataInFireBaseStore(
                                'gender', gender.male.toString());
                            cAppUser.setGender(gender.male);
                            print('male');
                            Navigator.pushReplacementNamed(context, UserData.id,
                                arguments: {'CurrentAppUserData': cAppUser});
                            setState(() {
                              _gender = gender.male;
                              print('male');
                              updateUserDataInFireBaseStore(
                                  'gender', gender.male.toString());
                              cAppUser.setGender(gender.male);
                              Navigator.pushReplacementNamed(
                                  context, UserData.id,
                                  arguments: {'CurrentAppUserData': cAppUser});
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
                            updateUserDataInFireBaseStore(
                                'gender', gender.female.toString());
                            cAppUser.setGender(gender.female);
                            print('female');
                            Navigator.pushReplacementNamed(context, UserData.id,
                                arguments: {'CurrentAppUserData': cAppUser});
                            setState(() {
                              _gender = gender.female;
                              print('female');
                              updateUserDataInFireBaseStore(
                                  'gender', gender.female.toString());
                              cAppUser.setGender(gender.female);
                              Navigator.pushReplacementNamed(
                                  context, UserData.id,
                                  arguments: {'CurrentAppUserData': cAppUser});
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
            );
          }),
    );
  }
}
