import 'dart:io';
import 'package:latlong2/latlong.dart';

class Report {
  final File image;
  final String result;
  final LatLng location;
  final String model;
  final String severity;
  final double confidence;

  Report({
    required this.image,
    required this.result,
    required this.location,
    required this.model,
    required this.severity,
    required this.confidence,
  });
}
