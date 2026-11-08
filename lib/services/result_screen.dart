import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map result;
  final File image;

  ResultScreen(this.result, this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hasil AI")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 📸 ORIGINAL
            Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(image),
              ),
            ),

            /// 🔥 OVERLAY AI
            Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  result["image_url"],
                  errorBuilder: (_, __, ___) => Text("Overlay gagal dimuat"),
                ),
              ),
            ),

            SizedBox(height: 10),

            /// 📊 INFO
            Card(
              margin: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Model: ${result["model"]}"),
                    Text("Confidence: ${result["confidence"]}"),
                    Text("Kondisi: ${result["severity"]}"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
