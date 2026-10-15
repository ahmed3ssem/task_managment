// ============================================================================
// File: create_board_test.dart
// Description: Unit and Widget tests for Board Creation functionality.
//              Tests UseCases, TasksCubit, and CreateBoardBottomSheet validation.
// ============================================================================

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_structure/config/PrefHelper/prefs.dart';
import 'package:flutter_project_structure/core/error/failures.dart';
import 'package:flutter_project_structure/core/utils/local_strings.dart';
import 'dart:async';
import 'package:flutter_project_structure/feature/tasks/data/models/task_board_model.dart';
import 'package:flutter_project_structure/feature/tasks/domain/repositories/tasks_repository.dart';
import 'package:flutter_project_structure/feature/tasks/domain/usecases/create_board_usecase.dart';
import 'package:flutter_project_structure/feature/tasks/domain/usecases/get_boards_stream_usecase.dart';
import 'package:flutter_project_structure/feature/tasks/domain/usecases/get_boards_usecase.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/cubit/tasks_state.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/screen/tasks_managment_screen.dart';
import 'package:flutter_project_structure/feature/tasks/presentation/widgets/create_board_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockTasksRepository implements TasksRepository {
  final List<TaskBoardModel> savedBoards = [];
  final StreamController<List<TaskBoardModel>> _controller =
      StreamController<List<TaskBoardModel>>.broadcast();
  bool shouldFail = false;

  @override
  Future<Either<Failures, void>> createBoard(TaskBoardModel board) async {
    if (shouldFail) {
      return const Left(ServerFailure(msg: 'Firebase RTDB connection error'));
    }
    savedBoards.insert(0, board);
    _controller.add(List.unmodifiable(savedBoards));
    return const Right(null);
  }

  @override
  Future<Either<Failures, List<TaskBoardModel>>> getBoards() async {
    if (shouldFail) {
      return const Left(ServerFailure(msg: 'Failed to fetch boards'));
    }
    return Right(List.unmodifiable(savedBoards));
  }

  @override
  Stream<List<TaskBoardModel>> getBoardsStream() async* {
    yield List.unmodifiable(savedBoards);
    yield* _controller.stream;
  }
}

void main() {
  late MockTasksRepository repository;
  late CreateBoardUseCase createBoardUseCase;
  late GetBoardsUseCase getBoardsUseCase;
  late GetBoardsStreamUseCase getBoardsStreamUseCase;
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
    createBoardUseCase = CreateBoardUseCase(repository: repository);
    getBoardsUseCase = GetBoardsUseCase(repository: repository);
    getBoardsStreamUseCase = GetBoardsStreamUseCase(repository: repository);
    cubit = TasksCubit(
      createBoardUseCase: createBoardUseCase,
      getBoardsUseCase: getBoardsUseCase,
      getBoardsStreamUseCase: getBoardsStreamUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('TasksCubit & CreateBoardUseCase', () {
    test('initial state is TasksInitial', () {
      expect(cubit.state, const TasksInitial());
    });

    test(
      'createBoard emits CreateBoardSuccess when repository succeeds',
      () async {
        final expectedStates = [
          const CreateBoardLoading(),
          isA<CreateBoardSuccess>(),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.createBoard(
          name: 'Growth Strategy',
          department: 'Marketing',
          description: 'New quarter growth initiatives and brand awareness.',
        );

        expect(repository.savedBoards.length, 1);
        expect(repository.savedBoards.first.name, 'Growth Strategy');
        expect(repository.savedBoards.first.department, 'Marketing');
      },
    );

    test('createBoard emits CreateBoardError when repository fails', () async {
      repository.shouldFail = true;

      final expectedStates = [
        const CreateBoardLoading(),
        const CreateBoardError(message: 'Firebase RTDB connection error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.createBoard(
        name: 'Growth Strategy',
        department: 'Marketing',
        description: 'Testing error handling.',
      );
    });
  });

  group('CreateBoardBottomSheet Widget Tests', () {
    testWidgets(
      'Tapping Create Board opens bottom sheet with all fields and validation',
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

        // Verify initial empty state ("Nothing to show yet")
        expect(find.text(LocalStrings.nothingToShowYet), findsOneWidget);

        // Tap Create Board button
        final createBoardBtn = find.text(LocalStrings.createBoard);
        expect(createBoardBtn, findsOneWidget);
        await tester.tap(createBoardBtn);
        await tester.pumpAndSettle();

        // Verify bottom sheet title and fields
        expect(find.byType(CreateBoardBottomSheet), findsOneWidget);
        expect(find.text(LocalStrings.boardName), findsOneWidget);
        expect(find.text(LocalStrings.boardDepartment), findsOneWidget);
        expect(find.text(LocalStrings.boardDescription), findsOneWidget);
        expect(find.text(LocalStrings.save), findsOneWidget);

        // Verify description icon and hint text are aligned on the exact same line
        final iconPos = tester.getTopLeft(
          find.byIcon(Icons.description_outlined),
        );
        final hintPos = tester.getTopLeft(
          find.text(LocalStrings.enterBoardDescription),
        );
        expect((iconPos.dy - hintPos.dy).abs(), lessThan(3.0));

        // Tap Save without filling to trigger validation
        await tester.ensureVisible(find.text(LocalStrings.save));
        await tester.tap(find.text(LocalStrings.save));
        await tester.pumpAndSettle();

        // Validation errors should appear
        expect(find.text(LocalStrings.nameRequired), findsOneWidget);
        expect(find.text(LocalStrings.departmentRequired), findsOneWidget);
        expect(find.text(LocalStrings.descriptionRequired), findsOneWidget);

        // Fill in Name
        await tester.enterText(
          find.widgetWithText(TextFormField, LocalStrings.enterBoardName),
          'Q4 Product Launch',
        );

        // Select Department (Marketing)
        await tester.ensureVisible(find.text(LocalStrings.selectDepartment));
        await tester.tap(find.text(LocalStrings.selectDepartment));
        await tester.pumpAndSettle();
        await tester.tap(find.text(LocalStrings.marketing).last);
        await tester.pumpAndSettle();

        // Fill in Description
        await tester.enterText(
          find.widgetWithText(
            TextFormField,
            LocalStrings.enterBoardDescription,
          ),
          'Execution plan for the international market rollout.',
        );
        await tester.pumpAndSettle();

        // Tap Save button with valid data
        await tester.ensureVisible(find.text(LocalStrings.save));
        await tester.tap(find.text(LocalStrings.save));
        await tester.pumpAndSettle();

        // Bottom sheet should dismiss and new board should be displayed in the list
        expect(find.byType(CreateBoardBottomSheet), findsNothing);
        expect(find.text('Q4 Product Launch'), findsOneWidget);
        expect(repository.savedBoards.length, 1);
        expect(repository.savedBoards.first.name, 'Q4 Product Launch');
        expect(repository.savedBoards.first.department, 'Marketing');
      },
    );
  });
}
