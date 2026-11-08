import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../data/report_store.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;
  bool isLoading = true;

  /// 🔥 CONTROLLER (PENTING)
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  /// 🔥 GET LOCATION + AUTO MOVE MAP
  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        userLocation = newLocation;
        isLoading = false;
      });

      /// 🔥 INI YANG BIKIN MAP AUTO PINDAH
      mapController.move(newLocation, 16);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// 🔥 WARNA MARKER
  Color getMarkerColor(String severity) {
    if (severity.contains("Parah")) return Colors.red;
    if (severity.contains("Sedang")) return Colors.orange;
    if (severity.contains("Ringan")) return Colors.yellow;
    if (severity.contains("Retak")) return Colors.blue;
    return Colors.green;
  }

  /// 🔥 HEADER
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.map, color: Colors.blue),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Peta AI",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Sebaran Kerusakan Jalan",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 🔥 MAP CARD
  Widget buildMap() {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black12,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: FlutterMap(
          mapController: mapController, // 🔥 WAJIB
          options: MapOptions(
            initialCenter: LatLng(-6.2, 106.8), // default Jakarta
            initialZoom: 13,
          ),
          children: [
            /// TILE
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.silapor_app',
            ),

            /// MARKER USER
            if (userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation!,
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                ],
              ),

            /// MARKER LAPORAN
            MarkerLayer(
              markers: ReportStore.reports.map((r) {
                return Marker(
                  point: r.location,
                  width: 60,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => showDetail(context, r),
                    child: Icon(
                      Icons.location_pin,
                      color: getMarkerColor(r.severity),
                      size: 40,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 LEGEND
  Widget buildLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Keterangan Warna",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          buildLegendItem(Colors.red, "Lubang Parah"),
          buildLegendItem(Colors.orange, "Lubang Sedang"),
          buildLegendItem(Colors.yellow, "Lubang Ringan"),
          buildLegendItem(Colors.blue, "Retak"),
          buildLegendItem(Colors.green, "Normal"),
        ],
      ),
    );
  }

  Widget buildLegendItem(Color color, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  /// 🔥 LOADING
  Widget buildLoading() {
    return isLoading
        ? Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 10),
                  Text("Mengambil lokasi...",
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          )
        : SizedBox();
  }

  /// 🔥 DETAIL POPUP
  void showDetail(BuildContext context, dynamic r) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 15),
            Text("Detail Laporan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(r.image, height: 150),
            ),
            SizedBox(height: 10),
            Text("Model: ${r.model}"),
            Text("Kondisi: ${r.severity}"),
            Text("Confidence: ${r.confidence}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                buildHeader(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ListView(
                      children: [
                        buildMap(),
                        SizedBox(height: 20),
                        buildLegend(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          /// 🔥 BUTTON MY LOCATION
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Icon(Icons.my_location),
              onPressed: () {
                if (userLocation != null) {
                  mapController.move(userLocation!, 16);
                }
              },
            ),
          ),

          buildLoading(),
        ],
      ),
    );
  }
}
