import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculate_button.dart';
import 'package:fooducate/calculator_brain.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/food.dart';
import 'package:fooducate/main.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/trackers/calorie_tracker.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'food_search_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';

class FoodNutritionalDataScreen extends StatefulWidget {
  static String id = 'foodNutritionalDataScreen';
  @override
  _FoodNutritionalDataScreenState createState() =>
      _FoodNutritionalDataScreenState();
}

class _FoodNutritionalDataScreenState extends State<FoodNutritionalDataScreen> {
  String calories = ' ', fats = ' ', carbs = ' ', protein = ' ', foodName = ' ';
  int currentTabIndex = 2;
  AppUser cAppUser;
  CalculatorBrain cBrain;
  final _fireBaseStore = FirebaseFirestore.instance;
  String cAppUserEmail;
  bool showSpinner = false;
  double amtOfItem = 1;
  void foodUserDataFireBaseStore() {
    List<Food> food = cAppUser.getAllMeals();
    _fireBaseStore
        .collection('clients')
        .doc(cAppUser.getEmail())
        .update({'food': FieldValue.arrayUnion(cAppUser.getAllFood())});
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      //if string data
      //print(arguments['CurrentAppUserData']);
      //if you passed object
      //final cAppUser = arguments['CurrentAppUserData'];
      foodName = arguments['foodName'];
      cAppUser = arguments['CurrentAppUserData'];
      cBrain = arguments['CurrentAppUserCB'];
      print(
          'in food nd ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      //updateUserHealth();
      print(
          'in food nd ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      if (arguments['calories'] != null) {
        calories = arguments['calories'];
      }
      if (arguments['fats'] != null) {
        fats = arguments['fats'];
      }
      if (arguments['carbs'] != null) {
        carbs = arguments['carbs'];
      }
      if (arguments['protein'] != null) {
        protein = arguments['protein'];
      }

      print('in table view $carbs,$calories,$fats,$protein');
    }
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: StreamBuilder(
          stream: _fireBaseStore
              .collection('clients')
              .doc(cAppUserEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              showSpinner = false;
              if (snapshot.hasData) {
                //for (var appUserS in snapshot.data.docs) {
                for (var appUsers in snapshot.data.docs) {
                  print(appUsers);
                  if (appUsers.data['email'] == cAppUserEmail) {
                    //try {
                    /*print('hello on line 60');
                        cAppUser.removeAllFood();
                        for (var fOM in appUsers['food']) {
                          print(appUsers['food']);
                          print('${fOM['calories']} in ${fOM['name']}');
                          cAppUser.addMeals(Food(
                              calories: fOM['calories'],
                              fat: fOM['fat'],
                              carbs: fOM['carbs'],
                              protein: fOM['protein'],
                              name: fOM['name'],
                              quantity: fOM['quantity'],
                              foodImgURL: fOM['foodImgURL']));
                        }/ */
                    //print(appUsers['food']);
                    cAppUser.setFood(cAppUser.foodMapToFoodObjectArray(
                        appUsers.data['food'])); //Todo: works
                    //print(cAppUser.getAllMeals());//todo uneeded
                    //} catch (e) {
                    //print('we are here $e');
                    //}
                    break;
                  }
                }
                //}
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
            /*FutureBuilder(
          future: _fireBaseStore.collection('clients').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              showSpinner = false;
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
              showSpinner = true;
            }
            */
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                leading: null,
                title: Text('FOOD NUTRITION DATA'),
                backgroundColor: Colors.purple,
              ),
              body: ListView(children: <Widget>[
                SizedBox(
                  height: 27,
                ),
                Center(
                    child: Text(
                  'Nutrition Chart (Quantity 1)',
                  style: kLabelTextStyle.copyWith(color: Colors.purple),
                )),
                DataTable(
                  columns: [
                    DataColumn(
                        label: Text('No',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Amount',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('Calories')),
                      DataCell(Text(calories)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2')),
                      DataCell(Text('Carbs')),
                      DataCell(Text(carbs)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3')),
                      DataCell(Text('Fats')),
                      DataCell(Text(fats)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('4')),
                      DataCell(Text('Protein')),
                      DataCell(Text(protein)),
                    ]),
                  ],
                ),
                SizedBox(
                  height: 27,
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          'Quantity ',
                          style: TextStyle(color: Colors.purple, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 0, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          // ignore: missing_return
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelText: 'Food Item Amount',
                              labelStyle: TextStyle(color: Colors.purple),
                              hintText: 'Enter valid Food Quantity as 1'),
                          onChanged: (value) => amtOfItem = double.parse(value),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                CalculateButton(
                  onTap: () {
                    Food f = Food(
                        calories: double.parse(calories) * amtOfItem,
                        fat: double.parse(fats) * amtOfItem,
                        name: foodName,
                        carbs: double.parse(carbs) * amtOfItem,
                        protein: double.parse(protein) * amtOfItem,
                        quantity: amtOfItem,
                        foodImgURL: ' ');
                    cAppUser.addMeals(f);
                    //print(cAppUser.getAllMeals());
                    foodUserDataFireBaseStore();
                    //cAppUser.removeAllFood();
                    cAppUser.printAllMeals();
                    //setState(() {//updateUserHealth(); //TODO:onTap update ui});
                    //Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, CalorieTracker.id,
                        arguments: {
                          'CurrentAppUserData': cAppUser,
                          'CurrentAppUserCB': cBrain
                        });
                    /*Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: {
                    'CurrentAppUserData': cAppUser,
                    'CurrentAppUserCB': cBrain
                  });*/
                  },
                  buttonTitle: "ADD TO MEALS",
                )
              ]),
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
                    label: 'Home',
                    icon: IconButton(
                      icon: Icon(Icons
                          .home_rounded), //Icon(Icons.account_circle_rounded)
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                      },
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Steps',
                    icon: IconButton(
                      icon: Icon(Icons
                          .directions_walk_rounded), //Icon(Icons.account_circle_rounded)
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
                      icon: Icon(Icons
                          .restaurant_menu), //Icon(Icons.account_circle_rounded)
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
                      icon: Icon(Icons
                          .wine_bar_sharp), //Icon(Icons.account_circle_rounded)
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
                    label: 'Me',
                    icon: IconButton(
                      icon: Icon(Icons.account_circle_rounded),
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
          }),
    );
  }
}
