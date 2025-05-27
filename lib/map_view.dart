import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class MapviewScreen extends StatefulWidget {
  final VoidCallback onExit;
  final VoidCallback? onMapReady; // <-- Ekledik

  const MapviewScreen({
    Key? key,
    required this.onExit,
    this.onMapReady,
  }) : super(key: key);

  @override
  State<MapviewScreen> createState() => _MapviewScreenState();
}

class _MapviewScreenState extends State<MapviewScreen> {
  final mapController = MapController();
  List<LatLng> routePoints = [];
  Widget? _cachedMap; // nullable hale getirdik

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    try {
      final response = await http.get(Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/28.9784,41.0082;32.8541,39.9208?overview=full&geometries=geojson',
      ));

      final data = jsonDecode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      final points = coords.map((c) => LatLng(c[1], c[0])).toList();

      routePoints = points;
      _cachedMap = _buildMap();

      // onMapReady callback'ini çağır
      widget.onMapReady?.call();

      setState(() {});
    } catch (e) {
      debugPrint('Harita rotası alınamadı: $e');
    }
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cachedMap ?? const SizedBox();
  }
}
