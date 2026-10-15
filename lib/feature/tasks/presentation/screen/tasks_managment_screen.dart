// ============================================================================
// File: tasks_managment_screen.dart
// Description: Main task management screen.
//              Fetches and displays real-time boards from Firebase Realtime Database,
//              renders dynamic category counts in TaskCategoryCell, supports
//              search filtering, and shows an empty state ("Nothing to show yet")
//              when no boards exist.
// ============================================================================

import 'dart:async';
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
import '../../domain/usecases/get_boards_stream_usecase.dart';
import '../../domain/usecases/get_boards_usecase.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../widgets/create_board_bottom_sheet.dart';
import '../widgets/task_action_buttons_row.dart';
import '../widgets/task_board_card.dart';
import '../widgets/task_category_cell.dart';
import '../widgets/task_search_bar.dart';

/// Fallback in-memory repository used when GetIt container has not registered
/// Firebase Realtime Database dependencies (e.g. during standalone widget tests).
class _FallbackTasksRepository implements TasksRepository {
  final List<TaskBoardModel> _boards;
  final StreamController<List<TaskBoardModel>> _controller =
      StreamController<List<TaskBoardModel>>.broadcast();

  _FallbackTasksRepository({List<TaskBoardModel>? initialBoards})
    : _boards = initialBoards != null
          ? List.from(initialBoards)
          : List.from(_getDefaultFallbackBoards());

  @override
  Future<Either<Failures, void>> createBoard(TaskBoardModel board) async {
    _boards.insert(0, board);
    _controller.add(List.unmodifiable(_boards));
    return const Right(null);
  }

  @override
  Future<Either<Failures, List<TaskBoardModel>>> getBoards() async {
    return Right(List.unmodifiable(_boards));
  }

  @override
  Stream<List<TaskBoardModel>> getBoardsStream() async* {
    yield List.unmodifiable(_boards);
    yield* _controller.stream;
  }
}

/// Initial 14 default mock boards used as offline seed data for standalone testing.
List<TaskBoardModel> _getDefaultFallbackBoards() {
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
    TaskBoardModel(
      id: '5',
      name: 'Social Media Campaign',
      department: 'Marketing',
      description: 'Q3 social campaigns across LinkedIn and Twitter.',
      creationDate: '14 Aug 2024',
    ),
    TaskBoardModel(
      id: '6',
      name: 'Brand Guidelines',
      department: 'Marketing',
      description: 'Brand identity system documentation.',
      creationDate: '15 Aug 2024',
    ),
    TaskBoardModel(
      id: '7',
      name: 'SEO Optimization',
      department: 'Marketing',
      description: 'Technical SEO and landing page optimization.',
      creationDate: '18 Aug 2024',
    ),
    TaskBoardModel(
      id: '8',
      name: 'Email Marketing Funnel',
      department: 'Marketing',
      description: 'Drip campaign sequences for user onboarding.',
      creationDate: '20 Aug 2024',
    ),
    TaskBoardModel(
      id: '9',
      name: 'Backend API Gateway',
      department: 'Software',
      description: 'Microservices gateway and authentication routing.',
      creationDate: '22 Aug 2024',
    ),
    TaskBoardModel(
      id: '10',
      name: 'Flutter Design System',
      department: 'Software',
      description: 'Shared reusable component library.',
      creationDate: '24 Aug 2024',
    ),
    TaskBoardModel(
      id: '11',
      name: 'Database Migration',
      department: 'Software',
      description: 'Database indexing and partition strategy.',
      creationDate: '26 Aug 2024',
    ),
    TaskBoardModel(
      id: '12',
      name: 'DevOps CI/CD Pipeline',
      department: 'Software',
      description: 'Automated GitHub actions and test runners.',
      creationDate: '28 Aug 2024',
    ),
    TaskBoardModel(
      id: '13',
      name: 'Tax Compliance & Filing',
      department: 'Finance',
      description: 'End of year tax audit preparation.',
      creationDate: '30 Aug 2024',
    ),
    TaskBoardModel(
      id: '14',
      name: 'Investor Pitch Deck',
      department: 'Finance',
      description: 'Series A financial decks and valuation model.',
      creationDate: '02 Sep 2024',
    ),
  ];
}

/// [TasksManagmentScreen] is the entry view for managing and tracking tasks.
/// Initializes [TasksCubit] and binds it to Firebase Realtime Database.
class TasksManagmentScreen extends StatelessWidget {
  final TasksCubit? cubit;

  const TasksManagmentScreen({super.key, this.cubit});

  TasksCubit _createCubit() {
    if (cubit != null) {
      return cubit!..watchBoards();
    }
    if (di.sl.isRegistered<TasksCubit>()) {
      return di.sl<TasksCubit>()..watchBoards();
    }
    final fallbackRepo = _FallbackTasksRepository();
    return TasksCubit(
      createBoardUseCase: CreateBoardUseCase(repository: fallbackRepo),
      getBoardsUseCase: GetBoardsUseCase(repository: fallbackRepo),
      getBoardsStreamUseCase: GetBoardsStreamUseCase(repository: fallbackRepo),
    )..watchBoards();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksCubit>(
      create: (_) => _createCubit(),
      child: const TasksManagmentView(),
    );
  }
}

