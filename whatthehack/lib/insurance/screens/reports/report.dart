import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/report_header.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/reportbody.dart';

class ReportScreen extends StatefulWidget {
  final CrashDetail crash;
  final Weather weather;
  final Damage damage;
  final Kinematics kinematics;
  ReportScreen({
    this.crash,
    this.damage,
    this.kinematics,
    this.weather,
  });
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ReportHeader(
              crash: widget.crash,
            ),
            ReportBody(
              crash: widget.crash,
              damage: widget.damage,
              weather: widget.weather,
              kinematics: widget.kinematics,
            ),
          ],
        ),
      ),
    );
  }
}
