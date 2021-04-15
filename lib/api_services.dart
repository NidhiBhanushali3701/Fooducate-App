import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

const String apiID = '163e292906cb4a208c4010d5996a5413';

class apiServices {
  apiServices({this.foodItem});
  String foodItem;
  String url =
      'https://api.spoonacular.com/recipes/guessNutrition?apiKey=$apiID&title=';
  String urlMoreN =
      'https://api.spoonacular.com/recipes/1003464/nutritionWidget.json';
  String imgURL =
      'https://api.spoonacular.com/recipes/queries/analyze?apiKey=$apiID&q=';
  Future getData() async {
    var urlS = url + foodItem;
    http.Response response = await http.get(urlS);
    if (response.statusCode == 200) {
      print(response.body);
      var foodData = jsonDecode(response.body);
      print(foodData);
      return foodData;
    } else
      return {};
  }

  Future getFoodImg() async {
    var foodImgURL = imgURL + foodItem;
    http.Response response = await http.get(foodItem);
    return jsonDecode(response.body);
  }
}
