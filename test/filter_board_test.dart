// ============================================================================
// File: filter_board_test.dart
// Description: Widget and unit tests for the Filter modal bottom sheet,
//              validation rules, and list filtering behavior.
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
import 'package:flutter_project_structure/feature/tasks/presentation/widgets/filter_bottom_sheet.dart';
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
    // Pre-populate mock repository with test boards
    repository.savedBoards.addAll([
      const TaskBoardModel(
        id: '1',
        name: 'Marketing Campaign',
        department: 'Marketing',
        description: 'Global marketing campaign.',
        creationDate: '17 Jul 2024',
        role: 'Owner',
      ),
      const TaskBoardModel(
        id: '2',
        name: 'Core Engine Dev',
        department: 'Software',
        description: 'Engine architecture.',
        creationDate: '20 Jul 2024',
        role: 'Member',
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

  group('FilterBottomSheet Widget Tests', () {
    testWidgets(
      'Opens Filter bottom sheet, validates empty apply, filters by department, and resets',
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

        // Verify both boards initially visible
        expect(find.text('Marketing Campaign'), findsOneWidget);
        expect(find.text('Core Engine Dev'), findsOneWidget);

        // Tap Filter button
        final filterBtn = find.text(LocalStrings.filter);
        expect(filterBtn, findsOneWidget);
        await tester.tap(filterBtn);
        await tester.pumpAndSettle();

        // Verify FilterBottomSheet elements exist
        expect(find.byType(FilterBottomSheet), findsOneWidget);
        expect(find.text(LocalStrings.owningStatus), findsWidgets);
        expect(find.text(LocalStrings.reset), findsOneWidget);
        expect(find.text(LocalStrings.apply), findsOneWidget);

        // 1. Validation test: Tap Apply without any selections
        await tester.ensureVisible(find.text(LocalStrings.apply));
        await tester.tap(find.text(LocalStrings.apply));
        await tester.pumpAndSettle();

        // SnackBar validation should trigger
        expect(find.text(LocalStrings.selectAtLeastOneFilter), findsOneWidget);

        // 2. Select Department "Marketing"
        final departmentDropdown = find
            .text(LocalStrings.department.replaceAll(':', '').trim())
            .last;
        await tester.ensureVisible(departmentDropdown);
        await tester.tap(departmentDropdown);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();

        // Tap Apply with valid selection
        await tester.ensureVisible(find.text(LocalStrings.apply));
        await tester.tap(find.text(LocalStrings.apply));
        await tester.pumpAndSettle();

        // Bottom sheet dismisses
        expect(find.byType(FilterBottomSheet), findsNothing);

        // Filter is applied: only Marketing board remains visible
        expect(find.text('Marketing Campaign'), findsOneWidget);
        expect(find.text('Core Engine Dev'), findsNothing);

        // 3. Reset test: Tap Filter button again
        await tester.tap(find.text(LocalStrings.filter));
        await tester.pumpAndSettle();

        // Tap Reset button
        await tester.ensureVisible(find.text(LocalStrings.reset));
        await tester.tap(find.text(LocalStrings.reset));
        await tester.pumpAndSettle();

        // Bottom sheet dismisses and all items restored
        expect(find.byType(FilterBottomSheet), findsNothing);
        expect(find.text('Marketing Campaign'), findsOneWidget);
        expect(find.text('Core Engine Dev'), findsOneWidget);
      },
    );
  });
}
