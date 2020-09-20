import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/map_screen/CustomMap.dart';
import 'package:whatthehack/user/screens/reportCrash/widgets/legal_advice.dart';

import '../../../insurance/screens/reports/widgets/card.dart';
import '../../../insurance/values/colors.dart';
import '../../../insurance/widgets/header.dart';

class ReportCrashResult extends StatefulWidget {
  final double lat;
  final double long;
  final bool fromSos;
  final bool sendMsg;
  ReportCrashResult({this.lat, this.long, this.fromSos = false, this.sendMsg});
  @override
  _ReportCrashResultState createState() => _ReportCrashResultState();
}

class _ReportCrashResultState extends State<ReportCrashResult> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double w;

  @override
  void initState() {
    if (widget.sendMsg) getRelief();
    super.initState();
  }

  Future<void> getRelief() async {
    try {
      await sendMessages();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Your emergency contacts have been informed.'),
        duration: Duration(seconds: 2),
      ));
    } on Exception {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Messages could not be sent.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppHeader(
              height: 230,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 50, 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report submitted',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                            child: Icon(
                              Icons.check_box,
                              size: 30,
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ReportDisplayCard(
              width: w - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Text(
                      'Hospitals near you',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: fetchNearbyHospitals(widget.lat, widget.long),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Container(
                                  height: 200,
                                  // color: colorPalette[0],
                                  child: CustomMap(lat: widget.lat, long: widget.long, zoom: 10.0, markCurrent: true, latLongLis: List.generate(snapshot.data.length, (index) => LatLng((snapshot.data[index] as Venue).lat, (snapshot.data[index] as Venue).long))),
                                ),
                                Column(
                                  children: List.generate(snapshot.data.length, (i) {
                                    return ListTile(
                                      title: Text(snapshot.data[i].name),
                                      subtitle: Text(snapshot.data[i].address),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.directions,
                                          color: colorPalette[11],
                                        ),
                                        onPressed: () async {
                                          var mapUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + snapshot.data[i].name + ' ' + snapshot.data[i].address;
                                          var encoded = Uri.encodeFull(mapUrl);
                                          if (await canLaunch(encoded)) launch(encoded);
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text('No Hospitals found near you.'),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ReportDisplayCard(
              width: w - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Text(
                      'Repair Outlets near you',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: fetchNearbyRepairs(widget.lat, widget.long),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Container(
                                    height: 200,
                                    // color: colorPalette[0],
                                    child: CustomMap(lat: widget.lat, long: widget.long, zoom: 10.0, markCurrent: true, latLongLis: List.generate(snapshot.data.length, (index) => LatLng((snapshot.data[index] as Venue).lat, (snapshot.data[index] as Venue).long)))),
                                Column(
                                  children: List.generate(snapshot.data.length, (i) {
                                    return ListTile(
                                      title: Text(snapshot.data[i].name),
                                      subtitle: Text(snapshot.data[i].address),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.directions,
                                          color: colorPalette[11],
                                        ),
                                        onPressed: () async {
                                          var mapUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + snapshot.data[i].name + ' ' + snapshot.data[i].address;
                                          var encoded = Uri.encodeFull(mapUrl);
                                          if (await canLaunch(encoded)) launch(encoded);
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text('No repair outlets found near you.'),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: !widget.fromSos ? 10 : 40,
            ),
            !widget.fromSos ? LegalAdviceCard(width: w - 40) : Container(),
            !widget.fromSos
                ? SizedBox(
                    height: 40,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
