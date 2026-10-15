// ============================================================================
// File: tasks_remote_data_source.dart
// Description: Remote data source implementation using Firebase Realtime Database.
//              Handles direct read/write operations to the 'boards' node in Firebase RTDB.
// ============================================================================

import 'package:firebase_database/firebase_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/task_board_model.dart';

/// Abstract contract for remote tasks data operations.
abstract class TasksRemoteDataSource {
  /// Persists a board into the 'boards' node in Firebase Realtime Database.
  Future<void> createBoard(TaskBoardModel board);

  /// Retrieves all boards from the 'boards' node in Firebase Realtime Database.
  Future<List<TaskBoardModel>> getBoards();

  /// Realtime stream of boards list from Firebase RTDB.
  Stream<List<TaskBoardModel>> getBoardsStream();
}

/// Implementation of [TasksRemoteDataSource] using [FirebaseDatabase].
class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final FirebaseDatabase database;

  TasksRemoteDataSourceImpl({required this.database});

  @override
  Future<void> createBoard(TaskBoardModel board) async {
    try {
      final ref = database.ref('boards').push();
      final generatedId =
          ref.key ?? DateTime.now().millisecondsSinceEpoch.toString();

      final data = board.toMap();
      data['id'] = generatedId;

      await ref.set(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TaskBoardModel>> getBoards() async {
    try {
      final snapshot = await database.ref('boards').get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }
      return _parseBoards(snapshot.value);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<TaskBoardModel>> getBoardsStream() {
    return database.ref('boards').onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) {
        return <TaskBoardModel>[];
      }
      return _parseBoards(snapshot.value);
    });
  }

  /// Parses raw snapshot value into a `List<TaskBoardModel>` safely.
  List<TaskBoardModel> _parseBoards(dynamic rawData) {
    if (rawData == null) return [];
    final List<TaskBoardModel> boards = [];

    if (rawData is Map) {
      rawData.forEach((key, value) {
        if (value is Map) {
          final map = Map<String, dynamic>.from(value);
          boards.add(TaskBoardModel.fromMap(map, id: key.toString()));
        }
      });
    } else if (rawData is List) {
      for (int i = 0; i < rawData.length; i++) {
        final value = rawData[i];
        if (value is Map) {
          final map = Map<String, dynamic>.from(value);
          boards.add(TaskBoardModel.fromMap(map, id: i.toString()));
        }
      }
    }

    // Newest boards first
    return boards.reversed.toList();
  }
}
