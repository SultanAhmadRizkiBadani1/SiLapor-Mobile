import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  /// =====================================
  /// 🔥 LIST SERVER YANG AKAN DICEK
  /// =====================================
  static List<String> serverList = [
    // GANTI sesuai IP laptop kamu
    "http://192.168.1.9:8000",
    "http://192.168.1.30:8000",
    "http://192.168.1.23:8000",
    "http://172.20.10.3:8000",
    "http://172.20.10.5:8000",

    // Fallback umum hotspot/router
    "http://192.168.1.1:8000",
    "http://192.168.0.1:8000",
    "http://192.168.1.9:8000",
    "http://192.168.104.15:8000",

    // Android Emulator
    "http://10.0.2.2:8000",
  ];

  /// SERVER AKTIF
  static String baseUrl = serverList.first;

  /// =====================================
  /// 🔥 AUTO DETECT SERVER
  /// =====================================
  static Future<void> autoDetectServer() async {
    print("🔍 Mencari server aktif...");

    for (String server in serverList) {
      try {
        final response = await http
            .get(Uri.parse("$server/docs"))
            .timeout(const Duration(seconds: 2));

        if (response.statusCode == 200) {
          baseUrl = server;

          print("✅ SERVER DITEMUKAN : $baseUrl");

          return;
        }
      } catch (e) {
        print("❌ GAGAL : $server");
      }
    }

    throw Exception("Server tidak ditemukan");
  }

  /// =====================================
  /// 🔥 CHECK SERVER
  /// =====================================
  static Future<bool> checkServer() async {
    try {
      await autoDetectServer();

      final response = await http
          .get(Uri.parse("$baseUrl/docs"))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print("SERVER ERROR: $e");

      return false;
    }
  }

  /// =====================================
  /// 🔥 UPLOAD IMAGE
  /// =====================================
  static Future<Map<String, dynamic>> uploadImage(
    File image,
  ) async {
    try {
      /// AUTO DETECT
      await autoDetectServer();

      print("📡 SERVER : $baseUrl");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/predict"),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
        ),
      );

      var response = await request.send().timeout(
            const Duration(seconds: 30),
          );

      var result = await http.Response.fromStream(response);

      print("STATUS : ${result.statusCode}");
      print("BODY   : ${result.body}");

      if (result.statusCode == 200) {
        return jsonDecode(result.body);
      } else {
        throw Exception(
          "Server Error (${result.statusCode})",
        );
      }
    } on SocketException {
      throw Exception(
        "Tidak ada koneksi ke server",
      );
    } on TimeoutException {
      throw Exception(
        "Request timeout",
      );
    } catch (e) {
      throw Exception(
        "ERROR: $e",
      );
    }
  }

  /// =====================================
  /// 🔥 GET STATS
  /// =====================================
  static Future<Map<String, dynamic>> getStats() async {
    try {
      /// AUTO DETECT
      await autoDetectServer();

      print("📊 SERVER : $baseUrl");

      final response = await http.get(
        Uri.parse("$baseUrl/stats"),
      );

      print("📊 STATS : ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Gagal ambil statistik (${response.statusCode})",
        );
      }
    } on SocketException {
      throw Exception(
        "Tidak ada koneksi internet",
      );
    } on TimeoutException {
      throw Exception(
        "Request timeout",
      );
    } catch (e) {
      throw Exception(
        "ERROR: $e",
      );
    }
  }
}
