import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_structure/config/PrefHelper/prefs.dart';
import 'package:flutter_project_structure/core/utils/local_strings.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/screen/tasks_managment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Prefs.init();
    await FlutterLocalization.instance.ensureInitialized();
    FlutterLocalization.instance.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN, countryCode: 'US'),
        const MapLocale('ar', AppLocale.AR, countryCode: 'AR'),
      ],
      initLanguageCode: 'en',
    );
  });

  testWidgets('TasksManagmentScreen displays AppBar and all category cells', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => const MaterialApp(home: TasksManagmentScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify AppBar Title
    expect(find.text(LocalStrings.taskManagement), findsOneWidget);

    // Verify initial visible Category Cells
    expect(find.text(LocalStrings.all), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text(LocalStrings.marketing), findsOneWidget);

    // Tap on marketing while in view
    await tester.tap(find.text(LocalStrings.marketing));
    await tester.pumpAndSettle();

    // Scroll horizontal ListView to verify remaining items
    final scrollable = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text(LocalStrings.software),
      50,
      scrollable: scrollable,
    );
    expect(find.text(LocalStrings.software), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(LocalStrings.finance),
      50,
      scrollable: scrollable,
    );
    expect(find.text(LocalStrings.finance), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(LocalStrings.researchAndDevelopment),
      50,
      scrollable: scrollable,
    );
    expect(find.text(LocalStrings.researchAndDevelopment), findsOneWidget);

    // Verify Search Bar exists with localized hint
    expect(find.text(LocalStrings.search), findsOneWidget);

    // Enter search text
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'Design UI');
    await tester.pumpAndSettle();

    expect(find.text('Design UI'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tap clear button to reset search
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Design UI'), findsNothing);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });
}
