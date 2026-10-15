import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySecureStorage {
  static final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();

  static const String isLogin = "isLogin";
  static const String token = "token";
  static const String language = "language";
  static const String isDark = "isDark";
  static const String deviceToken = "deviceToken";
  static const String showHomeTutorial = "showHomeTutorial";

  // Generic user data storage
  static const String userID = "userID";
  static const String name = "name";
  static const String email = "email";
  static const String image = "image";

  static Future<void> clearProfile() async {
    await _secureStorage.delete(key: isLogin);
    await _secureStorage.delete(key: userID);
    await _secureStorage.delete(key: name);
    await _secureStorage.delete(key: image);
    await _secureStorage.delete(key: email);
    await _secureStorage.delete(key: token);
    await _secureStorage.delete(key: isDark);

    try {
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      log("Navigation error during logout: ${e.toString()}");
    }
  }

  static Future<void> setUserData({
    required String name,
    required String userId,
    required String token,
    required String email,
    String? imageUrl,
  }) async {
    await setUserID(userId);
    await setName(name);
    await setEmail(email);
    await setToken(token);
    await setIsLogin(true);
    await setImage(imageUrl ?? '');
  }

  static Future<void> clearUserData() async {
    await _secureStorage.delete(key: isLogin);
    await _secureStorage.delete(key: userID);
    await _secureStorage.delete(key: name);
    await _secureStorage.delete(key: email);
    await _secureStorage.delete(key: token);
    await _secureStorage.delete(key: image);
  }

  static Future<String> getUserID() async =>
      await _secureStorage.read(key: userID) ?? "";
  static Future<void> setUserID(String value) async =>
      await _secureStorage.write(key: userID, value: value);

  static Future<String> getName() async =>
      await _secureStorage.read(key: name) ?? "";
  static Future<void> setName(String value) async =>
      await _secureStorage.write(key: name, value: value);

  static Future<String> getEmail() async =>
      await _secureStorage.read(key: email) ?? "";
  static Future<void> setEmail(String value) async =>
      await _secureStorage.write(key: email, value: value);

  static Future<String> getToken() async =>
      await _secureStorage.read(key: token) ?? "";
  static Future<void> setToken(String value) async =>
      await _secureStorage.write(key: token, value: value);

  static Future<String> getDeviceToken() async =>
      await _secureStorage.read(key: deviceToken) ?? "";
  static Future<void> setDeviceToken(String value) async =>
      await _secureStorage.write(key: deviceToken, value: value);

  static Future<String> getImage() async =>
      await _secureStorage.read(key: image) ?? "";
  static Future<void> setImage(String value) async =>
      await _secureStorage.write(key: image, value: value);

  static Future<String> getLanguage() async =>
      await _secureStorage.read(key: language) ?? "ar";
  static Future<void> setLanguage(String value) async =>
      await _secureStorage.write(key: language, value: value);

  static Future<bool> getIsDark() async {
    String? value = await _secureStorage.read(key: isDark);
    return value == "true";
  }

  static Future<void> setIsDark(bool value) async {
    await _secureStorage.write(key: isDark, value: value.toString());
  }

  static Future<bool> getIsLogin() async {
    String? value = await _secureStorage.read(key: isLogin);
    return value == "true";
  }

  static Future<void> setIsLogin(bool value) async {
    await _secureStorage.write(key: isLogin, value: value.toString());
  }

  static Future<bool> getShowHomeTutorial() async {
    String? value = await _secureStorage.read(key: showHomeTutorial);
    return value == null || value == "true";
  }

  static Future<void> setShowHomeTutorial(bool value) async {
    await _secureStorage.write(key: showHomeTutorial, value: value.toString());
  }

  Future<void> clearSecureStorageOnReinstall() async {
    String key = 'hasRunBefore';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasRunBefore = prefs.getBool(key);

    if (hasRunBefore == null || !hasRunBefore) {
      final allValues = await _secureStorage.readAll();
      for (String currentKey in allValues.keys) {
        if (currentKey != MySecureStorage.showHomeTutorial) {
          await _secureStorage.delete(key: currentKey);
        }
      }
      await prefs.setBool(key, true);
    }
  }
}
