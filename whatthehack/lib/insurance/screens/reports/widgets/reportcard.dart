import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/map_screen/CustomMap.dart';
import 'package:whatthehack/insurance/screens/reports/report.dart';

class ReportCard extends StatefulWidget {
  final CrashDetail crash;
  final Weather weather;
  final Damage damage;
  final Kinematics kinematics;
  ReportCard({
    this.crash,
    this.damage,
    this.kinematics,
    this.weather,
  });
  @override
  _ReportCardState createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  double w;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportScreen(
                  crash: widget.crash,
                  damage: widget.damage,
                  weather: widget.weather,
                  kinematics: widget.kinematics,
                ),
            ));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Material(
            elevation: 10,
            child: Container(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: (w - 40) / 2,
                    height: 120,
                    child: Material(
                      elevation: 5,
                      child: CustomMap(
                        lat: widget.crash.lat,
                        long: widget.crash.long,
                        zoom: 14.0,
                        latLongLis: [LatLng(widget.crash.lat,widget.crash.long)]
                      )
                      // Image.asset(
                      //   'assets/testmap.png',
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  Container(
                    width: (w - 40) / 2,
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.5,
                            horizontal: 10,
                          ),
                          child: Text(
                            widget.crash.address,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 2.5, 10, 10),
                          child: FittedBox(
                            child: Text(
                              widget.crash.time,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
