import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whatthehack/insurance/data/new_claims_data.dart';
import 'package:whatthehack/insurance/data/profit_data.dart';
import 'package:whatthehack/insurance/data/users_data.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chart.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chart.dart';
import 'package:whatthehack/insurance/screens/model_threed/Model_Threed.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/card.dart';
import 'package:whatthehack/insurance/values/colors.dart';

import 'crashes_data.dart';

List<Chart> chartsList = [
  Chart('Vehicle Damage Statistics', 'Hardcoded', {'index': 0}, []),
  Chart('Users in last 7 months', 'Hardcoded', {'index': 1}, []),
  Chart('Profit in last 7 months', 'Hardcoded', {'index': 2}, []),
  Chart('New Claims in last 7 months', 'Hardcoded', {'index': 3}, []),
  Chart('Crashes in last 7 months', 'Hardcoded', {'index': 4}, []),
];

List<Map<String, Widget>> hardcodedCharts = [
  {
    'thumbnail': ReportDisplayCard(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            color: Color.fromARGB(255, 125, 122, 128),
// color: colorPalette[0],
            child: InkWell(
              onTap: () {},
              child: Center(
                child: Image.asset(
                  'assets/mooodel.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    'view': Padding(padding: EdgeInsets.all(10.0), child: ModelThreed()),
  },
  {
    'thumbnail': Container(
        child: SfCartesianChart(primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')), primaryYAxis: CategoryAxis(title: AxisTitle(text: 'Users')), series: <ChartSeries>[
      // Renders line chart
      AreaSeries<Map, String>(dataSource: new_users_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
    ])),
    'view': Container(
        child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePinching: true),
            primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')),
            primaryYAxis: CategoryAxis(title: AxisTitle(text: 'Users')),
            series: <ChartSeries>[
          // Renders line chart
          AreaSeries<Map, String>(dataSource: new_users_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
        ])),
  },
  {
    'thumbnail': Container(
        child: SfCartesianChart(primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')), primaryYAxis: CategoryAxis(title: AxisTitle(text: 'Profit')), series: <ChartSeries>[
      // Renders line chart
      AreaSeries<Map, String>(dataSource: profit_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
    ])),
    'view': Container(
        child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePinching: true),
            primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')),
            primaryYAxis: CategoryAxis(title: AxisTitle(text: 'Profit')),
            series: <ChartSeries>[
          // Renders line chart
          AreaSeries<Map, String>(dataSource: profit_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
        ])),
  },
  {
    'thumbnail': Container(
        child: SfCartesianChart(primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')), primaryYAxis: CategoryAxis(title: AxisTitle(text: 'New Claims')), series: <ChartSeries>[
      // Renders line chart
      AreaSeries<Map, String>(dataSource: new_claims_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
    ])),
    'view': Container(
        child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePinching: true),
            primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')),
            primaryYAxis: CategoryAxis(title: AxisTitle(text: 'New Claims')),
            series: <ChartSeries>[
          // Renders line chart
          AreaSeries<Map, String>(dataSource: new_claims_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
        ])),
  },
  {
    'thumbnail': Container(
        child: SfCartesianChart(primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')), primaryYAxis: CategoryAxis(title: AxisTitle(text: 'Crashes')), series: <ChartSeries>[
      // Renders line chart
      AreaSeries<Map, String>(dataSource: new_crashes_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
    ])),
    'view': Container(
        child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePinching: true),
            primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')),
            primaryYAxis: CategoryAxis(title: AxisTitle(text: 'Crashes')),
            series: <ChartSeries>[
          // Renders line chart
          AreaSeries<Map, String>(dataSource: new_crashes_data, xValueMapper: (Map dataElement, _) => dataElement['x'], yValueMapper: (Map dataElement, _) => dataElement['y'].toDouble(), gradient: gradientColors)
        ])),
  },
];

List<Map<String, List<Widget>>> filtersList = [];
LinearGradient gradientColors = LinearGradient(colors: colorPalette.sublist(0, 3), stops: [0.0, 0.5, 1.0]);
