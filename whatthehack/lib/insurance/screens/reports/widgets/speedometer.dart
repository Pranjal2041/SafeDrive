import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Speedometer extends StatelessWidget {
  final double value, begin, end;
  Speedometer({this.value, this.begin, this.end});
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 3500,
      axes: <RadialAxis>[
        RadialAxis(minimum: this.begin, maximum: this.end, interval: 40, startAngle: 135, endAngle: 45, showTicks: true, pointers: [
          RangePointer(
            value: this.value,
            enableAnimation: true,
            animationType: AnimationType.elasticOut,
            gradient: SweepGradient(colors: [colorPalette[4], colorPalette[12]], stops: <double>[0.25, 0.75]),
          ),
          NeedlePointer(
            value: this.value,
            enableAnimation: true,
            animationType: AnimationType.elasticOut,
            needleLength: 0.7,
            needleStartWidth: 1,
            needleEndWidth: 4,
            gradient: LinearGradient(colors: [colorPalette[12], colorPalette[4]]),
            tailStyle: TailStyle(width: 4, gradient: LinearGradient(colors: [colorPalette[12], colorPalette[4]]), length: 0.15),
            knobStyle: KnobStyle(knobRadius: 0.05, borderColor: colorPalette[12], borderWidth: 0.02, color: Colors.white),
          )
        ], annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              angle: 90,
              positionFactor: 0.8,
              widget: Text(
                this.value.toString() + ' kmph',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ))
        ])
      ],
    );
  }
}
