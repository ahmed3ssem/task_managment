// ============================================================================
// File: tasks_managment_screen.dart
// Description: Main task management screen.
//              Features a centered AppBar, horizontal scrolling category filter cells,
//              and a rounded search bar for filtering tasks by name.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';
import '../../data/models/task_category_model.dart';
import '../../data/models/task_board_model.dart';
import '../widgets/task_category_cell.dart';
import '../widgets/task_search_bar.dart';
import '../widgets/task_action_buttons_row.dart';
import '../widgets/task_board_card.dart';

/// [TasksManagmentScreen] is the entry view for managing and tracking tasks.
///
/// UI Structure & Responsibilities:
/// 1. AppBar: Centered localized title ("Task Management" / "إدارة المهام")
///    styled to adapt seamlessly across light and dark themes.
/// 2. Categories Filter (Horizontal ListView): Renders category filter pills with
///    45x45 badges displaying count and title. Selection filters task lists.
/// 3. Search Bar: 8px rounded search input allowing real-time searching by task_name,
///    with clear action resetting the search query to fetch all tasks.
/// 4. (Upcoming) Tasks Content Area: Will host the tasks list connected to Firebase/Cubit.
class TasksManagmentScreen extends StatefulWidget {
  const TasksManagmentScreen({super.key});

  @override
  State<TasksManagmentScreen> createState() => _TasksManagmentScreenState();
}

class _TasksManagmentScreenState extends State<TasksManagmentScreen> {
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

  // --------------------------------------------------------------------------
  // Lifecycle Management
  // --------------------------------------------------------------------------

  @override
  void dispose() {
    // Dispose the search text controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // State Transition & Search Handlers
  // --------------------------------------------------------------------------

  /// Handles search query updates as user types in the search bar.
  /// When task list / Cubit is connected, dispatch a FilterTasksByName event here.
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    // Future Cubit integration:
    // context.read<TasksCubit>().searchTasks(query: query, categoryId: activeCategoryId);
  }

  /// Triggered when the close ('X') button is tapped in the search bar.
  /// Resets the search query to an empty string to restore the full task list.
  void _onSearchCleared() {
    setState(() {
      _searchQuery = '';
    });
    // Future Cubit integration:
    // context.read<TasksCubit>().resetSearchFilter();
  }

  // --------------------------------------------------------------------------
  // Data Source & Categories
  // --------------------------------------------------------------------------

  /// Returns the localized categories list.
  /// In subsequent phases, category counts will be dynamically populated from Firebase.
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

  /// Returns the complete list of task boards.
  /// In subsequent phases, this will be fetched dynamically via TasksCubit from Firebase.
  List<TaskBoardModel> _getAllBoards() {
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
    final allBoards = _getAllBoards();
    final activeCategory = categories[_selectedCategoryIndex];

    return allBoards.where((board) {
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
                      // Future Cubit integration:
                      // context.read<TasksCubit>().selectCategory(category.id);
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 18.h),

            // Search Bar Component (15px rounded corners, search icon, clear button)
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
                onCreateBoardTap: () {
                  // Design only now: opens Create Board bottom dialog later
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
