import 'package:flutter/material.dart';

fadeTo(BuildContext context, Widget target) {
  Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
    return target;
  }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }));
}
