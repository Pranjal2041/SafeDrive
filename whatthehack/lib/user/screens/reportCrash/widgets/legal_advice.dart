import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/reports/widgets/card.dart';

class LegalAdviceCard extends StatelessWidget {
  final double width;
  LegalAdviceCard({this.width});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchLegalAdvice(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ReportDisplayCard(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      'LEGAL ADVICE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(snapshot.data.length, (i) {
                      return Container(
                        color: snapshot.data[i].status == 'positive' ? Colors.green[100] : Colors.red[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                              child: Text(
                                snapshot.data[i].heading,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                              child: Text(
                                snapshot.data[i].advice,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
