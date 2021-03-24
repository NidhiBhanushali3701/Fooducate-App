import 'package:flutter/material.dart';
import 'package:fooducate/main.dart';
import 'constants.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: cardChild,
    );
  }
}
