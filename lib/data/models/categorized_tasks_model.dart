import 'package:todo_app/data/models/task_model.dart';


class CategorizedTasks {
  final List<TaskModel> newTasks;
  final List<TaskModel> doneTasks;
  final List<TaskModel> archivedTasks;

  const CategorizedTasks({
    required this.newTasks,
    required this.doneTasks,
    required this.archivedTasks,
  });
}