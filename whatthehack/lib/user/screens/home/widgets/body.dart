import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whatthehack/insurance/screens/reports/report.dart';
import 'package:whatthehack/insurance/screens/map_screen/CustomMap.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/card.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/list_body.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/user/screens/reports/reports_list.dart';

class UserHomeBody extends StatefulWidget {
  @override
  _UserHomeBodyState createState() => _UserHomeBodyState();
}

class _UserHomeBodyState extends State<UserHomeBody> {
  double w;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        LineChartWidget(
          title: 'Distractions (Last 10 days)',
          y: 'Distractions',
          w:w,
          kineData: [
            {'x':'10 Jan','y': 2},
            {'x':'11 Jan','y': 3},
            {'x':'12 Jan','y': 2},
            {'x':'13 Jan','y': 6},
            {'x':'14 Jan','y': 0},
            {'x':'15 Jan','y': 8},
            {'x':'16 Jan','y': 2},
            {'x':'17 Jan','y': 5},
            {'x':'18 Jan','y': 4},
            {'x':'19 Jan','y': 5},
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            ReportDisplayCard(
              width: w - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Latest Claim',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserReportsListScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'View all',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: colorPalette[11]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                      future: getDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportScreen(
                                      crash: snapshot.data[0]['crash'],
                                      damage: snapshot.data[0]['damage'],
                                      weather: snapshot.data[0]['weather'],
                                      kinematics: snapshot.data[0]['kinematics'],
                                    ),
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: (w - 40) / 2,
                                    height: 200,
                                    child: CustomMap(
                                      lat: snapshot.data[0]['crash'].lat,
                                      long: snapshot.data[0]['crash'].long,
                                      zoom: 14.0,
                                      latLongLis: [LatLng(snapshot.data[0]['crash'].lat, snapshot.data[0]['crash'].long)],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                            child: Text(
                                              snapshot.data[0]['crash'].address,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              snapshot.data[0]['crash'].time,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(8, 15, 0, 10),
                                            child: Text(
                                              'PENDING',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 100,
        )
      ],
    );
  }
}


class LineChartWidget extends StatelessWidget {
  LineChartWidget({this.kineData,this.w,this.title,this.x='Time',this.y});
  var kineData;
  var w;
  var title;
  var x;
  var y;
  @override
  Widget build(BuildContext context) {

    final List<Color> color = <Color>[];
    color.add(Colors.blue[50]);
    color.add(Colors.blue[200]);
    color.add(Colors.blue);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
    LinearGradient(colors: color, stops: stops);

    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        ReportDisplayCard(
          width: (w - 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                height: 200,
                child: kineData==null?Container():SfCartesianChart(
                    primaryXAxis:CategoryAxis(title: AxisTitle(text: x)),
                    primaryYAxis:CategoryAxis(title: AxisTitle(text: y)),
                    series: <ChartSeries>[
                      // Renders line chart
                      AreaSeries<Map, String>(
                        enableTooltip: true,
                        dataSource: kineData,
                        gradient: gradientColors,
                        xValueMapper: (Map dataElement, _) =>
                            dataElement['x'],
                        yValueMapper: (Map dataElement, _) =>
                            dataElement['y'],
                      )
                    ]
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}