import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripplaner/config/env.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio = Dio();

  Future<Directions> getDirections(
      {required LatLng origin, required LatLng destination}) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': Env.myApiKey,
    });

    return Directions.fromMap(response.data);
  }
}

class Directions {
  final List<PointLatLng> polylinePoints;

  const Directions({
    required this.polylinePoints,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if (!map['routes'].isEmpty) {
      final data = Map<String, dynamic>.from(map['routes'][0]);
      return Directions(
          polylinePoints: PolylinePoints()
              .decodePolyline(data['overview_polyline']['points']));
    } else {
      return Directions(polylinePoints: List<PointLatLng>.empty());
    }
  }
}
