import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'bloc_observer.dart';
import 'config/PrefHelper/prefs.dart';
import 'config/PrefHelper/helper.dart';
import 'config/theme/theme_cubit.dart';
import 'core/utils/local_strings.dart';
import 'injection_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();
  await di.init();

  // Add this line, before init()
  await FlutterLocalization.instance.ensureInitialized();

  FlutterLocalization.instance.init(
    mapLocales: [
      const MapLocale('en', AppLocale.EN, countryCode: 'US'),
      const MapLocale('ar', AppLocale.AR, countryCode: 'AR'),
    ],
    initLanguageCode: 'en',
  );

  await Helper.getDefaultLanguage();
  await initializeDateFormatting('en', null);
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => di.sl<ThemeCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );

}
