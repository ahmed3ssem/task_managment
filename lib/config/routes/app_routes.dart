import 'package:flutter/material.dart';

import '../../feature/tasks/presentation/tasks_managment_screen.dart';

class Routes {
  static const String initialRoutes = '/';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoutes:
        return MaterialPageRoute(
          builder: (context) {
            return const TasksManagmentScreen();
          },
        );
      default:
        return null;
    }
  }
}
