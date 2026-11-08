import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// 🔥 HEADER
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.info, color: Colors.blue),
          ),
          SizedBox(width: 15),

          /// 🔥 FIX OVERFLOW
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tentang Aplikasi",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Informasi SiLapor AI",
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

  /// 🔥 CARD UTAMA
  Widget buildMainCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black12,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.location_city, size: 80, color: Colors.blue),
          SizedBox(height: 15),
          Text(
            "SiLapor AI",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Aplikasi deteksi kerusakan jalan berbasis Artificial Intelligence menggunakan model UNET dan FCN untuk analisis citra jalan secara otomatis.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 🔥 INFO CARD
  Widget buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          buildItem(Icons.person, "Developer", "Sultan Ahmad Rizki Badani"),
          Divider(),
          buildItem(Icons.school, "Universitas",
              "Universitas Bhayangkara Jakarta Raya"),
          Divider(),
          buildItem(Icons.code, "Versi", "1.0.0"),
        ],
      ),
    );
  }

  /// 🔥 ITEM (SUDAH FIX OVERFLOW)
  Widget buildItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),

        /// 🔥 INI YANG FIX ERROR KAMU
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  /// 🔥 FOOTER
  Widget buildFooter() {
    return Center(
      child: Text(
        "© 2026 SiLapor AI",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌈 BACKGROUND
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
                        buildMainCard(),
                        SizedBox(height: 20),
                        buildInfoCard(),
                        SizedBox(height: 20),
                        buildFooter(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
