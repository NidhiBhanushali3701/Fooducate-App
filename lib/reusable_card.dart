import 'package:flutter/material.dart';
import 'package:fooducate/main.dart';
import 'constants.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild,this.onPress,this.colour});
  final Color colour;
  final Widget cardChild;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: cardChild,
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}