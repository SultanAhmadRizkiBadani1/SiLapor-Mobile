import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  /// 🔥 TAMBAH SETTINGS DI SINI
  final List<Widget> pages = [
    HomeScreen(),
    MapScreen(),
    StatsScreen(),
    SettingsScreen(), // ✅ TAMBAHAN
  ];

  void onTabTapped(int i) {
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔥 ANIMASI HALUS
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_index],
      ),

      /// 🔥 BOTTOM NAVBAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: onTabTapped,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF1565C0),
            unselectedItemColor: Colors.grey,
            items: [
              _navItem(Icons.home, "Home", 0),
              _navItem(Icons.map, "Map", 1),
              _navItem(Icons.bar_chart, "Statistik", 2),
              _navItem(Icons.settings, "Settings", 3), // ✅ TAMBAHAN
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 WIDGET NAV ITEM (BIAR RAPI)
  BottomNavigationBarItem _navItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(_index == index ? 8 : 0),
        decoration: BoxDecoration(
          color: _index == index
              ? const Color(0xFF1565C0).withOpacity(0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
