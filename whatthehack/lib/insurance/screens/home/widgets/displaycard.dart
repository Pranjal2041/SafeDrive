import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/chartsList.dart';
import 'package:whatthehack/insurance/screens/charts/chartScreen.dart';
import 'package:whatthehack/insurance/screens/charts/widgets/chartthumbnail.dart';
import 'package:whatthehack/insurance/values/colors.dart';

class DisplayCard extends StatefulWidget {
  final int index;
  final double width;
  final bool small;
  DisplayCard({@required this.index, @required this.width, this.small = false});

  @override
  _DisplayCardState createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.small
                ? Wrap(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          chartsList[widget.index].title,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChartScreen(
                                    chartId: widget.index,
                                  ),
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'See details',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: colorPalette[11]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          chartsList[widget.index].title,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(
                                  chartId: widget.index,
                                ),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'See details',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: colorPalette[11]),
                          ),
                        ),
                      ),
                    ],
                  ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 200,
              child: ChartThumbnail(chart: chartsList[widget.index]),
            )
          ],
        ),
      ),
    );
  }
}
