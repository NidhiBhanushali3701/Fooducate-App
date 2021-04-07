import 'package:fooducate/constants.dart';
import 'package:fooducate/main.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
import 'package:fooducate/trackers/step_tracker.dart';
import 'food_search_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';

class FoodNutritionalDataScreen extends StatefulWidget {
  static String id = 'foodNutritionalDataScreen';
  @override
  _FoodNutritionalDataScreenState createState() =>
      _FoodNutritionalDataScreenState();
}

class _FoodNutritionalDataScreenState extends State<FoodNutritionalDataScreen> {
  String calories = ' ', fats = ' ', carbs = ' ', protein = ' ';
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      //if string data
      //print(arguments['CurrentAppUserData']);
      //if you passed object
      //final cAppUser = arguments['CurrentAppUserData'];
      //cAppUser = arguments['CurrentAppUserData'];
      //cBrain = arguments['CurrentAppUserCB'];
      //print('in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
      //updateUserHealth();
      //print('in home ${cAppUser.getEmail()},${cAppUser.getGender()},${cAppUser.getStepsCount()}');
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
                label: Text('Sr. no',
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
      ]),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            icon: IconButton(
              icon: Icon(Icons.home_rounded,
                  color: Colors.purple), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                setState(() {
                  //updateUserHealth();
                });
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Steps',
            icon: IconButton(
              icon: Icon(Icons.directions_walk_rounded,
                  color: Colors.purple), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                Navigator.pushNamed(context, StepTracker.id);
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Food',
            icon: IconButton(
              icon: Icon(Icons.restaurant_menu,
                  color: Colors.purple), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                Navigator.pushNamed(context, FoodScreen.id);
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Water Tracker',
            icon: IconButton(
              icon: Icon(Icons.wine_bar_sharp,
                  color: Colors.purple), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                Navigator.pushNamed(context, H2OTracker.id);
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Me',
            icon: IconButton(
              icon: Icon(Icons.account_circle_rounded, color: Colors.purple),
              onPressed: () {
                Navigator.pushNamed(context, GenderSelect.id); //arguments: {'CurrentAppUserData': cAppUser}
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
