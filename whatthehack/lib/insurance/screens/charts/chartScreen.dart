import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/chartsList.dart';
import 'package:whatthehack/insurance/screens/charts/filters.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chartview.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/filtertile.dart';
import 'package:whatthehack/insurance/transitions/animationless.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  int chartId;
  ChartScreen({this.chartId});
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    removeFilters();
    super.initState();
  }

  Widget previousChart(BuildContext context) {
    if (widget.chartId < 1) return Container(height: 10, width: 50);
    return Row(children: <Widget>[
      Container(
          width: 50,
          height: 50,
          child: IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                Navigator.pushReplacement(context, AnimationLess(builder: (context) => ChartScreen(chartId: widget.chartId - 1)));
              })),
      GestureDetector(
          child: Container(width: 100, height: 50, alignment: Alignment.centerLeft, child: Text(chartsList[widget.chartId - 1].title)),
          onTap: () {
            Navigator.pushReplacement(context, AnimationLess(builder: (context) => ChartScreen(chartId: widget.chartId - 1)));
          })
    ]);
  }

  Widget nextChart(BuildContext context) {
    if (widget.chartId >= chartsList.length - 1) return Container(height: 10, width: 50);
    return Row(children: <Widget>[
      GestureDetector(
          child: Container(width: 100, height: 50, alignment: Alignment.centerRight, child: Text(chartsList[widget.chartId + 1].title)),
          onTap: () {
            Navigator.pushReplacement(context, AnimationLess(builder: (context) => ChartScreen(chartId: widget.chartId + 1)));
          }),
      Container(
          width: 50,
          height: 50,
          child: IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                Navigator.pushReplacement(context, AnimationLess(builder: (context) => ChartScreen(chartId: widget.chartId + 1)));
              })),
    ]);
  }

  Widget carouselDot(Color color, int id) {
    return GestureDetector(
        child: Container(
            height: 50,
            width: 10,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
                child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ))),
        onTap: () {
          if (id != null) Navigator.pushReplacement(context, AnimationLess(builder: (context) => ChartScreen(chartId: id)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chartsList[widget.chartId].title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
                Container(
                    height: 400,
                    child: ChartView(
                      chart: chartsList[widget.chartId],
                    )),
              ] +
              Filters(parent: this, filters: chartsList[widget.chartId].filters),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[previousChart(context), nextChart(context)],
      ),
    );
  }
}
