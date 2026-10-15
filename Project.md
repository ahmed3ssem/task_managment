# Task Management App - Project Handover & Context

This document captures the current architecture, implemented features, design decisions, and upcoming roadmap for this Flutter project so any AI assistant or developer can seamlessly pick up and continue development.

---

## 1. Project Overview & Architecture

- **Framework**: Flutter (Dart SDK ^3.12.2)
- **Architecture**: Strict Clean Architecture with Feature-First modular structure:
  - `lib/core/`: Common utilities, API consumer, error handling, network info, local storage, localization.
  - `lib/config/`: Routes, themes, styles, SharedPreferences helpers (`Prefs` & `Helper`).
  - `lib/feature/<feature_name>/`: Divided into `data`, `domain`, and `presentation`.
- **Database & Persistence**: **Firebase Realtime Database** (`firebase_database: ^13.0.0`) configured with URL `https://tasks-managment-d2298-default-rtdb.asia-southeast1.firebasedatabase.app` persisting board data under `/boards`.
- **State Management**: `flutter_bloc` (Bloc & Cubit).
- **Dependency Injection**: `get_it` via `lib/injection_container.dart`.
- **Screen Adaptation**: `flutter_screenutil` (Design base size: `375 x 812`).
- **Localization**: `flutter_localization` supporting **English (default)** and **Arabic (RTL)**.
- **Theming**: Light and Dark mode managed by `ThemeCubit` (`lib/config/theme/theme_cubit.dart`) and helper `ThemeHelper` (`lib/config/theme/theme_helper.dart`).

---

## 2. Mandatory Rules & Guidelines (from AGENTS.md)

1. **Localization**: Never hardcode user-facing strings in UI. Always declare string keys in `lib/core/utils/local_strings.dart` in both English (`AppLocale.EN`) and Arabic (`AppLocale.AR`), exposed via `LocalStrings.<key>`.
2. **Directionality & RTL/LTR**: Always use directionality-aware widgets and properties (`EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`, etc.).
3. **Dependency Injection**: Shared services/cubits must be registered in `lib/injection_container.dart`. Never instantiate shared dependencies directly in UI widgets.
4. **Theme Consistency**: Reuse theme tokens from `AppColors` and dynamic colors via `ThemeHelper` for seamless dark and light theme switching.
5. **Quality Verification**: Before finishing tasks, always format with `dart format` and run `flutter analyze` and `flutter test`.

---

## 3. Clean Architecture Implementation: Tasks Feature

### A. Domain Layer (`lib/feature/tasks/domain/`)
1. **`repositories/tasks_repository.dart`**:
   - `Future<Either<Failures, void>> createBoard(TaskBoardModel board)`
   - `Future<Either<Failures, List<TaskBoardModel>>> getBoards()`
   - `Stream<List<TaskBoardModel>> getBoardsStream()`
2. **`usecases/create_board_usecase.dart`**:
   - Encapsulates board creation logic: `call(TaskBoardModel params)`.
3. **`usecases/get_boards_usecase.dart`**:
   - Encapsulates board retrieval logic: `call(NoParams params)`.

### B. Data Layer (`lib/feature/tasks/data/`)
1. **`datasources/tasks_remote_data_source.dart`**:
   - `TasksRemoteDataSourceImpl`: Connects directly to `FirebaseDatabase.instance.ref('boards')`.
   - Generates unique push IDs and saves `{id, name, department, description, creationDate, role, memberAvatars, additionalMembersCount}` into Firebase RTDB.
2. **`repositories/tasks_repository_impl.dart`**:
   - Connects `TasksRemoteDataSource` with `NetworkInfo`.
   - Catches exceptions and returns clean `Either<Failures, T>`.
3. **`models/task_board_model.dart`**:
   - Extends `Equatable`. Implements `fromMap` and `toMap` for Firebase RTDB serialization.
4. **`models/task_category_model.dart`**:
   - Extends `Equatable`. Implements `fromMap` for category metadata.

### C. Presentation Layer (`lib/feature/tasks/presentation/`)
1. **`cubit/tasks_state.dart`**:
   - `TasksInitial`
   - `CreateBoardLoading`, `CreateBoardSuccess`, `CreateBoardError`
   - `TasksLoading`, `TasksLoaded`, `TasksError`
