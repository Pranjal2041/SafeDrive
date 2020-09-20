import 'package:flutter/material.dart';

List<Color> colorPalette = [
  Color.fromRGBO(240, 167, 167, 1),
  Color.fromRGBO(235, 138, 138, 1),
  Color.fromRGBO(233, 123, 123, 1),
  Color.fromRGBO(230, 109, 109, 1),
  Color.fromRGBO(228, 94, 94, 1),
  Color.fromRGBO(225, 79, 79, 1),
  Color.fromRGBO(223, 65, 65, 1),
  Color.fromRGBO(221, 51, 51, 1),
  Color.fromRGBO(215, 36, 36, 1),
  Color.fromRGBO(182, 31, 31, 1),
  Color.fromRGBO(182, 31, 31, 1),
  Color.fromRGBO(149, 25, 25, 1),
  Color.fromRGBO(116, 20, 20, 1),
  Color.fromRGBO(83, 14, 14, 1),
];

LinearGradient colorGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [colorPalette[3], colorPalette[12]],
);
