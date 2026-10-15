// ============================================================================
// File: get_boards_stream_usecase.dart
// Description: Domain use case for listening to real-time boards stream
//              from [TasksRepository].
// ============================================================================

import '../../data/models/task_board_model.dart';
import '../repositories/tasks_repository.dart';

/// [GetBoardsStreamUseCase] provides a continuous real-time Stream of task boards
/// from the Firebase Realtime Database repository.
class GetBoardsStreamUseCase {
  final TasksRepository repository;

  GetBoardsStreamUseCase({required this.repository});

  Stream<List<TaskBoardModel>> call() {
    return repository.getBoardsStream();
  }
}
