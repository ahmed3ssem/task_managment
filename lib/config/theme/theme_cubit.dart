import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_structure/core/preferences/flutter_secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    final isDark = await MySecureStorage.getIsDark();
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final newIsDark = state != ThemeMode.dark;

    await MySecureStorage.setIsDark(newIsDark);

    emit(newIsDark ? ThemeMode.dark : ThemeMode.light);

    log("Theme changed to: ${newIsDark ? "Dark" : "Light"}");
  }
}