2. **`cubit/tasks_cubit.dart`**:
   - Formats creation date via `DateFormat('d MMM yyyy')`.
   - Dispatches `createBoardUseCase(board)` and manages loading/success/error states.
3. **`widgets/create_board_bottom_sheet.dart`**:
   - **Rounded Top Corners**: `20.r` rounded top corners with subtle elevation and top drag indicator.
   - **Form Fields**:
     - **Board Name**: `TextFormField` (8.r border radius, non-empty validation via `LocalStrings.nameRequired`).
     - **Board Department**: `DropdownButtonFormField<String>` with strictly `"Marketing"` option (validated selection via `LocalStrings.departmentRequired`).
     - **Board Description**: Multiline `TextFormField` (3 to 5 lines, 8.r border radius, non-empty validation via `LocalStrings.descriptionRequired`).
   - **Save CTA**: Styled in brand green (`AppColors.primaryColor`), validates form, triggers `TasksCubit.createBoard(...)`, displays loading spinner, shows floating SnackBar on success, and dismisses modal.
4. **`screen/tasks_managment_screen.dart`**:
   - Provides `TasksCubit` via `BlocProvider`.
   - Connects `TaskActionButtonsRow.onCreateBoardTap` to `CreateBoardBottomSheet.show(...)`.
   - Prepend new boards dynamically into the board list upon creation.

---

## 4. Reusable UI Components

1. **`TaskCategoryCell` (`lib/feature/tasks/presentation/widgets/task_category_cell.dart`)**:
   - 45x45 square badge with category title.
   - Selected: Brand green `#568F22` background, white text.
   - Unselected: White / Dark Card with subtle border and muted text.
2. **`TaskSearchBar` (`lib/feature/tasks/presentation/widgets/task_search_bar.dart`)**:
   - 15.r rounded corners, leading search icon, placeholder, and animated clear ('X') button.
3. **`TaskActionButtonsRow` (`lib/feature/tasks/presentation/widgets/task_action_buttons_row.dart`)**:
   - Proportional 2:3 responsive ratio for mobile (`Expanded(flex: 2)` Filter + `Expanded(flex: 3)` Create Board).
   - "Create Board" button styled in brand primary green `#568F22`.
4. **`TaskBoardCard` (`lib/feature/tasks/presentation/widgets/task_board_card.dart`)**:
   - Card displaying board name, primary green department label, amber "Owner" role pill, multiline description, creation date, and overlapping avatar stack.

---

## 5. Dependency Injection (`lib/injection_container.dart`)

All feature dependencies are registered via GetIt:
- `sl.registerFactory<TasksCubit>(() => TasksCubit(createBoardUseCase: sl(), getBoardsUseCase: sl()));`
- `sl.registerLazySingleton<CreateBoardUseCase>(() => CreateBoardUseCase(repository: sl()));`
- `sl.registerLazySingleton<GetBoardsUseCase>(() => GetBoardsUseCase(repository: sl()));`
- `sl.registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));`
- `sl.registerLazySingleton<TasksRemoteDataSource>(() => TasksRemoteDataSourceImpl(database: sl()));`
- `sl.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);`

---

## 6. Tests Status

- **`test/widget_test.dart`**: Verifies `TaskCategoryCell` interaction.
- **`test/tasks_managment_screen_test.dart`**: Tests `TasksManagmentScreen` AppBar, category filter scrolling, search input typing, clear button, and list rendering.
- **`test/create_board_test.dart`**:
  - `TasksCubit` state transitions (`TasksInitial`, `CreateBoardLoading`, `CreateBoardSuccess`, `CreateBoardError`).
  - `CreateBoardBottomSheet` modal launch, validation triggers on empty fields, dropdown selection, successful save, and UI list prepending.
- **Result**: All tests pass (`flutter test`: 6 passed).

---

## 7. Next Steps for Upcoming Implementation

1. **Filter Bottom Sheet**:
   - Implement filter modal when "Filter" button in `TaskActionButtonsRow` is tapped.
2. **Board Details Screen**:
   - Tapping any `TaskBoardCard` navigates to board tasks view (Kanban boards / task items).
3. **Dynamic Realtime Sync**:
   - Connect `TasksRemoteDataSource.getBoardsStream()` to auto-sync boards in real-time across devices.
