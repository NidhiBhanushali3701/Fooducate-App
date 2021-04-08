import 'package:fooducate/app_user.dart';
import 'package:fooducate/calculate_button.dart';
import 'package:fooducate/calculator_brain.dart';
import 'package:fooducate/constants.dart';
import 'package:fooducate/food.dart';
import 'package:fooducate/main.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
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
          'in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      //updateUserHealth();
      print(
          'in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
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
          'Nutrition Chart',
          style: kLabelTextStyle.copyWith(color: Colors.purple),
        )),
        DataTable(
          columns: [
            DataColumn(
                label: Text('No',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Amount',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
          height: 100,
        ),
        CalculateButton(
          onTap: () {
            Food f = Food(
                calories: double.parse(calories),
                fat: double.parse(fats),
                name: foodName,
                carbs: double.parse(carbs),
                protein: double.parse(protein),
                quantity: 1,
                foodImgURL: ' ');
            cAppUser.addMeals(f);
            print(cAppUser.getAllMeals());
            cAppUser.printAllMeals();
            setState(() {
              //updateUserHealth(); //TODO:onTap update ui
            });
            //Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: {
              'CurrentAppUserData': cAppUser,
              'CurrentAppUserCB': cBrain
            });
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
              icon:
                  Icon(Icons.home_rounded), //Icon(Icons.account_circle_rounded)
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
              icon: Icon(
                  Icons.restaurant_menu), //Icon(Icons.account_circle_rounded)
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
                  Icons.wine_bar_sharp), //Icon(Icons.account_circle_rounded)
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
