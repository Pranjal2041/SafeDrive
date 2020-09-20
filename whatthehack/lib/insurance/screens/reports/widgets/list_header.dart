import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/screens/home/widgets/header.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/insurance/widgets/header.dart';

class ReportsListHeader extends StatefulWidget {
  ReportsListHeader();
  @override
  _ReportsListHeaderState createState() => _ReportsListHeaderState();
}

class _ReportsListHeaderState extends State<ReportsListHeader> {
  @override
  Widget build(BuildContext context) {
    return AppHeader(
      height: 220,
      child: Expanded(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                'Recent Crash Reports',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
