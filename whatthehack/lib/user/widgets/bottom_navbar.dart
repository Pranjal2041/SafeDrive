import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:whatthehack/insurance/transitions/fade.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/user/screens/home/homescreen.dart';
import 'package:whatthehack/user/screens/profile/profilescreen.dart';
import 'package:whatthehack/user/screens/reports/reports_list.dart';

class UserBottomNavbar extends StatelessWidget {
  final String selected;
  UserBottomNavbar(this.selected);

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
              if (selected != 'home') fadeTo(context, UserHomeScreen());
            },
          ),
          IconButton(
            icon: Icon(SimpleLineIcons.user),
            color: selected == 'profile' ? colorPalette[11] : Colors.grey,
            onPressed: () {
              if (selected != 'profile') fadeTo(context, ProfileScreen());
            },
          ),
          IconButton(
            icon: Icon(AntDesign.folder1),
            color: selected == 'reports' ? colorPalette[11] : Colors.grey,
            onPressed: () {
              if (selected != 'reports') fadeTo(context, UserReportsListScreen());
            },
          ),
        ],
      ),
    );
  }
}
