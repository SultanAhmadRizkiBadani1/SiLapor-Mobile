import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../screens/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notif = true;
  bool gps = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notif = prefs.getBool("notif") ?? true;
      gps = prefs.getBool("gps") ?? true;
    });
  }

  void saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  /// 🔥 HEADER (SAMA KAYAK HOME)
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.settings, color: const Color.fromRGBO(33, 150, 243, 1)),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pengaturan",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Konfigurasi Aplikasi",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND GRADIENT
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
                        /// 🎨 THEME
                        _sectionTitle("Tampilan"),
                        _modernCard(
                          child: Column(
                            children: [
                              _themeTile(
                                context,
                                icon: Icons.settings_suggest,
                                title: "System Default",
                                value: ThemeMode.system,
                                group: themeProvider.themeMode,
                                onTap: () =>
                                    themeProvider.setTheme(ThemeMode.system),
                              ),
                              _themeTile(
                                context,
                                icon: Icons.light_mode,
                                title: "Light Mode",
                                value: ThemeMode.light,
                                group: themeProvider.themeMode,
                                onTap: () =>
                                    themeProvider.setTheme(ThemeMode.light),
                              ),
                              _themeTile(
                                context,
                                icon: Icons.dark_mode,
                                title: "Dark Mode",
                                value: ThemeMode.dark,
                                group: themeProvider.themeMode,
                                onTap: () =>
                                    themeProvider.setTheme(ThemeMode.dark),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        /// ⚙️ FITUR
                        _sectionTitle("Fitur"),
                        _modernCard(
                          child: Column(
                            children: [
                              _switchTile(
                                icon: Icons.notifications_active,
                                title: "Notifikasi",
                                subtitle: "Aktifkan notifikasi laporan",
                                value: notif,
                                onChanged: (v) {
                                  setState(() => notif = v);
                                  saveSetting("notif", v);
                                },
                              ),
                              _switchTile(
                                icon: Icons.gps_fixed,
                                title: "GPS Tracking",
                                subtitle: "Gunakan lokasi saat laporan",
                                value: gps,
                                onChanged: (v) {
                                  setState(() => gps = v);
                                  saveSetting("gps", v);
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        /// ℹ️ ABOUT
                        _sectionTitle("Informasi"),
                        _modernCard(
                          child: ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text("Tentang Aplikasi"),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AboutScreen(),
                                ),
                              );
                            },
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

  /// 🔥 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  /// 🔥 CARD MODERN
  Widget _modernCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: child,
    );
  }

  /// 🔥 THEME TILE
  Widget _themeTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required ThemeMode value,
    required ThemeMode group,
    required VoidCallback onTap,
  }) {
    final isSelected = value == group;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
          : Icon(Icons.radio_button_off),
      onTap: onTap,
    );
  }

  /// 🔥 SWITCH TILE
  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      activeColor: Colors.blue,
      onChanged: onChanged,
    );
  }
}
