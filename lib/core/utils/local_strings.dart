// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localization/src/localization/flutter_localization_translator.dart';

extension StringTrExtension on String {
  /// Translates a string key directly.
  /// Usage: 'noData'.tr or AppLocale.noData.tr
  String get tr => FlutterLocalizationTranslator.instance.getStringOrKey(this);

  /// Optional: Translates with [BuildContext] for reactive widget rebuilds on language change.
  String trContext(BuildContext context) => getString(context);
}

class LocalStrings {
  static String get noData => 'noData'.tr;
  static String get english => 'english'.tr;
  static String get arabic => 'arabic'.tr;
  static String get loadingMore => 'loadingMore'.tr;
  static String get refresh => 'refresh'.tr;
  static String get somethingWentWrong => 'somethingWentWrong'.tr;
  static String get pleaseTryAgain => 'pleaseTryAgain'.tr;
  static String get reloadScreen => 'reloadScreen'.tr;
  static String get loading => 'loading'.tr;
  static String get pleaseWait => 'pleaseWait'.tr;
  static String get ok => 'ok'.tr;
  static String get skip => 'skip'.tr;
}

mixin AppLocale {
  static const String noData = 'noData';
  static const String english = 'english';
  static const String arabic = 'arabic';
  static const String loadingMore = 'loadingMore';
  static const String refresh = 'refresh';
  static const String somethingWentWrong = 'somethingWentWrong';
  static const String pleaseTryAgain = 'pleaseTryAgain';
  static const String reloadScreen = 'reloadScreen';
  static const String loading = 'loading';
  static const String pleaseWait = 'pleaseWait';
  static const String ok = 'ok';
  static const String skip = 'skip';

  static const Map<String, dynamic> AR = {
    noData: "لا يوجد بيانات",
    english: "Proceed With English",
    arabic: "المتابعة باللغة العربية",
    loadingMore: "جاري تحميل المزيد...",
    refresh: "إعادة المحاولة",
    somethingWentWrong: "حدث خطأ ما",
    pleaseTryAgain: "يرجى المحاولة مرة أخرى",
    reloadScreen: "إعادة تحميل الشاشة",
    loading: "جاري التحميل",
    pleaseWait: "يرجى الانتظار",
    ok: "حسناً",
    skip: "تخطي",
  };

  static const Map<String, dynamic> EN = {
    noData: "There is no data",
    english: "Proceed With English",
    arabic: "Proceed With Arabic",
    loadingMore: "Loading more...",
    refresh: "Retry",
    somethingWentWrong: "Something went wrong",
    pleaseTryAgain: "Please try again",
    reloadScreen: "Reload screen",
    loading: "Loading",
    pleaseWait: "Please wait",
    ok: "OK",
    skip: "Skip",
  };
}
