// ============================================================================
// File: task_board_model.dart
// Description: Data model representing a Task Board / Project Board item.
//              Holds board name, department, description, creation date,
//              ownership role, and member avatar metadata.
// ============================================================================

import 'package:equatable/equatable.dart';

/// [TaskBoardModel] represents a board card in the tasks list.
///
/// Properties:
/// - [id]: Unique identifier of the board.
/// - [name]: The title or name of the board (used for search filtering).
/// - [department]: Associated department (e.g., "Marketing", "Software").
/// - [description]: Short summary of the board objectives.
/// - [creationDate]: Formatted date string indicating when the board was created.
/// - [role]: User's permission role on this board (e.g., "Owner").
/// - [memberAvatars]: List of image URLs or asset paths for assigned members.
/// - [additionalMembersCount]: Additional member count displayed as badge (e.g., +6).
class TaskBoardModel extends Equatable {
  final String id;
  final String name;
  final String department;
  final String description;
  final String creationDate;
  final String role;
  final List<String> memberAvatars;
  final int additionalMembersCount;

  const TaskBoardModel({
    required this.id,
    required this.name,
    required this.department,
    required this.description,
    required this.creationDate,
    this.role = 'Owner',
    this.memberAvatars = const [],
    this.additionalMembersCount = 0,
  });

  /// Factory constructor to parse board data from Firebase Firestore / JSON API.
  factory TaskBoardModel.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    return TaskBoardModel(
      id: id,
      name: map['name'] as String? ?? '',
      department: map['department'] as String? ?? '',
      description: map['description'] as String? ?? '',
      creationDate: map['creationDate'] as String? ?? '',
      role: map['role'] as String? ?? 'Owner',
      memberAvatars:
          (map['memberAvatars'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      additionalMembersCount:
          (map['additionalMembersCount'] as num?)?.toInt() ?? 0,
    );
  }

  /// Converts the model to a map for Firebase / API persistence.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'description': description,
      'creationDate': creationDate,
      'role': role,
      'memberAvatars': memberAvatars,
      'additionalMembersCount': additionalMembersCount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    department,
    description,
    creationDate,
    role,
    memberAvatars,
    additionalMembersCount,
  ];
}
