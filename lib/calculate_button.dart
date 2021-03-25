import 'package:flutter/material.dart';
import 'package:fooducate/constants.dart';

class CalculateButton extends StatelessWidget {
  CalculateButton({@required this.onTap, @required this.buttonTitle});

  final Function onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kNumberTextStyle.copyWith(
              color: Colors.white,
              fontSize: 40.0,
            ),
          ),
        ),
        color: Colors.purple,
        margin: EdgeInsets.only(top: 10.0),
        // padding: EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        height: 80.0,
      ),
    );
  }
}