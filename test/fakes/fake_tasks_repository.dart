import 'package:flutter/widgets.dart';
import 'package:todo_app/domain/repositories/tasks_repository.dart';


class FakeTasksRepository implements TasksRepository {
  // ===== createDatabase =====
  int createDatabaseCallCount = 0;
  VoidCallback? lastOnLoad;
  Object? createDatabaseError;

  @override
  Future<void> createDatabase(VoidCallback onLoad) async {
    createDatabaseCallCount++;
    lastOnLoad = onLoad;
    if (createDatabaseError != null) throw createDatabaseError!;
    onLoad();  // محاكاة السلوك
  }

  // ===== insertToDatabase =====
  Map<String, Object?> insertResult = {};
  Object? insertError;
  int insertCallCount = 0;
  String? lastTitle;
  String? lastTime;
  String? lastDate;

  @override
  Future<Map<String, Object?>> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    insertCallCount++;
    lastTitle = title;
    lastTime = time;
    lastDate = date;
    if (insertError != null) throw insertError!;
    return insertResult;
  }

  // ===== getTaskPosition =====
  int positionResult = 0;
  Object? positionError;
  int getTaskPositionCallCount = 0;
  String? lastPositionDate;
  String? lastPositionTime;
  String? lastPositionStatus;

  @override
  Future<int> getTaskPosition({
    required String date,
    required String time,
    required String status,
  }) async {
    getTaskPositionCallCount++;
    lastPositionDate = date;
    lastPositionTime = time;
    lastPositionStatus = status;
    if (positionError != null) throw positionError!;
    return positionResult;
  }

  // ===== getDataFromDatabase =====
  List<Map<String, Object?>> getResult = [];
  Object? getError;
  int getDataCallCount = 0;
  int? lastLimit;
  int? lastOffset;
  String? lastStatus;

  @override
  Future<List<Map<String, Object?>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  }) async {
    getDataCallCount++;
    lastLimit = limit;
    lastOffset = offset;
    lastStatus = status;
    if (getError != null) throw getError!;
    return getResult;
  }

  // ===== updateInDatabase =====
  Map<String, Object?> updateResult = {};
  Object? updateError;
  int updateCallCount = 0;
  int? lastUpdateId;
  String? lastUpdateStatus;

  @override
  Future<Map<String, Object?>> updateInDatabase({
    required String status,
    required int id,
  }) async {
    updateCallCount++;
    lastUpdateId = id;
    lastUpdateStatus = status;
    if (updateError != null) throw updateError!;
    return updateResult;
  }

  // ===== deleteFromDatabase =====
  int deleteCallCount = 0;
  int? lastDeleteId;
  Object? deleteError;

  @override
  Future<void> deleteFromDatabase({required int id}) async {
    deleteCallCount++;
    lastDeleteId = id;
    if (deleteError != null) throw deleteError!;
  }
}