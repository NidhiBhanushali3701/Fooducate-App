import 'package:fooducate/app_user.dart';
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
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('TRACK CALORIES'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 27,
            ),
            Center(
                child: Text(
              'Your Meals',
              style: kLabelTextStyle.copyWith(color: Colors.purple),
            )),
            Container(
              child: Expanded(
                child: ListView(
                  children: <Widget>[
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
                flex: 1,
              ),
            ),
            Expanded(
              flex: 18,
                child: ListView.builder(
                    itemCount: cAppUser.getAllFoodLength(),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return DataTable(columns: [
                        DataColumn(
                            label: Text(
                          '',style: TextStyle(fontSize: 1),
                        )),
                        DataColumn(
                            label: Text(
                              '',style: TextStyle(fontSize: 1),
                        )),
                        DataColumn(
                            label: Text(
                              '',style: TextStyle(fontSize: 1),
                        )),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text(cAppUser.getAllMeals()[index].name)),
                          DataCell(Text(cAppUser
                              .getAllMeals()[index]
                              .calories
                              .toString())),
                          DataCell(Text(cAppUser
                              .getAllMeals()[index]
                              .quantity
                              .toString())),
                        ]),
                      ]); //Text(cAppUser.getAllMeals()[index].name);
                    })),
          ],
        ),
      ),
    );
  }
}
