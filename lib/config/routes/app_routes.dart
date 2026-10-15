import 'package:flutter/material.dart';

class Routes {
  static const String initialRoutes = '/';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoutes:
        return MaterialPageRoute(builder: (context) {
          return const SizedBox();
        });
      default:
        return null;
    }
  }
}
