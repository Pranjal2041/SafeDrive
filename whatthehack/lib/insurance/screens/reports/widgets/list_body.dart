import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/reportcard.dart';

class ReportsListBody extends StatefulWidget {
  @override
  _ReportsListBodyState createState() => _ReportsListBodyState();
}

class _ReportsListBodyState extends State<ReportsListBody> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: List.generate(snapshot.data.length, (i) {
                return ReportCard(
                  crash: snapshot.data[i]['crash'],
                  damage: snapshot.data[i]['damage'],
                  weather: snapshot.data[i]['weather'],
                  kinematics: snapshot.data[i]['kinematics'],
                );
              }),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Future<List<Map<String, dynamic>>> getDetails() async {
    Weather weather = await fetchWeather();
    Damage damage = await fetchDamages();
    Kinematics kinematics = await getKinematicData();
    List<CrashDetail> list = await fetchCrashDetails();
    List<Map<String,dynamic>> listOfMaps = [];
    for (var detail in list) {
      listOfMaps.add({
        'crash': detail,
        'weather': weather,
        'damage': damage,
        'kinematics': kinematics,
      });
    }
    return listOfMaps;
  }