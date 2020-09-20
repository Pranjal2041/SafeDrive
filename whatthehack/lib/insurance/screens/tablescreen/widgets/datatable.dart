import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/values/colors.dart';

import '../../../data/stateNames.dart';
import '../../../data/statedictionary.dart';

class StateDataTable extends StatefulWidget {
  @override
  StateDataTableState createState() => StateDataTableState();
}

class StateDataTableState extends State<StateDataTable> {
  List<String> columns = ['Deaths', 'Severe Accidents', 'Accident'];

  String sortedBy = 'State';
  bool sortedAscending = false;

  Future _future;

  @override
  void initState() {
    super.initState();
    _future = fetchStateStats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            stateDictionary = snapshot.data;
            List<String> sortedStatesList = statesList.sublist(0);

            if (sortedBy == 'State')
              sortedStatesList.sort((state1, state2) => state1.compareTo(state2));
            else
              sortedStatesList.sort((state1, state2) => stateDictionary[state1][sortedBy].compareTo(stateDictionary[state2][sortedBy]));

            if (sortedAscending) sortedStatesList = List.from(sortedStatesList.reversed);

            List statesIndexList = [];
            for (int i = 0; i < sortedStatesList.length; i++) statesIndexList.add(i);
            return Material(
                color: colorPalette[11],
                child: DataTable(
                  columns: const <DataColumn>[] +
                      (['State'] + columns)
                          .map(
                            (column) => DataColumn(
                                label: GestureDetector(
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(children: <Widget>[
                                    Text(
                                      column.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: sortedBy == column ? FontWeight.w700:FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.white,
                                        letterSpacing: 1.6,
                                      ),
                                    ),
                                    sortedBy == column ? (sortedAscending ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_drop_up)) : Container(width: 13),
                                  ])),
                              onTap: () {
                                if (sortedBy == column)
                                  sortedAscending = !sortedAscending;
                                else
                                  sortedAscending = false;
                                sortedBy = column;
                                setState(() {});
                              },
                            )),
                          )
                          .toList(),
                  rows: statesIndexList
                      .map(
                        (state) => DataRow(
                          color: MaterialStateProperty.resolveWith((states) => colorPalette[state % 2]),
                          cells: <DataCell>[
                                DataCell(Text(statesFullform[sortedStatesList[state]])),
                              ] +
                              columns.map((column) => DataCell(Text(stateDictionary[sortedStatesList[state]][column].toString()))).toList(),
                        ),
                      )
                      .toList(),
                ));
          }
          return Container(
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
