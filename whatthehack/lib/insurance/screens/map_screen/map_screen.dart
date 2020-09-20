import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:whatthehack/insurance/screens/map_screen/widgets/marker.dart';
import 'package:whatthehack/insurance/widgets/bottom_navbar.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(37.0902, -95.7129),
          zoom: 4.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80,
                height: 80,
                point: LatLng(37.0902, -95.7129),
                builder: (ctx) => MapMarker(),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar('map'),
    );
  }
}


