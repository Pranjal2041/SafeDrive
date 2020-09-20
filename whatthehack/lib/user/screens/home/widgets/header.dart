import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/insurance/widgets/header.dart';
import 'package:whatthehack/user/screens/reportCrash/report_result.dart';
import 'package:whatthehack/user/widgets/app_name_heading.dart';

class UserHomeHeader extends StatefulWidget {
  UserHomeHeader();
  @override
  _UserHomeHeaderState createState() => _UserHomeHeaderState();
}

class _UserHomeHeaderState extends State<UserHomeHeader> {
  Future<double> fetchSafetyIndex() async {
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double rsi = 73.0;
    try {
      rsi = await fetchDeathRate(position.longitude, position.longitude);
    } on Exception {
      print('User out of US');
    }
    return rsi;
  }

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      height: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: FlatButton.icon(
                    label: Text(
                      'SOS',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.3,
                        fontSize: 18,
                      ),
                    ),
                    icon: Icon(
                      MaterialCommunityIcons.alert,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      // Send message to contacts and find GPS location using SMS API
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportCrashResult(
                            lat: position.latitude,
                            long: position.longitude,
                            fromSos: true,
                            sendMsg: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 10, 10),
                  child: AppNameHeading(size: 52,),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      'Based on current location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Uncomment for Rank safety index
                  FutureBuilder(
                      future: fetchSafetyIndex(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            height: 150,
                            width: 150,
                            child: SfRadialGauge(
                              enableLoadingAnimation: true,
                              axes: <RadialAxis>[
                                RadialAxis(
                                  showLabels: false,
                                  showTicks: false,
                                  startAngle: 270,
                                  endAngle: 270,
                                  radiusFactor: 1.1,
                                  pointers: <GaugePointer>[
                                    RangePointer(
                                      value: snapshot.data,
                                      color: colorPalette[11],
                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        axisValue: 50,
                                        positionFactor: 0.6,
                                        widget: Column(
                                          children: [
                                            Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              'Road Safety Index',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              )),
        ],
      ),
    );
  }
}
