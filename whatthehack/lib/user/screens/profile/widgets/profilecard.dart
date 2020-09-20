import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/transitions/fade.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/user/screens/family/familyscreen.dart';

class ProfileCard extends StatefulWidget {
  final String title;
  final Widget content;
  final bool seedetails;
  ProfileCard({@required this.title, this.content, this.seedetails = true});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  double w;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Material(
      elevation: 10,
      child: Container(
        width: w - 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      fadeTo(context, FamilyScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: widget.seedetails
                          ? Text(
                              'See details',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: colorPalette[11]),
                            )
                          : Container(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(10.0), child: widget.content),
          ],
        ),
      ),
    );
  }
}
