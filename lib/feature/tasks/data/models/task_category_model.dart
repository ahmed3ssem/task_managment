// ============================================================================
// File: task_category_model.dart
// Description: Data model representing a task category filter tab.
//              Holds category identifier, localized title, and task count badge.
// ============================================================================

import 'package:equatable/equatable.dart';

/// [TaskCategoryModel] represents a category filter displayed on the task management screen.
///
/// Properties:
/// - [id]: Unique category identifier (e.g., 'all', 'marketing', 'software').
/// - [title]: The localized display name (translated via LocalStrings).
/// - [count]: Total number of tasks associated with this category.
class TaskCategoryModel extends Equatable {
  /// Unique identifier used for backend filtering (e.g., in Firebase queries).
  final String id;

  /// Localized category name displayed in the UI.
  final String title;

  /// Total count of tasks belonging to this category.
  final int count;

  const TaskCategoryModel({
    required this.id,
    required this.title,
    required this.count,
  });

  /// Factory constructor to parse category data from map/JSON when integrating APIs/Firebase.
  factory TaskCategoryModel.fromMap(
    Map<String, dynamic> map, {
    required String localizedTitle,
  }) {
    return TaskCategoryModel(
      id: map['id'] as String? ?? '',
      title: localizedTitle,
      count: (map['count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Equatable props for value comparison and unit test assertions.
  @override
  List<Object?> get props => [id, title, count];
}
