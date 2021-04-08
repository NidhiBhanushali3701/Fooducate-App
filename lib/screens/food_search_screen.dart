import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooducate/api_services.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculator_brain.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/screens/food_nutrition_data_screen.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/screens/home_screen.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FoodScreen extends StatefulWidget {
  static String id = 'foodScreen';
  AppUser cAppUser;
  FoodScreen({Key key, @required this.cAppUser}) : super(key: key);
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String name;
  double quantity, calories, fats, carbs;
  var Nutrients; //= Map();
  bool showSpinner = false;
  AppUser cAppUser;
  CalculatorBrain cBrain;

  int currentTabIndex = 2;
  @override
  void initState() {
    super.initState();
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
      print('in home ${cAppUser.getEmail()}');
    }
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: null,
          title: Text('FOOD SEARCH'),
          backgroundColor: Colors.purple,
        ),
        body: SafeArea(
          child: Container(
            child: ListView(children: [
              Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Food Nutritional Data',
                            style:
                                TextStyle(color: Colors.purple, fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            // ignore: missing_return
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple)),
                                labelText: 'Food Item name',
                                labelStyle: TextStyle(color: Colors.purple),
                                hintText: 'Enter valid food as pizza'),
                            onChanged: (value) => name = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 30,
                          ),
                        ),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: EdgeInsets.all(12),
                          child: Container(
                            height: 48,
                            width: 237,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(
                              onPressed: () async {
                                /*if (_formKey.currentState.validate()) {
                                            registerToFireBase();
                                          }*/ //commented on 6.11pm 17-3-21
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  Nutrients = await apiServices(foodItem: name)
                                      .getData();
                                  print('In search screen \n$Nutrients');
                                  setState(() {
                                    showSpinner = false;
                                    calories = Nutrients['calories']['value'];
                                    fats = Nutrients['fat']['value'];
                                    carbs = Nutrients['carbs']['value'];
                                    print(calories);
                                    print(fats);
                                    print(carbs);
                                    Navigator.pushNamed(
                                        context, FoodNutritionalDataScreen.id,
                                        arguments: {
                                          'CurrentAppUserData': cAppUser,
                                          'CurrentAppUserCB': cBrain,
                                          'foodName':name,
                                          'calories': calories.toString(),
                                          'fats': fats.toString(),
                                          'carbs': carbs.toString(),
                                          'protein': Nutrients['protein']
                                                  ['value']
                                              .toString(),
                                        });
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text(
                                'SEARCH',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
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
      ),
    );
  }
}
/*
ListView(children: <Widget>[
                    Center(
                        child: Text(
                      'Nutrition Chart',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                    DataTable(
                      columns: [
                        DataColumn(
                            label: Text('Sr. no',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Name',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Amount',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('1')),
                          DataCell(Text('A')),
                          DataCell(Text('a')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('2')),
                          DataCell(Text('B')),
                          DataCell(Text('b')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('3')),
                          DataCell(Text('C')),
                          DataCell(Text('c')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('4')),
                          DataCell(Text('D')),
                          DataCell(Text('d')),
                        ]),
                      ],
                    ),
                  ])
*/
