import 'package:todo_app/data/models/task_model.dart';


class CategoryData {
  final List<TaskModel> tasks;
  final bool hasMore;
  final int offset;

  const CategoryData({
    this.tasks = const [],
    this.hasMore = true,
    this.offset = 0,
  });

  int get length => tasks.length;

  bool get productsIsNotEmpty => tasks.isNotEmpty;

  CategoryData copyWith({
    List<TaskModel>? tasks,
    bool? hasMore,
    int? offset
  }) {
    return CategoryData(
        tasks: tasks ?? this.tasks,
        hasMore: hasMore ?? this.hasMore,
        offset: offset ?? this.offset
    );
  }
}