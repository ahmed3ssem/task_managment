# Task Management App - Project Handover & Context

This document captures the current architecture, implemented features, design decisions, and upcoming roadmap for this Flutter project so any AI assistant or developer can seamlessly pick up and continue development.

---

## 1. Project Overview & Architecture

- **Framework**: Flutter (Dart SDK ^3.12.2)
- **Architecture**: Clean Architecture with Feature-First modular structure:
  - `lib/core/`: Common utilities, API consumer, error handling, network info, local storage, localization.
  - `lib/config/`: Routes, themes, styles, SharedPreferences helpers (`Prefs` & `Helper`).
  - `lib/feature/<feature_name>/`: Divided into `data`, `domain`, and `presentation`.
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

## 3. Implemented Components & Current Progress

### A. Initial Screen Route
- `lib/config/routes/app_routes.dart` sets `TasksManagmentScreen` as the initial route (`Routes.initialRoutes = '/'`).

### B. Tasks Management Screen (`lib/feature/tasks/presentation/screen/tasks_managment_screen.dart`)
- **AppBar**:
  - `centerTitle: true` (User specified).
  - Title: Localized `LocalStrings.taskManagement` ("Task Management" / "إدارة المهام").
  - Styling: `28.sp`, font-weight `600`, adaptive dark/light colors (`#2D2D2D` in light mode, `#FFFFFF` in dark mode).
  - Background: `ThemeHelper.backgroundColor(context)`, elevation `0`, `scrolledUnderElevation: 0`.

- **Category Filter Tabs (Horizontal ListView)**:
  - Replaced the initial Wrap layout with a compact, horizontally scrolling `ListView.separated` (`height: 48.h`, `BouncingScrollPhysics`).
  - Padding: `EdgeInsetsDirectional.symmetric(horizontal: 24.w)`, separator width `24.w`.
  - Categories:
    1. `All` (`14` tasks)
    2. `Marketing` (`5` tasks)
    3. `Software` (`5` tasks)
    4. `Finance` (`7` tasks)
    5. `Research and Development` (`2` tasks)
  - State: Managed via `_selectedCategoryIndex` in `_TasksManagmentScreenState`.

- **Search Bar Component**:
  - Positioned below the categories with `18.h` vertical gap and `24.w` side padding.
  - Managed with `_searchController`, `searchQuery` getter, `_onSearchChanged`, and `_onSearchCleared`.

---

### C. Reusable Feature Widgets

#### 1. `TaskCategoryCell` (`lib/feature/tasks/presentation/widgets/task_category_cell.dart`)
- Interactive item displaying the 45x45 square badge and category title.
- **Brand Green Accent Palette**:
  - **Selected / Active**:
    - Badge Background: `AppColors.primaryColor` (`#568F22`).
    - Badge Number: White (`#FFFFFF`), `20.sp`, `FontWeight.w700`.
    - Category Label: `#2D2D2D` (or `#FFFFFF` in dark mode), `18.sp`, `FontWeight.w700`.
  - **Unselected / Inactive**:
    - Badge Background: `#FFFFFF` (or `AppColors.darkCard` in dark mode), subtle border `#E2E2E2` / `darkBorder`.
    - Badge Number: Muted grey `#797979`, `20.sp`, `FontWeight.w500`.
    - Category Label: Muted grey `#797979`, `18.sp`, `FontWeight.w500`.
- Touch feedback: Wrapped in `Material` + `InkWell`.

#### 2. `TaskSearchBar` (`lib/feature/tasks/presentation/widgets/task_search_bar.dart`)
- **Figma Specs & Styling**:
  - Rounded corners: `15.r` (updated by user, wrapped in `ClipRRect(borderRadius: BorderRadius.circular(15.r))`).
  - Height: `44.h`.
  - Background: White (`#FFFFFF` in light mode, `AppColors.darkCard` in dark mode).
  - Border: `1.w` `#E2E2E2` (light) / `AppColors.darkBorder` (dark).
  - Subtle shadow on light mode.
- **Leading Search Icon**:
  - Minimalist search magnifier (`Icons.search_rounded`), `22.sp`, color `#797979`.
- **Placeholder / Hint**:
  - Localized `LocalStrings.search` ("Search" / "بحث"), `16.sp`, `FontWeight.w500`, color `#797979`.
- **Dynamic Clear / Close Button**:
  - An `Icons.close_rounded` button dynamically appears only when text is entered into the field.
  - Tapping the clear button:
    1. Clears text in controller.
    2. Calls `onClear` and `onChanged('')`.
    3. Dismisses the keyboard (`FocusScope.of(context).unfocus()`).
    4. Resets the task search filter back to show all tasks.

