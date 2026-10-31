import '../../data/models/task_model.dart';


class TaskSorter {
  static int findInsertPosition({
    required List<TaskModel> tasks,
    required TaskModel newTask,
  }) {
    if (tasks.isEmpty) return 0;

    int low = 0;
    int high = tasks.length - 1;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final comparison = _compareTasks(tasks[mid], newTask);

      if (comparison < 0) {
        low = mid + 1;
      } else if (comparison > 0) {
        high = mid - 1;
      } else {
        return mid;
      }
    }
    return low;
  }

  /// مقارنة مهمتين حسب التاريخ والوقت
  ///
  /// 📌 ترجع:
  /// - negative: إذا كانت a قبل b
  /// - zero: إذا كانا متساويين
  /// - positive: إذا كانت a بعد b
  static int _compareTasks(TaskModel a, TaskModel b) {
    // 1. مقارنة التاريخ
    final dateCompare = a.date.compareTo(b.date);
    if (dateCompare != 0) return dateCompare;

    // 2. مقارنة الوقت
    return a.time.compareTo(b.time);
  }
}