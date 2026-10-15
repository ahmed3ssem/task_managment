// ============================================================================
// File: get_boards_usecase.dart
// Description: Domain use case for retrieving all task boards.
//              Delegates data fetching to [TasksRepository].
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/use_case.dart';
import '../../data/models/task_board_model.dart';
import '../repositories/tasks_repository.dart';

/// [GetBoardsUseCase] retrieves all boards from the remote data source.
class GetBoardsUseCase implements UseCase<List<TaskBoardModel>, NoParams> {
  final TasksRepository repository;

  GetBoardsUseCase({required this.repository});

  @override
  Future<Either<Failures, List<TaskBoardModel>>> call(NoParams params) async {
    return await repository.getBoards();
  }
}
