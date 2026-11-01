import 'package:flutter/widgets.dart';
import 'package:todo_app/domain/data_sources/tasks_data_source.dart';


class FakeTasksDataSource implements TasksDataSource {
  // ===== createDatabase =====
  String? lastPassword;
  VoidCallback? lastOnLoad;
  int createDatabaseCallCount = 0;

  // ===== insertToDatabase =====
  Map<String, Object?> insertResult = {'id': 1, 'title': 't'};
  Object? insertError;

  // ===== getTaskPosition =====
  int positionResult = 0;

  // ===== getDataFromDatabase =====
  List<Map<String, Object?>> getResult = [];
  Object? getError;

  // ===== updateInDatabase =====
  Map<String, Object?> updateResult = {'id': 1, 'status': 'done'};

  // ===== deleteFromDatabase =====
  int deleteCallCount = 0;
  int? lastDeleteId;
  Object? deleteError;

  @override
  Future<void> createDatabase({
    String? password,
    required VoidCallback onLoad,
    String databasePath = 'todo.db',
  }) async {
    createDatabaseCallCount++;
    lastPassword = password;
    lastOnLoad = onLoad;
    onLoad(); // محاكاة السلوك الحقيقي (استدعاء onLoad عند الفتح)
  }

  @override
  Future<Map<String, Object?>> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    if (insertError != null) throw insertError!;
    return insertResult;
  }

  @override
  Future<int> getTaskPosition({
    required String date,
    required String time,
    required String status,
  }) async => positionResult;

  @override
  Future<List<Map<String, Object?>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  }) async {
    if (getError != null) throw getError!;
    return getResult;
  }

  @override
  Future<Map<String, Object?>> updateInDatabase({
    required String status,
    required int id,
  }) async => updateResult;

  @override
  Future<void> deleteFromDatabase({required int id}) async {
    deleteCallCount++;
    lastDeleteId = id;
    if (deleteError != null) throw deleteError!;
  }
}