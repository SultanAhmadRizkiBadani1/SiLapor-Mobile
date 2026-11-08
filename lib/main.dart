import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'screens/result_screen.dart';

/// 🔥 GLOBAL NAV KEY
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 INIT THEME (BIAR TERSIMPAN)
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// 🔥 ROUTE CONSTANT
  static const String splash = '/';
  static const String main = '/main';
  static const String result = '/result';

  @override
  Widget build(BuildContext context) {
    /// 🔥 AMBIL THEME DARI PROVIDER
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'SiLapor AI',

      /// 🔥 LIGHT THEME (LEBIH MODERN)
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),

      /// 🌙 DARK THEME (LEBIH BAGUS)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),

      /// 🔥 INI YANG BIKIN SETTINGS WORK
      themeMode: themeProvider.themeMode,

      /// 🔥 ROUTING
      initialRoute: splash,
      onGenerateRoute: _generateRoute,
    );
  }

  /// 🔥 ROUTE SYSTEM (LEBIH RAPI)
  static Route _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(SplashScreen());

      case main:
        return _fadeRoute(MainScreen());

      case result:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _fadeRoute(ResultScreen(args));

      default:
        return _fadeRoute(_errorPage(settings.name));
    }
  }

  /// 🔥 ERROR PAGE
  static Widget _errorPage(String? route) {
    return Scaffold(
      body: Center(
        child: Text(
          "Route tidak ditemukan:\n$route",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  /// 🔥 ANIMASI HALUS
  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
