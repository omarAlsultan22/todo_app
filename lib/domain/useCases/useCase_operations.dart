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

  Future<CategoryData> execute({
    int? length,
    required int limit,
    required String status,
    required CategoryData? categoryData
  }) async {
    try {
      final currentLength = length ?? categoryData!.length;
      final offset = categoryData!.offset + currentLength;
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
}
