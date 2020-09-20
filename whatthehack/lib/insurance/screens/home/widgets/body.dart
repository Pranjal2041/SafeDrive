import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/screens/home/widgets/displaycard.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  double w;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            DisplayCard(
              index: 0,
              width: w - 40,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            DisplayCard(
              index: 1,
              width: w - 40,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            DisplayCard(
              index: 2,
              width: w - 40,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            DisplayCard(
              index: 3,
              width: w - 40,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
