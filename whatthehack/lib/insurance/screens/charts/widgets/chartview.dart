import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:whatthehack/insurance/data/chartsList.dart';
import 'package:whatthehack/insurance/data/dictionary.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  final Chart chart;
  ChartView({this.chart});

  @override
  Widget build(BuildContext context) {
    switch (chart.type) {
      case 'Hardcoded':
        return hardcodedCharts[chart.args['index']]['view'];
        break;
      case 'Line':
        return SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                enableSelectionZooming: true,
                selectionRectBorderColor: Colors.red,
                selectionRectBorderWidth: 1,
                selectionRectColor: Colors.grey),
            primaryXAxis:
                CategoryAxis(title: AxisTitle(text: chart.args['xlabel'])),
            primaryYAxis:
                CategoryAxis(title: AxisTitle(text: chart.args['ylabel'])),
            title: ChartTitle(
              text: chart.args['title'],
              backgroundColor: Colors.lightGreen,
              borderColor: Colors.blue,
              borderWidth: 2,
              // Aligns the chart title to left
              alignment: ChartAlignment.near,
            ),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<Map, double>(
                dataSource: data,
                xValueMapper: (Map dataElement, _) =>
                    dataElement[chart.args['x']].toDouble(),
                yValueMapper: (Map dataElement, _) =>
                    dataElement[chart.args['y']].toDouble(),
              )
            ]);
        break;
      case 'Scatter':
        return SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                enableSelectionZooming: true,
                selectionRectBorderColor: Colors.red,
                selectionRectBorderWidth: 1,
                selectionRectColor: Colors.grey),
            primaryXAxis:
                CategoryAxis(title: AxisTitle(text: chart.args['xlabel'])),
            primaryYAxis:
                CategoryAxis(title: AxisTitle(text: chart.args['ylabel'])),
            title: ChartTitle(
              text: chart.args['title'],
              backgroundColor: Colors.lightGreen,
              borderColor: Colors.blue,
              borderWidth: 2,
              // Aligns the chart title to left
              alignment: ChartAlignment.near,
            ),
            series: <ChartSeries>[
              // Renders line chart
              ScatterSeries<Map, double>(
                dataSource: data,
                xValueMapper: (Map dataElement, _) =>
                    dataElement[chart.args['x']].toDouble(),
                yValueMapper: (Map dataElement, _) =>
                    dataElement[chart.args['y']].toDouble(),
              )
            ]);
        break;
      case 'Pie':
        Map<String, int> index = {};
        List<Map> pieData = [];

        for (int i = 0; i < chart.args['keys'].length; i++) {
          index[chart.args['keys'][i]] = i;
          pieData.add({
            'key': chart.args['keys'][i],
            'count': 0,
            'color': (i % 2 == 0 ? Colors.blue : Colors.red)
          });
        }

        for (int i = 0; i < data.length; i++) {
          if (index[data[i][chart.args['column']]] == null) continue;
          pieData[index[data[i][chart.args['column']]]]['count'] =
              pieData[index[data[i][chart.args['column']]]]['count'] + 1;
        }

        print(pieData);

        return SfCircularChart(
            // Enables the legend
            legend: Legend(isVisible: true),
            series: <CircularSeries>[
              // Initialize line series
              PieSeries<Map, String>(
                dataSource: pieData,
                pointColorMapper: (Map pieData, _) => pieData['color'],
                xValueMapper: (Map pieData, _) => pieData['key'],
                yValueMapper: (Map pieData, _) => pieData['count'],
                name: 'Pie',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )
            ]);
        break;
      case 'Donut':
        Map<String, int> index = {};
        List<Map> pieData = [];

        for (int i = 0; i < chart.args['keys'].length; i++) {
          index[chart.args['keys'][i]] = i;
          pieData.add({
            'key': chart.args['keys'][i],
            'count': 0,
            'color': (i % 2 == 0 ? Colors.blue : Colors.red)
          });
        }

        for (int i = 0; i < data.length; i++) {
          if (index[data[i][chart.args['column']]] == null) continue;
          pieData[index[data[i][chart.args['column']]]]['count'] =
              pieData[index[data[i][chart.args['column']]]]['count'] + 1;
        }

        print(pieData);

        return SfCircularChart(
            // Enables the legend
            legend: Legend(isVisible: true),
            series: <CircularSeries>[
              // Initialize line series
              DoughnutSeries<Map, String>(
                dataSource: pieData,
                pointColorMapper: (Map pieData, _) => pieData['color'],
                xValueMapper: (Map pieData, _) => pieData['key'],
                yValueMapper: (Map pieData, _) => pieData['count'],
                name: 'Pie',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )
            ]);
        break;
    }
  }
}
