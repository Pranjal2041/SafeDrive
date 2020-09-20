import 'package:flutter/material.dart';

class AnimationLess extends MaterialPageRoute {
  AnimationLess({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
