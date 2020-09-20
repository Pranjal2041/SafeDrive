import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/screens/home/widgets/body.dart';
import 'package:whatthehack/insurance/screens/charts/filters.dart';
import 'package:whatthehack/insurance/screens/home/widgets/header.dart';
import 'package:whatthehack/insurance/widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              HomeHeader(),
              HomeBody(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar('home'),
    );
  }
}
