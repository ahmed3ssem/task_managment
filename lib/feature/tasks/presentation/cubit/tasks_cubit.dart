// ============================================================================
// File: tasks_cubit.dart
// Description: Presentation Cubit managing task boards state and actions.
//              Handles board creation, form persistence to Firebase RTDB,
//              and list loading/refreshing.
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/usecase/use_case.dart';
import '../../data/models/task_board_model.dart';
import '../../domain/usecases/create_board_usecase.dart';
import '../../domain/usecases/get_boards_usecase.dart';
import 'tasks_state.dart';

/// [TasksCubit] handles task board business logic for the UI layer.
class TasksCubit extends Cubit<TasksState> {
  final CreateBoardUseCase createBoardUseCase;
  final GetBoardsUseCase getBoardsUseCase;

  TasksCubit({required this.createBoardUseCase, required this.getBoardsUseCase})
    : super(const TasksInitial());

  /// Creates a new task board and saves it to Firebase Realtime Database.
  ///
  /// Flow:
  /// 1. Formats the current date (e.g., "15 Oct 2026").
  /// 2. Constructs a [TaskBoardModel] with name, department, description, and date.
  /// 3. Emits [CreateBoardLoading] to display UI progress indicator.
  /// 4. Executes [CreateBoardUseCase].
  /// 5. On success: emits [CreateBoardSuccess] with the created board.
  /// 6. On failure: emits [CreateBoardError] with a descriptive failure message.
  Future<void> createBoard({
    required String name,
    required String department,
    required String description,
    String? creationDate,
  }) async {
    emit(const CreateBoardLoading());

    final formattedDate =
        creationDate ?? DateFormat('d MMM yyyy').format(DateTime.now());

    final newBoard = TaskBoardModel(
      id: '',
      name: name.trim(),
      department: department.trim(),
      description: description.trim(),
      creationDate: formattedDate,
      role: 'Owner',
      additionalMembersCount: 0,
      memberAvatars: const [],
    );

    final result = await createBoardUseCase(newBoard);

    result.fold(
      (failure) => emit(CreateBoardError(message: failure.msg)),
      (_) => emit(CreateBoardSuccess(board: newBoard)),
    );
  }

  /// Fetches all task boards from the remote data source.
  Future<void> getBoards() async {
    emit(const TasksLoading());

    final result = await getBoardsUseCase(NoParams());

    result.fold(
      (failure) => emit(TasksError(message: failure.msg)),
      (boards) => emit(TasksLoaded(boards: boards)),
    );
  }
}
