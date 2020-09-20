import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/list_body.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/list_header.dart';
import 'package:whatthehack/insurance/widgets/bottom_navbar.dart';

class ReportsListScreen extends StatefulWidget {
  @override
  _ReportsListScreenState createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ReportsListHeader(),
              ReportsListBody(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar('reports'),
    );
  }
}
