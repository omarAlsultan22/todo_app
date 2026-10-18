import 'package:flutter/widgets.dart';
import '../../data/models/task_model.dart';
import '../repositories/tasks_repository.dart';
import '../../utils/pagination_state_manager.dart';
import 'package:todo_app/data/models/category_data.dart';


class TasksUseCase {
  final TasksRepository _repository;
  final PaginationHandler _paginationHandler;

  TasksUseCase({
    required TasksRepository repository,
    required PaginationHandler paginationHandler})
      : _repository = repository,
        _paginationHandler = paginationHandler;

  Future<void> executeInitializeDatabase(VoidCallback onLoad) async {
      await _repository.createDatabase(() => onLoad());
  }

  Future<TaskModel> executeInsertData({
    required String time,
    required String date,
    required String title
  }) async {
      final result = await _repository.insertToDatabase(
          title: title, time: time, date: date);
      final taskModel = TaskModel.fromJson(result);
      return taskModel;
  }

  Future<CategoryData> executeGetData({
    required int limit,
    required String status,
    required CategoryData? categoryData
  }) async {
      final offset = categoryData!.offset + categoryData.length -1;
      final jsonList = await _repository.getDataFromDatabase(
          limit: limit,
          status: status,
          offset: offset
      );
      final tasksList = jsonList.map((e) => TaskModel.fromJson(e)).toList();
      return _paginationHandler.updateWithNewData(categoryData, tasksList);
  }

  Future<int> executeGetTaskPosition({
    required TaskModel taskModel
  }) async {
      final position = await _repository.getTaskPosition(
          date: taskModel.date,
          time: taskModel.time,
          status: taskModel.status
      );
      return position;
  }

  Future<TaskModel> executeUpdateData({
    required int id,
    required String status
  }) async {
      final result = await _repository.updateInDatabase(status: status, id: id);
      final taskModel = TaskModel.fromJson(result);
      return taskModel;
  }

  Future<void> executeDeleteData({
    required int id,
  }) async {
      await _repository.deleteFromDatabase(id: id);
  }
}
