// ============================================================================
// File: tasks_managment_screen.dart
// Description: Main task management screen.
//              Features a centered AppBar, horizontal scrolling category filter cells,
//              a rounded search bar, Filter/Create Board action buttons,
//              and a vertical boards list connected to [TasksCubit] and Firebase RTDB.
// ============================================================================

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';
import '../../../../injection_container.dart' as di;
import '../../data/models/task_board_model.dart';
import '../../data/models/task_category_model.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../domain/usecases/create_board_usecase.dart';
import '../../domain/usecases/get_boards_usecase.dart';
import '../cubit/tasks_cubit.dart';
import '../widgets/create_board_bottom_sheet.dart';
import '../widgets/task_action_buttons_row.dart';
import '../widgets/task_board_card.dart';
import '../widgets/task_category_cell.dart';
import '../widgets/task_search_bar.dart';

/// Fallback in-memory repository used when GetIt container has not registered
/// Firebase Realtime Database dependencies (e.g. during standalone widget tests).
class _FallbackTasksRepository implements TasksRepository {
  final List<TaskBoardModel> _boards = [];

  @override
  Future<Either<Failures, void>> createBoard(TaskBoardModel board) async {
    _boards.add(board);
    return const Right(null);
  }

  @override
  Future<Either<Failures, List<TaskBoardModel>>> getBoards() async {
    return Right(_boards);
  }

  @override
  Stream<List<TaskBoardModel>> getBoardsStream() async* {
    yield _boards;
  }
}

/// [TasksManagmentScreen] is the entry view for managing and tracking tasks.
/// Provides [TasksCubit] via [BlocProvider] to allow child widgets to dispatch
/// board creation and queries.
class TasksManagmentScreen extends StatelessWidget {
  final TasksCubit? cubit;

  const TasksManagmentScreen({super.key, this.cubit});

