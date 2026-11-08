import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/main_screen.dart';
import '../screens/result_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_screen.dart';

class AppRoutes {
  /// 🔥 ROUTE NAME (CONST BIAR AMAN)
  static const String splash = '/';
  static const String main = '/main';
  static const String result = '/result';
  static const String settings = '/settings';
  static const String about = '/about';

  /// 🔥 ROUTE GENERATOR (SAFE)
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case splash:
        return _fade(SplashScreen());

      case main:
        return _fade(const MainScreen());

      case result:
        return _slide(
          ResultScreen(
            (args is Map<String, dynamic>) ? args : {},
          ),
        );

      case settings:
        return _slide(const SettingsScreen());

      case about:
        return _slide(const AboutScreen());

      default:
        return _errorRoute(routeSettings.name);
    }
  }

  /// 🔥 FADE TRANSITION (REUSABLE)
  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }

  /// 🔥 SLIDE TRANSITION (LEBIH HALUS)
  static PageRouteBuilder _slide(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// 🔥 ERROR PAGE (ANTI CRASH)
  static Route<dynamic> _errorRoute(String? route) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("404")),
        body: Center(
          child: Text(
            "Route tidak ditemukan:\n$route",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
