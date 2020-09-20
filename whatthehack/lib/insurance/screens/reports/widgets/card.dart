import 'package:flutter/material.dart';
import '../../../values/colors.dart';

class ReportDisplayCard extends StatefulWidget {
  final Widget child;
  final double width;
  ReportDisplayCard({@required this.child, @required this.width,});

  @override
  _ReportDisplayCardState createState() => _ReportDisplayCardState();
}

class _ReportDisplayCardState extends State<ReportDisplayCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        width: widget.width,
        child: widget.child,
      ),
    );
  }
}
