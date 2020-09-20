import 'package:flutter/material.dart';

import '../screens/home/widgets/header.dart';
import '../values/colors.dart';

class AppHeader extends StatefulWidget {
  final Widget child;
  final double height;
  AppHeader({this.height, this.child});
  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: colorGradient,
        ),
        child: SafeArea(
          child: widget.child,
        ),
      ),
    );
  }
}
