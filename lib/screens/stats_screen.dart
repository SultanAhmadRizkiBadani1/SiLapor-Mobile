import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, double> data = {};
  bool isLoading = true;

  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.blue,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final res = await ApiService.getStats();

      setState(() {
        data = {
          "Lubang Parah": (res["lubang_parah"] ?? 0).toDouble(),
          "Lubang Sedang": (res["lubang_sedang"] ?? 0).toDouble(),
          "Lubang Ringan": (res["lubang_ringan"] ?? 0).toDouble(),
          "Retak": (res["retak"] ?? 0).toDouble(),
          "Normal": (res["normal"] ?? 0).toDouble(),
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
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
            child: Icon(Icons.bar_chart, color: Colors.blue),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Statistik AI",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Analisis Data Kerusakan",
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

  /// 🔥 PIE CHART
  Widget buildChartCard() {
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
          Text(
            "Distribusi Kerusakan Jalan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                sections: buildSections(),
                sectionsSpace: 3,
                centerSpaceRadius: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 SUMMARY TOTAL
  Widget buildSummaryCard() {
    double total = data.values.fold(0, (a, b) => a + b);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("Total Laporan", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            total.toInt().toString(),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// 🔥 TOP CATEGORY
  Widget buildTopCategory() {
    if (data.isEmpty) return SizedBox();

    String topKey =
        data.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Kerusakan terbanyak: $topKey",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 BAR DETAIL
  Widget buildBarStats() {
    double total = data.values.fold(0, (a, b) => a + b);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Detail Statistik",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          ...List.generate(data.length, (i) {
            String key = data.keys.elementAt(i);
            double value = data.values.elementAt(i);
            double percent = total == 0 ? 0 : value / total;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$key (${value.toInt()})"),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: percent,
                    minHeight: 10,
                    color: colors[i],
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  /// 🔥 LEGEND
  Widget buildLegendCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Keterangan", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...List.generate(data.length, (i) {
            String key = data.keys.elementAt(i);
            return buildLegendItem(colors[i], key);
          })
        ],
      ),
    );
  }

  Widget buildLegendItem(Color color, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
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

  List<PieChartSectionData> buildSections() {
    double total = data.values.fold(0, (a, b) => a + b);

    return List.generate(data.length, (i) {
      final value = data.values.elementAt(i);
      final percent = total == 0 ? 0 : (value / total * 100);

      return PieChartSectionData(
        color: colors[i],
        value: value,
        title: "${percent.toStringAsFixed(1)}%",
        radius: 65,
        titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    });
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
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : data.isEmpty
                            ? Center(child: Text("Belum ada data"))
                            : ListView(
                                children: [
                                  buildSummaryCard(),
                                  SizedBox(height: 15),
                                  buildTopCategory(),
                                  SizedBox(height: 15),
                                  buildChartCard(),
                                  SizedBox(height: 20),
                                  buildBarStats(),
                                  SizedBox(height: 20),
                                  buildLegendCard(),
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
