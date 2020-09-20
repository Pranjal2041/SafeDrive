import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/list_body.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/list_header.dart';
import 'package:whatthehack/user/widgets/bottom_navbar.dart';

class UserReportsListScreen extends StatefulWidget {
  @override
  _UserReportsListScreenState createState() => _UserReportsListScreenState();
}

class _UserReportsListScreenState extends State<UserReportsListScreen> {
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
      bottomNavigationBar: UserBottomNavbar('reports'),
    );
  }
}