  TasksCubit _createCubit() {
    if (cubit != null) return cubit!;
    if (di.sl.isRegistered<TasksCubit>()) {
      return di.sl<TasksCubit>();
    }
    final fallbackRepo = _FallbackTasksRepository();
    return TasksCubit(
      createBoardUseCase: CreateBoardUseCase(repository: fallbackRepo),
      getBoardsUseCase: GetBoardsUseCase(repository: fallbackRepo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksCubit>(
      create: (_) => _createCubit(),
      child: const TasksManagmentView(),
    );
  }
}

/// [TasksManagmentView] renders the task management UI and manages local filtering state.
class TasksManagmentView extends StatefulWidget {
  const TasksManagmentView({super.key});

  @override
  State<TasksManagmentView> createState() => _TasksManagmentViewState();
}

class _TasksManagmentViewState extends State<TasksManagmentView> {
  // --------------------------------------------------------------------------
  // State Variables
  // --------------------------------------------------------------------------

  /// Index of the currently active category filter (defaults to 0: "All").
  int _selectedCategoryIndex = 0;

  /// Controller managing user input in the search field.
  final TextEditingController _searchController = TextEditingController();

  /// Holds the current search query for filtering tasks by task_name.
  String _searchQuery = '';

  /// Exposes the active search query to future Cubits / Firebase query streams.
  String get searchQuery => _searchQuery;

  /// Active list of task boards, populated initially with default mock boards
  /// and dynamically prepended when new boards are created via the bottom sheet.
  late List<TaskBoardModel> _boards;

  // --------------------------------------------------------------------------
  // Lifecycle Management
  // --------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _boards = List.from(_getDefaultBoards());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // State Transition & Search Handlers
  // --------------------------------------------------------------------------

  /// Handles search query updates as user types in the search bar.
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  /// Triggered when the close ('X') button is tapped in the search bar.
  /// Resets the search query to an empty string to restore the full task list.
  void _onSearchCleared() {
    setState(() {
      _searchQuery = '';
    });
  }

  // --------------------------------------------------------------------------
  // Data Source & Categories
  // --------------------------------------------------------------------------

  /// Returns the localized categories list.
  List<TaskCategoryModel> _getCategories(BuildContext context) {
    return [
      TaskCategoryModel(id: 'all', title: LocalStrings.all, count: 14),
      TaskCategoryModel(
        id: 'marketing',
        title: LocalStrings.marketing,
        count: 5,
      ),
      TaskCategoryModel(id: 'software', title: LocalStrings.software, count: 5),
      TaskCategoryModel(id: 'finance', title: LocalStrings.finance, count: 7),
      TaskCategoryModel(
        id: 'research_and_development',
        title: LocalStrings.researchAndDevelopment,
        count: 2,
      ),
    ];
  }

  /// Returns the initial default list of task boards.
  List<TaskBoardModel> _getDefaultBoards() {
    return const [
      TaskBoardModel(
        id: '1',
        name: 'Board Name',
        department: 'Marketing',
        description:
            'In the last five to ten years, business models and marketing methodologies have dramatically evolved.',
        creationDate: '17 Jul 2024',
        role: 'Owner',
        additionalMembersCount: 6,
      ),
      TaskBoardModel(
        id: '2',
        name: 'Mobile App Architecture',
        department: 'Software',
        description:
            'Implementation of Clean Architecture with Flutter and Firebase cloud functions sync.',
        creationDate: '20 Jul 2024',
        role: 'Owner',
        additionalMembersCount: 4,
      ),
      TaskBoardModel(
        id: '3',
        name: 'Q3 Financial Audit',
        department: 'Finance',
        description:
            'Comprehensive quarterly budget review, expense auditing, and financial projections.',
        creationDate: '01 Aug 2024',
        role: 'Owner',
        additionalMembersCount: 2,
      ),
      TaskBoardModel(
        id: '4',
        name: 'AI Agent R&D',
        department: 'Research and Development',
        description:
            'Researching multi-agent collaboration patterns and autonomous agent evaluation frameworks.',
        creationDate: '12 Aug 2024',
        role: 'Owner',
        additionalMembersCount: 8,
      ),
    ];
  }

  /// Filters boards by currently selected category tab and search query string.
  List<TaskBoardModel> _getFilteredBoards(List<TaskCategoryModel> categories) {
    final activeCategory = categories[_selectedCategoryIndex];

    return _boards.where((board) {
      // 1. Category Filter (match department or show all)
      final matchesCategory =
          activeCategory.id == 'all' ||
          board.department.toLowerCase() ==
              activeCategory.title.toLowerCase() ||
          board.department.toLowerCase() == activeCategory.id.toLowerCase();

      // 2. Search Query Filter (match board name or department)
      final matchesSearch =
          _searchQuery.isEmpty ||
          board.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          board.department.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // --------------------------------------------------------------------------
  // UI Building
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final categories = _getCategories(context);
    final filteredBoards = _getFilteredBoards(categories);

    return Scaffold(
      backgroundColor: ThemeHelper.backgroundColor(context),

      // 1. App Bar Section
      appBar: AppBar(
        backgroundColor: ThemeHelper.backgroundColor(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleSpacing: 24.w,
        title: Text(
          LocalStrings.taskManagement,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
            fontFamily: TextStyles.textLarge.fontFamily,
          ),
        ),
      ),

      // 2. Body Section
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Horizontal Categories Filter List
            SizedBox(
              height: 48.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 24.w),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategoryIndex == index;
                  return TaskCategoryCell(
                    title: category.title,
                    count: category.count,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 18.h),

            // Search Bar Component (8px rounded corners, search icon, clear button)
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: TaskSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: _onSearchCleared,
              ),
            ),

            SizedBox(height: 18.h),

            // Action Buttons Row: Filter and Create Board
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: TaskActionButtonsRow(
                onFilterTap: () {
                  // Design only now: opens Filter bottom dialog later
                },
                onCreateBoardTap: () async {
                  final createdBoard =
                      await CreateBoardBottomSheet.show<TaskBoardModel>(
                        context,
                      );
                  if (createdBoard != null && mounted) {
                    setState(() {
                      _boards.insert(0, createdBoard);
                    });
                  }
                },
              ),
            ),

            SizedBox(height: 18.h),

            // Vertical Task Boards List View
            Expanded(
              child: filteredBoards.isEmpty
                  ? Center(
                      child: Text(
                        LocalStrings.noData,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                          fontFamily: TextStyles.textLarge.fontFamily,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(
                        start: 24.w,
                        end: 24.w,
                        bottom: 24.h,
                      ),
                      itemCount: filteredBoards.length,
                      separatorBuilder: (_, _) => SizedBox(height: 14.h),
                      itemBuilder: (context, index) {
                        final board = filteredBoards[index];
                        return TaskBoardCard(
                          board: board,
                          onTap: () {
                            // Future navigation to board details screen
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
