import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculate_button.dart';
import 'package:fooducate/screens/home_screen.dart';
import '../calculator_brain.dart';
import '../constants.dart';
import '../tracker.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class CalorieTracker extends StatefulWidget {
  static String id = 'calorieTracker';
  AppUser cAppUser;
  CalorieTracker({Key key, @required this.cAppUser}) : super(key: key);
  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> with Tracker {
  int currentTabIndex = 2;
  AppUser cAppUser;
  CalculatorBrain cBrain;
  final _fireBaseStore = FirebaseFirestore.instance;
  String cAppUserEmail;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      //if string data
      //print(arguments['CurrentAppUserData']);
      //if you passed object
      //final cAppUser = arguments['CurrentAppUserData'];
      cAppUser = arguments['CurrentAppUserData'];
      cBrain = arguments['CurrentAppUserCB'];
      print(
          'in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      //updateUserHealth();
      print(
          'in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      cAppUserEmail = cAppUser.getEmail();
    }
    return FutureBuilder(
        future: _fireBaseStore.collection('clients').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasData) {
              for (var appUsers in snapshot.data.docs) {
                if (appUsers['email'] == cAppUserEmail) {
                  print(appUsers['food']);
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
            return CircularProgressIndicator(
              backgroundColor: kInactiveCardColour,
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: const Text('TRACK CALORIES'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.ios_share, color: Colors.white),
                    onPressed: () async {
                      /*setState(() {
                      showSpinner = true;
                    });
                    //await _auth.signOut();
                    //clearSession();
                    //Navigator.pop(context,true);
                    //Navigator.popUntil(context, ModalRoute.withName(StartScreen.id));
                    //Navigator.pop(context);
                    //Navigator.pop(context);
                    setState(() {
                      showSpinner = false;
                    });*/
                    }),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  'Your Meals',
                  style: kLabelTextStyle.copyWith(color: Colors.purple),
                )),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      DataTable(columns: [
                        DataColumn(
                            label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('Items',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          ),
                        )),
                        DataColumn(
                            label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('Amount',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          ),
                        )),
                        DataColumn(
                            label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('Calories',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          ),
                        )),
                      ], rows: []),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  flex: 12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 8, 8.0),
                    child: Center(
                      child: Container(
                        child: ListView.builder(
                            itemCount: cAppUser.getAllFoodLength(),
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                        title: Text(
                                      cAppUser.getAllMeals()[index].name,
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                        title: Text(
                                      cAppUser
                                          .getAllMeals()[index]
                                          .quantity
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                        title: Text(
                                      cAppUser
                                          .getAllMeals()[index]
                                          .calories
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ),
                                ],
                              ); //Text(cAppUser.getAllMeals()[index].name);
                            }),
                      ),
                    ),
                  ),
                ),
                CalculateButton(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, HomeScreen.id,
                        arguments: {
                          'CurrentAppUserData': cAppUser,
                          'CurrentAppUserCB': cBrain
                        });
                    /*Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: {
                  'CurrentAppUserData': cAppUser,
                  'CurrentAppUserCB': cBrain
                });*/
                  },
                  buttonTitle: "GO BACK",
                ),
              ],
            ),
          );
        });
  }
}
/*

ListView(
              children: <Widget>[
                ListTile(
                  title: Center(
                      child: Text(
                    'Your Meals',
                    style: kLabelTextStyle.copyWith(color: Colors.purple),
                  )),
                ),
                DataTable(columns: [
                  DataColumn(
                      label: Text('Food Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Amount',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Calories',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ], rows: []),
              ],
            ),

*/
/*
Row(
                children: [
                  Expanded(
                      child: ListTile(
                          title: Text(cAppUser.getAllMeals()[index].name))),
                  ListTile(
                    title: Text(
                        cAppUser.getAllMeals()[index].calories.toString()),
                  ),
                  ListTile(
                      title: Text(cAppUser
                          .getAllMeals()[index]
                          .quantity
                          .toString()))
                ],
              );
*/
