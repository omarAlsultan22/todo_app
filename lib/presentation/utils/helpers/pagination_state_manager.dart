import 'package:todo_app/data/models/task_model.dart';
import '../../../data/models/category_data.dart';


class PaginationHandler {
  CategoryData updateWithNewData(CategoryData currentData,
      List<TaskModel> newArticles) {
    return currentData.copyWith(
      tasks: [...currentData.tasks, ...newArticles],
      offset: newArticles.isNotEmpty ? currentData.offset + 1 : currentData
          .offset,
      hasMore: newArticles.isNotEmpty,
    );
  }
}