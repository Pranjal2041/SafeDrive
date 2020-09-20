import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:whatthehack/insurance/screens/home/homescreen.dart';
import 'package:whatthehack/insurance/screens/map_screen/map_screen.dart';
import 'package:whatthehack/insurance/screens/tablescreen/tablescreen.dart';
import 'package:whatthehack/insurance/screens/reports/reports_list.dart';
import 'package:whatthehack/insurance/transitions/fade.dart';
import 'package:whatthehack/insurance/values/colors.dart';

import '../screens/map_screen/map_screen.dart';
import '../screens/reports/reports_list.dart';

class BottomNavbar extends StatelessWidget {
  final String selected;
  BottomNavbar(this.selected);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.red[50],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(AntDesign.home),
            color: selected == 'home' ? colorPalette[11] : Colors.grey,
            onPressed: () {
              if (selected != 'home') fadeTo(context, HomeScreen());
            },
          ),
          IconButton(
            icon: Icon(SimpleLineIcons.map),
            color: selected == 'map' ? colorPalette[11] : Colors.grey,
            onPressed: () {
              if (selected != 'map') fadeTo(context, MapScreen());
            },
          ),
          IconButton(
            icon: Icon(SimpleLineIcons.chart),
            color: selected == 'table' ? colorPalette[11] : Colors.grey,
            onPressed: () {
              if (selected != 'table') fadeTo(context, TableScreen());
            },
          ),
          IconButton(
            icon: Icon(AntDesign.folder1),
            color: selected == 'reports' ? colorPalette[11] : Colors.grey,
            onPressed: () {
              if (selected != 'reports') fadeTo(context, ReportsListScreen());
            },
          ),
        ],
      ),
    );
  }
}
