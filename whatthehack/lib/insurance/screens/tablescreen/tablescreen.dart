import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:whatthehack/insurance/screens/map_screen/widgets/marker.dart';

import 'package:whatthehack/insurance/screens/tablescreen/widgets/datatable.dart';
import 'package:whatthehack/insurance/widgets/bottom_navbar.dart';
import 'package:latlong/latlong.dart';
import 'package:whatthehack/insurance/widgets/header.dart';

class TableScreen extends StatefulWidget {
  @override
  TableScreenState createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            AppHeader(
              height: 220,
              child: Expanded(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Text(
                        'Statewise Crash Data',
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
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StateDataTable(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar('table'),
    );
  }
}
