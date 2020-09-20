import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/screens/charts/filters.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/user/screens/home/widgets/body.dart';
import 'package:whatthehack/user/screens/home/widgets/header.dart';
import 'package:whatthehack/user/screens/reportCrash/report_crash_screen.dart';
import 'package:whatthehack/user/widgets/bottom_navbar.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // Future completeDataFuture = fetchCompleteData();
  @override
  void initState() {
    removeFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UserHomeHeader(),
              UserHomeBody(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: UserBottomNavbar('home'),
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: colorPalette[11],
            child: Icon(
              Icons.report,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportCrashScreen()));
            },
          ),
        ),
      ),
    );
  }
}
