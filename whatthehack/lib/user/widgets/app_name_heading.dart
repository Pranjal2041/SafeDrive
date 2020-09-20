import 'package:flutter/material.dart';

class AppNameHeading extends StatelessWidget {
  final double size;
  AppNameHeading({this.size});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Spartan',
          fontWeight: FontWeight.w500,
          fontSize: (18 / 30) * size,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(
              text: 'S',
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w400,
              )),
          TextSpan(text: 'AFE'),
          TextSpan(
              text: 'D',
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w400,
              )),
          TextSpan(text: 'RIVE'),
        ],
      ),
    );
  }
}
