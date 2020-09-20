import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:latlong/latlong.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chart.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chartview.dart';
import 'package:whatthehack/insurance/screens/map_screen/CustomMap.dart';
import 'package:whatthehack/insurance/screens/model_threed/Model_Threed.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/speedometer.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/card.dart';

import '../../../values/colors.dart';
import 'speedometer.dart';

class ReportBody extends StatefulWidget {
  final CrashDetail crash;
  final Weather weather;
  final Damage damage;
  final Kinematics kinematics;
  ReportBody({
    this.crash,
    this.damage,
    this.kinematics,
    this.weather,
  });
  @override
  _ReportBodyState createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {
  double w;

  Icon getWeatherIcon() {
    return Icon(
      MaterialCommunityIcons.weather_pouring,
      size: 70,
    );
  }

  getAltAna(altData){
    print(altData);
    var len = altData.length;
    var mid = altData[(2*len/3).round()]['y'].toDouble();
    var end = altData[(len-1)]['y'].toDouble();
    print(end-mid);
    if(end-mid >0.9)
      return '(Looks like you were going uphill)';
    else if(end-mid<-0.9)
      return '(Looks like you were going downhill)';
  }

  Kinematics kineData;
  var altData;

  getKineDat() async{
    kineData = await getKinematicData();
    setState(() {});
  }

  getAltDat() async{
    altData = await fetchAltitudes();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getKineDat();
    getAltDat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              ReportDisplayCard(
                  width: (w - 40) / 2 - 5,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.crash.address,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 170,
                        child: CustomMap(
                          lat: widget.crash.lat,
                          long: widget.crash.long,
                          zoom: 14.0,
                          latLongLis: [
                            LatLng(widget.crash.lat,widget.crash.long)
                          ]
                        ),
                      )
                    ],
                  )),
              SizedBox(
                width: 10,
              ),
              ReportDisplayCard(
                width: (w - 40) / 2 - 5,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(
                        'Speed of Vehicle',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 200,
                      child: Speedometer(
                        begin: 0,
                        end: 150,
                        value: widget.kinematics.impact_speed,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              ReportDisplayCard(
                width: (w - 40) / 2 - 5,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: widget.weather.day_time
                          ? Icon(
                              MaterialCommunityIcons.white_balance_sunny,
                              size: 70,
                              color: Colors.yellow[800],
                            )
                          : Icon(
                              Ionicons.ios_moon,
                              size: 70,
                              color: Colors.yellow[800],
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.crash.time.split(',')[0],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ReportDisplayCard(
                width: (w - 40) / 2 - 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 150,
                  child: SfRadialGauge(
                    enableLoadingAnimation: true,
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        pointers: <GaugePointer>[
                          RangePointer(value: widget.damage.severity, color: colorPalette[10]),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              axisValue: 50,
                              positionFactor: 0.75,
                              widget: Column(
                                children: [
                                  Text(
                                    widget.damage.severity.toString(),
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                                  ),
                                  Text(
                                    'Severity',
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
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
                        'Parts damaged',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 200,
                      color: Color.fromARGB(255, 125, 122, 128),
                      // color: colorPalette[0],
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModelThreed(),
                              ));
                        },
                        child: Center(child: Image.asset('assets/mooodel.jpg',fit: BoxFit.cover,)),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.damage.analysis,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ))
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              ReportDisplayCard(
                width: w - 40,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                widget.weather.text,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              height: 100,
                              child: getWeatherIcon(),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: widget.weather.wind_direction + '\n', style: TextStyle(fontSize: 20)),
                                TextSpan(text: 'Wind Direction\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: widget.weather.wind_speed, style: TextStyle(fontSize: 20)),
                                TextSpan(text: 'kmph\n'),
                                TextSpan(text: 'Wind Speed\n', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text(
                          widget.weather.analysis,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ))
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              ReportDisplayCard(
                  width: (w - 40) / 2 - 5,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text(
                          widget.damage.num_impacts.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Text(
                          'Number of Impacts',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                width: 10,
              ),
              ReportDisplayCard(
                  width: (w - 40) / 2 - 5,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text(
                          'Pending',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Text(
                          'Claim Status',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              ReportDisplayCard(
                  width: (w - 40),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text(
                          '\$2650.00',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Text(
                          'Estimated cost for Repairs',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          altData==null?Container():LineChartWidget(kineData: altData,w:w,x:'Time',y:'Altitude',title:'Altitude vs Time ${getAltAna(altData)}'),
          SizedBox(
            height: 10,
          ),
          kineData==null?Container():LineChartWidget(kineData: kineData.speed_curve,w:w,x:'Time',y:'Speed',title:'Force vs Time'),
          SizedBox(
            height: 30,
          ),
          kineData==null?Container():LineChartWidget(kineData: kineData.speed_curve,w:w,x:'Time',y:'Speed',title:'GPS Speed'),
          SizedBox(
            height: 30,
          ),
          kineData==null?Container():AccelLineChartWidget(kineData: kineData,w:w,x:'Time',y:'Acceleration',title:'Acceleration vs Time'),


        ],
      ),
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
                      LineSeries<Map, double>(
                        dataSource: kineData,
                        xValueMapper: (Map dataElement, _) =>
                            dataElement['x'].toDouble(),
                        yValueMapper: (Map dataElement, _) =>
                            dataElement['y'].toDouble(),
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


class AccelLineChartWidget extends StatelessWidget {
  AccelLineChartWidget({this.kineData,this.w,this.title,this.x='Time',this.y});
  Kinematics kineData;
  var w;
  var title;
  var x;
  var y;
  @override
  Widget build(BuildContext context) {
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
                      LineSeries<Map, double>(
                        enableTooltip: true,
                        color: Colors.red,
                        dataSource: kineData.accel_lat,
                        dashArray: <double>[5,5],
                        xValueMapper: (Map dataElement, _) =>
                            dataElement['x'].toDouble(),
                        yValueMapper: (Map dataElement, _) =>
                            dataElement['y'].toDouble(),
                      ),
                      LineSeries<Map, double>(
                        enableTooltip: true,
                        dataSource: kineData.accel_lon,
                        color: Colors.blue,
                        dashArray: <double>[5,5],
                        xValueMapper: (Map dataElement, _) =>
                            dataElement['x'].toDouble(),
                        yValueMapper: (Map dataElement, _) =>
                            dataElement['y'].toDouble(),
                      ),
                      LineSeries<Map, double>(
                        enableTooltip: true,
                        color: Colors.green,
                        dataSource: kineData.accel_vert,
                        dashArray: <double>[5,5],
                        xValueMapper: (Map dataElement, _) =>
                            dataElement['x'].toDouble(),
                        yValueMapper: (Map dataElement, _) =>
                            dataElement['y'].toDouble(),
                      ),
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

