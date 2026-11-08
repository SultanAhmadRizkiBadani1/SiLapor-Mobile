import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    if (isLoading) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1024,
    );

    if (picked == null) return;

    File imageFile = File(picked.path);

    setState(() => isLoading = true);

    try {
      var result = await ApiService.uploadImage(imageFile);

      setState(() => isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(result)),
      );
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  /// 🔥 HEADER (LOGO SUPER RAPI)
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset("assets/logo putih.png"),
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SiLapor AI",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Deteksi Kerusakan Jalan",
                  style: TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildScanCard() {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.blue.withOpacity(0.3),
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.camera_alt, size: 60, color: Colors.white),
            SizedBox(height: 15),
            Text(
              "Scan Jalan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Gunakan kamera atau galeri untuk analisis AI",
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.camera),
              icon: Icon(Icons.camera_alt),
              label: Text("Kamera"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 45),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.gallery),
              icon: Icon(Icons.image),
              label: Text("Galeri"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 45),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Sistem menggunakan AI untuk mendeteksi kerusakan jalan berdasarkan citra digital.",
            ),
          )
        ],
      ),
    );
  }

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
                  Text("AI sedang menganalisis...",
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          )
        : SizedBox();
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
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                buildHeader(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ListView(
                      children: [
                        buildScanCard(),
                        SizedBox(height: 20),
                        buildLegend(),
                        SizedBox(height: 20),
                        buildInfoCard(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          buildLoading(),
        ],
      ),
    );
  }
}
