import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/chartsList.dart';
import 'package:whatthehack/insurance/data/dictionary.dart';
import 'package:whatthehack/insurance/screens/charts/filters.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chartview.dart';
import 'package:whatthehack/insurance/transitions/animationless.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<Widget> Filters({parent, filters}) {
  List<Widget> list = [];
  for (int i = 0; i < filters.length; i++) {
    list.add(DropDownFilterTile(parent: parent));
  }
  return list;
}

class DropDownFilterTile extends StatefulWidget {
  final parent;
  DropDownFilterTile({this.parent});
  @override
  DropDownFilterTileState createState() => DropDownFilterTileState();
}

class DropDownFilterTileState extends State<DropDownFilterTile> {
  String value = 'All';
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: DropdownButton<String>(
        value: value,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          if (newValue == 'All')
            removeFilters();
          else
            filterByType(newValue);
          setState(() {
            value = newValue;
          });
          widget.parent.setState(() {});
          print(data);
        },
        items: <String>['All', 'bad', 'good', 'ok']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      title: Text("Type:"),
    );
  }
}

class RangeFilterTile extends StatefulWidget {
  final parent;
  RangeFilterTile({this.parent});
  @override
  RangeFilterTileState createState() => RangeFilterTileState();
}

class RangeFilterTileState extends State<RangeFilterTile> {
  RangeValues _currentRangeValues = RangeValues(0.0, 20.0);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Container(
        width: 300,
        height: 50,
        child: RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 20,
          divisions: 20,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
            filterByCost(values.start.round(), values.end.round());
            widget.parent.setState(() {});
          },
        ),
      ),
      title: Text("Cost:"),
    );
  }
}
