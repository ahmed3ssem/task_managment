// ============================================================================
// File: search_board_test.dart
// Description: Dedicated widget tests for the board search feature:
//              1. Searching by board name displays matching items.
//              2. Searching for a non-existent name displays empty state ("No matching results found").
//              3. Tapping the search bar close ('X') button restores all items.
//              4. Tapping "Clear Search" button in empty state restores all items.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_structure/config/PrefHelper/prefs.dart';
import 'package:flutter_project_structure/core/utils/local_strings.dart';
import 'package:flutter_project_structure/feature/tasks/data/models/task_board_model.dart';
import 'package:flutter_project_structure/feature/tasks/domain/usecases/create_board_usecase.dart';
import 'package:flutter_project_structure/feature/tasks/domain/usecases/get_boards_stream_usecase.dart';
import 'package:flutter_project_structure/feature/tasks/domain/usecases/get_boards_usecase.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/screen/tasks_managment_screen.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/widgets/task_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_board_test.dart';

void main() {
  late MockTasksRepository repository;
  late TasksCubit cubit;

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

    repository = MockTasksRepository();
    // Seed test boards
    repository.savedBoards.addAll([
      const TaskBoardModel(
        id: '1',
        name: 'Alpha Marketing',
        department: 'Marketing',
        description: 'First test board.',
        creationDate: '10 Aug 2024',
        role: 'Owner',
      ),
      const TaskBoardModel(
        id: '2',
        name: 'Beta Software Engine',
        department: 'Software',
        description: 'Second test board.',
        creationDate: '12 Aug 2024',
        role: 'Owner',
      ),
      const TaskBoardModel(
        id: '3',
        name: 'Gamma Finance Audit',
        department: 'Finance',
        description: 'Third test board.',
        creationDate: '15 Aug 2024',
        role: 'Owner',
      ),
    ]);

    cubit = TasksCubit(
      createBoardUseCase: CreateBoardUseCase(repository: repository),
      getBoardsUseCase: GetBoardsUseCase(repository: repository),
      getBoardsStreamUseCase: GetBoardsStreamUseCase(repository: repository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets(
    'Search by name, empty state when no match, and full restore when clicking X or Clear Search',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, _) =>
              MaterialApp(home: TasksManagmentScreen(cubit: cubit)),
        ),
      );

      await tester.pumpAndSettle();

      // Initially all 3 boards exist
      expect(find.text('Alpha Marketing'), findsOneWidget);
      expect(find.text('Beta Software Engine'), findsOneWidget);
      expect(find.text('Gamma Finance Audit'), findsOneWidget);

      final searchTextField = find.descendant(
        of: find.byType(TaskSearchBar),
        matching: find.byType(TextField),
      );

      // 1. Search for "Alpha" by name
      await tester.enterText(searchTextField, 'Alpha');
      await tester.pumpAndSettle();

      // Only Alpha Marketing should be visible
      expect(find.text('Alpha Marketing'), findsOneWidget);
      expect(find.text('Beta Software Engine'), findsNothing);
      expect(find.text('Gamma Finance Audit'), findsNothing);

      // 2. Click 'X' icon inside TaskSearchBar
      final clearXIcon = find.descendant(
        of: find.byType(TaskSearchBar),
        matching: find.byIcon(Icons.close_rounded),
      );
      expect(clearXIcon, findsOneWidget);
      await tester.tap(clearXIcon);
      await tester.pumpAndSettle();

      // All 3 boards must be retrieved again
      expect(find.text('Alpha Marketing'), findsOneWidget);
      expect(find.text('Beta Software Engine'), findsOneWidget);
      expect(find.text('Gamma Finance Audit'), findsOneWidget);

      // 3. Search for non-existent name
      await tester.enterText(searchTextField, 'Zeta Unknown Board');
      await tester.pumpAndSettle();

      // None of the boards should be visible
      expect(find.text('Alpha Marketing'), findsNothing);
      expect(find.text('Beta Software Engine'), findsNothing);
      expect(find.text('Gamma Finance Audit'), findsNothing);

      // Empty state prompt must appear
      expect(find.text(LocalStrings.noMatchingResults), findsOneWidget);
      expect(find.text(LocalStrings.noResultsDescription), findsOneWidget);
      expect(find.text(LocalStrings.clearSearch), findsOneWidget);

      // 4. Click "Clear Search" button in empty state
      await tester.tap(find.text(LocalStrings.clearSearch));
      await tester.pumpAndSettle();

      // All boards restored again
      expect(find.text('Alpha Marketing'), findsOneWidget);
      expect(find.text('Beta Software Engine'), findsOneWidget);
      expect(find.text('Gamma Finance Audit'), findsOneWidget);
    },
  );
}
