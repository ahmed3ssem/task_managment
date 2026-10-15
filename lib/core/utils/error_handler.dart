import 'package:flutter/material.dart';
import 'package:flutter_project_structure/widgets/error_widget.dart';

class ErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorWidgetApp(errorDetails: details));
  }
}

class ErrorWidgetApp extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorWidgetApp({required this.errorDetails, super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetItem(onTap: () {});
  }
}
