import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/models/category_data.dart';
import 'package:todo_app/domain/use_cases/pagination_state_manager.dart';


class FakePaginationHandler implements PaginationHandler {
  CategoryData? resultToReturn;
  int updateCallCount = 0;
  CategoryData? lastCurrentData;
  List<TaskModel>? lastNewTasks;

  @override
  CategoryData updateWithNewData(
      CategoryData currentData,
      List<TaskModel> newArticles,
      ) {
    updateCallCount++;
    lastCurrentData = currentData;
    lastNewTasks = newArticles;
    return resultToReturn ?? currentData;
  }
}