/// [TasksManagmentView] renders the task management UI, dynamic category cells,
/// and vertical boards list populated via Firebase Realtime Database.
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

  /// Exposes the active search query.
  String get searchQuery => _searchQuery;

  // --------------------------------------------------------------------------
  // Lifecycle Management
  // --------------------------------------------------------------------------

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
  void _onSearchCleared() {
    setState(() {
      _searchQuery = '';
    });
  }

  // --------------------------------------------------------------------------
  // Dynamic Category Calculation & Filtering
  // --------------------------------------------------------------------------

  /// Checks if a board's department matches a specific category ID.
  bool _matchesDepartment(String department, String categoryId) {
    final dep = department.trim().toLowerCase();
    switch (categoryId) {
      case 'marketing':
        return dep == 'marketing' ||
            dep == LocalStrings.marketing.toLowerCase();
      case 'software':
        return dep == 'software' || dep == LocalStrings.software.toLowerCase();
      case 'finance':
        return dep == 'finance' || dep == LocalStrings.finance.toLowerCase();
      case 'research_and_development':
        return dep.contains('research') ||
            dep.contains('development') ||
            dep.contains('r&d') ||
            dep == LocalStrings.researchAndDevelopment.toLowerCase();
      default:
        return false;
    }
  }

  /// Dynamically computes category counts from the current boards list.
  List<TaskCategoryModel> _getCategories(
    BuildContext context,
    List<TaskBoardModel> allBoards,
  ) {
    final int allCount = allBoards.length;
    final int marketingCount = allBoards
        .where((b) => _matchesDepartment(b.department, 'marketing'))
        .length;
    final int softwareCount = allBoards
        .where((b) => _matchesDepartment(b.department, 'software'))
        .length;
    final int financeCount = allBoards
        .where((b) => _matchesDepartment(b.department, 'finance'))
        .length;
    final int rndCount = allBoards
        .where(
          (b) => _matchesDepartment(b.department, 'research_and_development'),
        )
        .length;

    return [
      TaskCategoryModel(id: 'all', title: LocalStrings.all, count: allCount),
      TaskCategoryModel(
        id: 'marketing',
        title: LocalStrings.marketing,
        count: marketingCount,
      ),
      TaskCategoryModel(
        id: 'software',
        title: LocalStrings.software,
        count: softwareCount,
      ),
      TaskCategoryModel(
        id: 'finance',
        title: LocalStrings.finance,
        count: financeCount,
      ),
      TaskCategoryModel(
        id: 'research_and_development',
        title: LocalStrings.researchAndDevelopment,
        count: rndCount,
      ),
    ];
  }

  /// Filters boards by currently selected category tab and search query string.
  List<TaskBoardModel> _getFilteredBoards(
    List<TaskBoardModel> allBoards,
    List<TaskCategoryModel> categories,
  ) {
    if (_selectedCategoryIndex >= categories.length) {
      _selectedCategoryIndex = 0;
    }
    final activeCategory = categories[_selectedCategoryIndex];

    return allBoards.where((board) {
      // 1. Category Filter
      final bool matchesCategory;
      if (activeCategory.id == 'all') {
        matchesCategory = true;
      } else {
        matchesCategory = _matchesDepartment(
          board.department,
          activeCategory.id,
        );
      }

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

      // 2. Body Section connected to TasksCubit
      body: SafeArea(
        child: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            // Extract boards list based on current state
            final List<TaskBoardModel> allBoards;
            if (state is TasksLoaded) {
              allBoards = state.boards;
            } else if (state is CreateBoardSuccess) {
              allBoards = [state.board];
            } else {
              allBoards = const [];
            }

            // Calculate categories with real item counts
            final categories = _getCategories(context, allBoards);
            final filteredBoards = _getFilteredBoards(allBoards, categories);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // Horizontal Categories Filter List (TaskCategoryCell with dynamic counts)
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
                      // Filter modal (design implemented)
                    },
                    onCreateBoardTap: () async {
                      await CreateBoardBottomSheet.show<TaskBoardModel>(
                        context,
                      );
                    },
                  ),
                ),

                SizedBox(height: 18.h),

                // Vertical Task Boards Content Area
                Expanded(
                  child: _buildBoardsContent(
                    context: context,
                    state: state,
                    filteredBoards: filteredBoards,
                    isDark: isDark,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds the boards content area, handling Loading, Error, Empty, and Success states.
  Widget _buildBoardsContent({
    required BuildContext context,
    required TasksState state,
    required List<TaskBoardModel> filteredBoards,
    required bool isDark,
  }) {
    // 1. Loading State
    if (state is TasksLoading) {
      return Center(
        child: SizedBox(
          width: 32.sp,
          height: 32.sp,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    // 2. Error State
    if (state is TasksError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.sp,
                color: AppColors.redAlert,
              ),
              SizedBox(height: 12.h),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textDark,
                  fontFamily: TextStyles.textLarge.fontFamily,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => context.read<TasksCubit>().watchBoards(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(LocalStrings.refresh),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State ("Nothing to show yet")
    if (filteredBoards.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    // 4. Populated Boards List View
    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      onRefresh: () async {
        await context.read<TasksCubit>().getBoards();
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
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
              // Future navigation to board details
            },
          );
        },
      ),
    );
  }

  /// Renders a dedicated empty state widget with the prompt "Nothing to show yet".
  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE5FFCD),
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: 38.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                LocalStrings.nothingToShowYet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textDark,
                  fontFamily: TextStyles.textLarge.fontFamily,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                LocalStrings.enterBoardDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textMuted,
                  fontFamily: TextStyles.textLarge.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
