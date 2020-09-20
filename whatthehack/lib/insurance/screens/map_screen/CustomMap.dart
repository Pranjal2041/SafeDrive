import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:whatthehack/insurance/screens/map_screen/widgets/marker.dart';

class CustomMap extends StatefulWidget {

  CustomMap({this.lat,this.long,this.zoom = 8.0,this.width = 80,this.latLongLis,this.markCurrent = false});

  var lat;
  var long;
  var zoom;
  var width;
  List<LatLng> latLongLis;
  bool markCurrent;

  @override
  _CustomMapState createState() => _CustomMapState(latLongLis: latLongLis);
}

class _CustomMapState extends State<CustomMap> {

  _CustomMapState({this.latLongLis});
  List<LatLng> latLongLis;

  @override
  Widget build(BuildContext context) {
    if(widget.markCurrent){
      setState(() {
        latLongLis.add(LatLng(widget.lat,widget.long));
      });
    }
    return FlutterMap(
      options: MapOptions(
        center: LatLng(widget.lat, widget.long),
        zoom: widget.zoom,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: latLongLis.map((e) => Marker(
            width: 80,
            height: 80,
            point: e,
            builder: (ctx) => (widget.lat==(e as LatLng).latitude && widget.long==(e as LatLng).longitude && widget.markCurrent)?MapMarkerBlue():MapMarker(),
          ),).toList(),
        ),
      ],
    );
  }
}
