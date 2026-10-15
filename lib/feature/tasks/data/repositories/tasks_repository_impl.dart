// ============================================================================
// File: tasks_repository_impl.dart
// Description: Repository implementation connecting domain use cases to
//              remote data source (Firebase RTDB) and network monitoring.
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../models/task_board_model.dart';

/// [TasksRepositoryImpl] implements [TasksRepository] using [TasksRemoteDataSource].
class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TasksRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failures, void>> createBoard(TaskBoardModel board) async {
    try {
      await remoteDataSource.createBoard(board);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.message ?? 'Failed to create board'));
    } catch (e) {
      return Left(ServerFailure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<TaskBoardModel>>> getBoards() async {
    try {
      final boards = await remoteDataSource.getBoards();
      return Right(boards);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.message ?? 'Failed to fetch boards'));
    } catch (e) {
      return Left(ServerFailure(msg: e.toString()));
    }
  }

  @override
  Stream<List<TaskBoardModel>> getBoardsStream() {
    return remoteDataSource.getBoardsStream();
  }
}
