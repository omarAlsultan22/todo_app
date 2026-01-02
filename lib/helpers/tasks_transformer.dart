import '../models/categorized_tasks_model.dart';
import '../models/task_model.dart';


class TasksTransformer {
  static CategorizedTasks categorizeTasks(List<Map<String, dynamic>> jsonList) {
    final tasks = jsonList.map((e) => TaskModel.fromJson(e)).toList();

    final newTasks = tasks.where((t) => t.status == 'new').toList();
    final doneTasks = tasks.where((t) => t.status == 'done').toList();
    final archivedTasks = tasks.where((t) => t.status == 'archived').toList();

    return CategorizedTasks(
      newTasks: newTasks,
      doneTasks: doneTasks,
      archivedTasks: archivedTasks,
    );
  }
}

