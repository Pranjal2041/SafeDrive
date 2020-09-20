import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/values/colors.dart';

class FamilyTable extends StatefulWidget {
  @override
  FamilyTableState createState() => FamilyTableState();
}

class FamilyTableState extends State<FamilyTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List familyIndexList = [];
    for (int i = 0; i < familyData.length; i++) familyIndexList.add(i);
    return familyData.length > 0
        ? Material(
            color: colorPalette[11],
            child: DataTable(
              columns: const <DataColumn>[] +
                  ['Name', 'Type', 'Contact', 'Driver ID']
                      .map(
                        (column) => DataColumn(
                          label: Container(
                              color: Colors.transparent,
                              child: Row(children: <Widget>[
                                Text(
                                  column.toUpperCase(),
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ])),
                        ),
                      )
                      .toList(),
              rows: familyIndexList
                  .map(
                    (member) => DataRow(color: MaterialStateProperty.resolveWith((states) => colorPalette[member % 2]), cells: <DataCell>[
                      DataCell(Text(familyData[member]['name'])),
                      DataCell(Text(familyData[member]['type'])),
                      DataCell(Text(familyData[member]['contact'])),
                      DataCell(Text(familyData[member]['driverid'])),
                    ]),
                  )
                  .toList(),
            ))
        : Container(child: Text('No family members/friends added'));
  }
}

List<Map<String, dynamic>> familyData = [
  {'name': 'John Doe', 'type': 'family', 'contact': '4324324323', 'driverid': '1231312'},
  {'name': 'Thomas', 'type': 'family', 'contact': '4324324323', 'driverid': '1231312'},
  {'name': 'Emma', 'type': 'friend', 'contact': '123424323', 'driverid': '1231312'},
  {'name': 'Jennifer', 'type': 'friend', 'contact': '4324324323', 'driverid': '1231312'},
];