#### 3. `TaskActionButtonsRow` (`lib/feature/tasks/presentation/widgets/task_action_buttons_row.dart`)
- **Row of Two Secondary Actions**:
  1. **Filter Button**:
     - Background: White (`#FFFFFF` in light mode, `AppColors.darkCard` in dark mode).
     - Outline: `1.w` `#E2E2E2` / `darkBorder`, `8.r` rounded corners.
     - Icon: Tuning/filter icon (`Icons.tune_rounded`), `20.sp`, color `#797979`.
     - Label: Localized `LocalStrings.filter` ("Filter" / "تصفية"), `16.sp`, `FontWeight.w500`, color `#797979`.
     - Future behavior: Opens Filter bottom dialog modal.
  2. **Create Board Button**:
     - Background: Brand primary green (`AppColors.primaryColor`, `#568F22`) specifically selected to match the active cell in `TaskCategoryCell`.
     - Outline: `AppColors.primaryColor` with primary shadow (`alpha: 0.25`, blur: 12).
     - Label: Localized `LocalStrings.createBoard` ("Create Board" / "إنشاء لوحة"), `16.sp`, `FontWeight.w600`, color `#FFFFFF`.
     - Future behavior: Opens Create Board bottom dialog modal.

#### 4. `TaskBoardCard` (`lib/feature/tasks/presentation/widgets/task_board_card.dart`)
- **Card Design for Task Boards**:
  1. **Top Row**:
     - Leading Icon: 40x40 container holding `Icons.space_dashboard_outlined` (matching the Create Board button icon) in primary brand green (`#568F22`).
     - Board Name: `16.sp`, `FontWeight.w600`, adaptive dark/light color.
     - Department: "Department: " in muted grey with the department name styled in **brand primary green** (`#568F22`, `FontWeight.w600`).
     - Role Badge: Polished warm amber pill (`#FFF5EB` background, `#E9780F` text, `4.r` border radius) replacing the dull grey background from Figma.
  2. **Middle Section**:
     - Board description with 2-line max and clean typography (`13.sp`, `0xFF6B7280`).
  3. **Bottom Row**:
     - Formatted creation date (`LocalStrings.creationDate` + date string).
     - Overlapping circular member avatar stack (24x24 each) with a clean `+N` additional members counter.

---

### D. Data Models
- **`TaskCategoryModel` (`lib/feature/tasks/data/models/task_category_model.dart`)**:
  - Fields: `String id`, `String title`, `int count`.
  - Extends `Equatable`.
  - Includes `fromMap` factory ready for backend/Firebase mapping.

- **`TaskBoardModel` (`lib/feature/tasks/data/models/task_board_model.dart`)**:
  - Fields: `String id`, `String name`, `String department`, `String description`, `String creationDate`, `String role`, `List<String> memberAvatars`, `int additionalMembersCount`.
  - Extends `Equatable`.
  - Includes `fromMap` and `toMap` for Firebase Firestore / API integration.

---

### E. Design Tokens & Localization Additions
- **`lib/core/utils/app_colors.dart`**:
  - `textDark`: `Color(0xFF2D2D2D)`
  - `textMuted`: `Color(0xFF797979)`
  - `badgeSelected`: `Color(0xFF9E9E9E)`
- **`lib/core/utils/local_strings.dart`**:
  - `taskManagement`: `"Task Management"` / `"إدارة المهام"`
  - `all`: `"All"` / `"الكل"`
  - `marketing`: `"Marketing"` / `"التسويق"`
  - `software`: `"Software"` / `"البرمجيات"`
  - `finance`: `"Finance"` / `"المالية"`
  - `researchAndDevelopment`: `"Research and Development"` / `"البحث والتطوير"`
  - `search`: `"Search"` / `"بحث"`
  - `filter`: `"Filter"` / `"تصفية"`
  - `createBoard`: `"Create Board"` / `"إنشاء لوحة"`
  - `department`: `"Department: "` / `"القسم: "`
  - `creationDate`: `"Creation Date: "` / `"تاريخ الإنشاء: "`
  - `owner`: `"Owner"` / `"المالك"`

---

## 4. Tests Status
- **`test/widget_test.dart`**: Tests `TaskCategoryCell` rendering and tap interaction.
- **`test/tasks_managment_screen_test.dart`**: Tests `TasksManagmentScreen` AppBar, horizontal category scrolling, search input typing, close button appearance, reset on clear, action buttons row (Filter and Create Board), and TaskBoardCard list rendering.
- All tests pass (`flutter test`: 2 passed).

---

## 5. Next Steps for Upcoming Implementation

1. **Bottom Sheet Dialogs**:
   - Filter bottom dialog (when Filter button is tapped).
   - Create Board bottom dialog (when Create Board button is tapped).
2. **Board Details / Tasks View**:
   - Tapping any `TaskBoardCard` opens the board's task items (Kanban / task list).
3. **Firebase Integration**:
   - The project has `firebase.json` and Firebase options.
   - Attach boards & tasks fetching/syncing to Firebase Firestore.
   - Connect through Clean Architecture: `TasksRemoteDataSource` -> `TasksRepository` -> `GetTasksUseCase` -> `TasksCubit`.
