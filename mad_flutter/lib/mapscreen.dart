import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationEntry {
  final String name;
  final double latitude;
  final double longitude;

  LocationEntry({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class MapScreen extends StatelessWidget {
  final LocationEntry entry;

  MapScreen({required this.entry});

  @override
  Widget build(BuildContext context) {
    final marker = Marker(
      point: LatLng(entry.latitude, entry.longitude),
      child: Icon(Icons.location_on, color: Colors.red, size: 40),
    );

    return Scaffold(
      appBar: AppBar(title: Text(entry.name)),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(entry.latitude, entry.longitude),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: [marker]),
        ],
      ),
    );
  }
}
