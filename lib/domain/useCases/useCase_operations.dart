import '../../presentation/utils/helpers/pagination_state_manager.dart';
import 'package:todo_app/data/models/category_data.dart';
import '../repositories/data_repository.dart';
import '../../data/models/task_model.dart';


class GetTasksUseCase {
  final DataRepository _repository;
  final PaginationHandler _paginationHandler;

  GetTasksUseCase({
    required DataRepository repository,
    required PaginationHandler paginationHandler})
      : _repository = repository,
        _paginationHandler = paginationHandler;

  Future<TaskModel> executeInsertData({
    required String time,
    required String date,
    required String title
  }) async {
    try {
      final result = await _repository.insertToDatabase(
          title: title, time: time, date: date);
      final taskModel = TaskModel.fromJson(result);
      return taskModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryData> executeGetData({
    required int limit,
    required String status,
    required CategoryData? categoryData
  }) async {
    try {
      final offset = categoryData!.offset + categoryData.length -1;
      final jsonList = await _repository.getDataFromDatabase(
          limit: limit,
          status: status,
          offset: offset
      );
      final tasksList = jsonList.map((e) => TaskModel.fromJson(e)).toList();
      return _paginationHandler.updateWithNewData(categoryData, tasksList);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> executeGetTaskPosition({
    required TaskModel taskModel
  }) async {
    try {
      final position = await _repository.getTaskPosition(
          date: taskModel.date,
          time: taskModel.time,
          status: taskModel.status
      );
      return position;
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel> executeUpdateData({
    required int id,
    required String status
  }) async {
    try {
      final result = await _repository.updateInDatabase(status: status, id: id);
      final taskModel = TaskModel.fromJson(result);
      return taskModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> executeDeleteData({
    required int id,
  }) async {
    try {
      await _repository.deleteFromDatabase(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
