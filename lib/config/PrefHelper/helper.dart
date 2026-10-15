import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_project_structure/config/PrefHelper/prefs.dart';
import '../../core/utils/app_strings.dart';

class Helper {
  static Future<void> getDefaultLanguage() async {
    final localization = FlutterLocalization.instance;
    if (Prefs.isContain(AppStrings.local)) {
      String savedLocale = Prefs.getString(AppStrings.local);
      String langCode = (savedLocale == AppStrings.enCountryCode || savedLocale == 'en' || savedLocale == 'EN') ? 'en' : 'ar';
      localization.translate(langCode);
    } else {
      // Default to English if no language is chosen
      localization.translate('en');
      // Save English as default
      await setDefaultLang(AppStrings.enCountryCode);
    }
  }

  static Future<void> setLanguage(String langCode) async {
    final localization = FlutterLocalization.instance;
    localization.translate(langCode);
    String countryCode = (langCode == 'en') ? AppStrings.enCountryCode : AppStrings.arCountryCode;
    await setDefaultLang(countryCode);
  }

  static Future<bool> setDefaultLang(String lang) async =>
      Prefs.setString(AppStrings.local, lang);

  static String getLanguage() {
    String local = '';
    if (Helper.getCurrentLocal() == 'US') {
      local = 'en';
    } else {
      local = 'ar';
    }
    return local;
  }

  static String getCurrentLocal() {
    String local = AppStrings.enCountryCode;
    final currentLocal = FlutterLocalization.instance.currentLocale;

    if (currentLocal != null && currentLocal.countryCode != null) {
      local = currentLocal.countryCode!;
    } else {
      // Fallback to saved preference
      if (Prefs.isContain(AppStrings.local)) {
        local = Prefs.getString(AppStrings.local);
      }
    }

    if (local == 'US') {
      AppStrings.appLocal = 'en';
    } else {
      AppStrings.appLocal = 'ar';
    }
    return local;
  }

  static String getUserEmail() {
    String email = '';
    if (Prefs.isContain(AppStrings.email)) {
      email = Prefs.getString(AppStrings.email);
    }
    return email;
  }
}
