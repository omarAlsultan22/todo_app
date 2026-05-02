import '../../data/models/category_data.dart';
import '../repositories/data_repository.dart';
import '../../data/models/task_model.dart';


class GetTasksUseCase {
  final DataRepository _repository;

  GetTasksUseCase({required DataRepository repository})
      : _repository = repository;

  Future<CategoryData> execute({
    required int limit,
    required int offset,
    required String status
  }) async {
    try {
      final jsonList = await _repository.getDataFromDatabase(
          limit: limit,
          status: status,
          offset: offset
      );
      final tasksList = jsonList.map((e) => TaskModel.fromJson(e)).toList();
      return tasksList;
    } catch (e) {
      rethrow;
    }
  }
}
