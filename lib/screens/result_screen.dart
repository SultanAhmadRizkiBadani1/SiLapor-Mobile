import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ResultScreen extends StatelessWidget {
  final Map? result;

  const ResultScreen(this.result, {super.key});

  /// 🎨 WARNA SEVERITY
  Color getSeverityColor(String severity) {
    if (severity.contains("Parah")) return Colors.red;
    if (severity.contains("Sedang")) return Colors.orange;
    if (severity.contains("Ringan")) return Colors.yellow;
    if (severity.contains("Retak")) return Colors.blue;
    return Colors.green;
  }

  double toDouble(dynamic val) {
    if (val == null) return 0.0;
    return double.tryParse(val.toString()) ?? 0.0;
  }

  double normalizeScore(dynamic score) {
    double s = toDouble(score);
    return (s / 2000).clamp(0.0, 1.0);
  }

  /// 🔥 HEADER STYLE HOME
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.analytics, color: Colors.blue),
          ),
          SizedBox(width: 15),

          /// 🔥 FIX OVERFLOW DISINI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasil AI",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Analisis Kerusakan Jalan",
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

  @override
  Widget build(BuildContext context) {
    if (result == null || result!["status"] != "success") {
      return Scaffold(
        body: Center(
          child: Text("Gagal memuat hasil AI"),
        ),
      );
    }

    String severity = result!["severity"] ?? "Tidak diketahui";
    String model = result!["model"] ?? "-";

    double confidence = toDouble(result!["confidence"]);
    double unetScore = toDouble(result!["unet_score"]);
    double fcnScore = toDouble(result!["fcn_score"]);

    String imageUrl = "";

    if (result!["image_url"] != null &&
        result!["image_url"].toString().isNotEmpty) {
      imageUrl = ApiService.baseUrl + result!["image_url"];
    }

    Color severityColor = getSeverityColor(severity);

    return Scaffold(
      body: Stack(
        children: [
          /// 🌈 BACKGROUND GRADIENT
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
                        /// 🖼️ IMAGE CARD
                        if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),

                        SizedBox(height: 20),

                        /// 📊 HASIL CARD
                        Container(
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
                              Text(
                                severity,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: severityColor,
                                ),
                              ),
                              SizedBox(height: 10),

                              /// 🔥 FIX OVERFLOW
                              Text(
                                "Model Terbaik: $model",
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: 5),
                              Text(
                                "Confidence: ${(confidence * 100).toStringAsFixed(2)}%",
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        /// 📊 PERBANDINGAN MODEL
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Perbandingan Model",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),

                              /// UNET
                              Text("UNET"),
                              SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: normalizeScore(unetScore),
                                minHeight: 10,
                              ),
                              SizedBox(height: 5),
                              Text("Score: ${unetScore.toStringAsFixed(0)}"),

                              SizedBox(height: 15),

                              /// FCN
                              Text("FCN"),
                              SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: normalizeScore(fcnScore),
                                minHeight: 10,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 5),
                              Text("Score: ${fcnScore.toStringAsFixed(0)}"),
                            ],
                          ),
                        ),

                        SizedBox(height: 25),

                        /// 🔁 BUTTON
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.refresh),
                          label: Text("Scan Lagi"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
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
