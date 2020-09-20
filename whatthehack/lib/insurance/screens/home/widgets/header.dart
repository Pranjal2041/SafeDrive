import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/widgets/header.dart';
import 'package:whatthehack/user/widgets/app_name_heading.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader();
  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return AppHeader(
      height: 300,
      child: Expanded(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 80,
              left: 20,
              child: AppNameHeading(
                size: 60,
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
