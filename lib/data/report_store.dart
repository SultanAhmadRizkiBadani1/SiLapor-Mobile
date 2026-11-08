import '../models/report.dart';

class ReportStore {
  static List<Report> reports = [];

  static int get total => reports.length;

  static int get unetCount => reports.where((r) => r.model == "UNET").length;

  static int get fcnCount => reports.where((r) => r.model == "FCN").length;

  static int get ringan => reports.where((r) => r.severity == "Ringan").length;

  static int get sedang => reports.where((r) => r.severity == "Sedang").length;

  static int get parah => reports.where((r) => r.severity == "Parah").length;

  /// 🧠 MODEL TERBAIK
  static String get bestModel {
    if (unetCount > fcnCount) return "UNET";
    if (fcnCount > unetCount) return "FCN";
    return "Seimbang";
  }
}
