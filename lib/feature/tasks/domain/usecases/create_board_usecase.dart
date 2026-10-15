// ============================================================================
// File: create_board_usecase.dart
// Description: Domain use case for creating a new task board.
//              Encapsulates the business logic and delegates persistence
//              to [TasksRepository].
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/use_case.dart';
import '../../data/models/task_board_model.dart';
import '../repositories/tasks_repository.dart';

/// [CreateBoardUseCase] executes the creation and persistence of a task board.
///
/// Parameters:
/// - [params]: The [TaskBoardModel] containing name, department, description, and date.
///
/// Returns:
/// - [Future<Either<Failures, void>>]: Right(void) on successful save, Left(Failures) on error.
class CreateBoardUseCase implements UseCase<void, TaskBoardModel> {
  final TasksRepository repository;

  CreateBoardUseCase({required this.repository});

  @override
  Future<Either<Failures, void>> call(TaskBoardModel params) async {
    return await repository.createBoard(params);
  }
}
