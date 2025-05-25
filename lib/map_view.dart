import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapviewScreen extends StatefulWidget {
  final VoidCallback onExit;
  const MapviewScreen({super.key, required this.onExit});

  @override
  State<MapviewScreen> createState() => _MapviewScreenState();
}

class _MapviewScreenState extends State<MapviewScreen> {
  final mapController = MapController();
  List<LatLng> routePoints = [];
  late final Widget _cachedMap; // Harita bir kez oluşturulur

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    final response = await http.get(Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/28.9784,41.0082;32.8541,39.9208?overview=full&geometries=geojson',
    ));
    final data = jsonDecode(response.body);
    final coords = data['routes'][0]['geometry']['coordinates'] as List;
    final points = coords.map((c) => LatLng(c[1], c[0])).toList();

    routePoints = points;

    // Sadece bir defa widget oluştur
    _cachedMap = _buildMap();
    setState(() {});
  }

  Widget _buildMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialCenter: LatLng(41.0082, 28.9784),
            initialZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    color: Colors.red,
                    strokeWidth: 4,
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton.icon(
            onPressed: widget.onExit,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Geri'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cachedMap ?? const Center(child: CircularProgressIndicator());
  }
}
