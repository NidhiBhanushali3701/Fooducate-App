import 'package:fooducate/constants.dart';
import 'package:fooducate/main.dart';
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
    );
  }
}
