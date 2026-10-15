// ============================================================================
// File: tasks_state.dart
// Description: State definitions for [TasksCubit].
//              Handles loading, success, and error states for task board creation
//              and retrieval operations.
// ============================================================================

import 'package:equatable/equatable.dart';
import '../../data/models/task_board_model.dart';

/// Base abstract class for all task-related states.
abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

/// Initial state when Tasks screen or Cubit is first initialized.
class TasksInitial extends TasksState {
  const TasksInitial();
}

// ----------------------------------------------------------------------------
// Create Board States
// ----------------------------------------------------------------------------

/// Emitted while saving a new board to Firebase Realtime Database.
class CreateBoardLoading extends TasksState {
  const CreateBoardLoading();
}

/// Emitted after a new board has been successfully saved to Firebase RTDB.
class CreateBoardSuccess extends TasksState {
  final TaskBoardModel board;

  const CreateBoardSuccess({required this.board});

  @override
  List<Object?> get props => [board];
}

/// Emitted when an error occurs during board creation.
class CreateBoardError extends TasksState {
  final String message;

  const CreateBoardError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ----------------------------------------------------------------------------
// Fetch Boards States
// ----------------------------------------------------------------------------

/// Emitted when fetching boards from the remote repository.
class TasksLoading extends TasksState {
  const TasksLoading();
}

/// Emitted when boards have been fetched successfully.
class TasksLoaded extends TasksState {
  final List<TaskBoardModel> boards;

  const TasksLoaded({required this.boards});

  @override
  List<Object?> get props => [boards];
}

/// Emitted when fetching boards fails.
class TasksError extends TasksState {
  final String message;

  const TasksError({required this.message});

  @override
  List<Object?> get props => [message];
}
