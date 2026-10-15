// ============================================================================
// File: tasks_repository.dart
// Description: Domain repository interface for task management operations.
//              Defines the abstract contracts for creating and fetching boards
//              independent of data sources (Firebase Realtime Database, REST, etc.).
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/task_board_model.dart';

/// [TasksRepository] defines the domain contract for managing task boards.
/// Follows Clean Architecture principles by isolating business rules from data persistence.
abstract class TasksRepository {
  /// Persists a new [TaskBoardModel] into Firebase Realtime Database.
  /// Returns [Right(void)] on success or [Left(Failures)] on error.
  Future<Either<Failures, void>> createBoard(TaskBoardModel board);

  /// Retrieves the list of task boards from the remote data source.
  /// Returns [Right(List<TaskBoardModel>)] on success or [Left(Failures)] on error.
  Future<Either<Failures, List<TaskBoardModel>>> getBoards();

  /// Realtime stream of task boards from Firebase Realtime Database.
  Stream<List<TaskBoardModel>> getBoardsStream();
}
