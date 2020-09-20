import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapMarker extends StatefulWidget {
  MapMarker({this.msg});
  var msg;
  @override
  _MapMarkerState createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Tooltip(
        message: widget.msg==null?"":widget.msg,
        child: Icon(
          MaterialCommunityIcons.map_marker,
          color: Colors.red[800],
        ),
      ),
    );
  }
}

// class MapMarkerBlue extends StatefulWidget {
//   @override
//   _MapMarkerStateBlue createState() => _MapMarkerStateBlue();
// }

// class _MapMarkerStateBlue extends State<MapMarkerBlue> {
//   bool selected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Icon(
//         MaterialCommunityIcons.map_marker,
//         color: Colors.lightBlue,
//       ),
//     );
//   }
// }

class MapMarkerBlue extends StatefulWidget {
  MapMarkerBlue({this.msg});
  var msg;
  @override
  _MapMarkerBlueState createState() => _MapMarkerBlueState();
}

class _MapMarkerBlueState extends State<MapMarkerBlue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Tooltip(

        message: widget.msg==null?"":widget.msg,
        child: Icon(
          MaterialCommunityIcons.map_marker,
          color: Colors.lightBlue,
        ),
      ),
    );
  }
}



