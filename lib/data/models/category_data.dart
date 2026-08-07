import 'package:todo_app/data/models/task_model.dart';
import '../../presentation/states/base/main_app_sub_state.dart';
import 'package:todo_app/presentation/states/app_sub_states.dart';


class CategoryData {
  final MainAppSubState subState;
  final List<TaskModel> tasks;
  final bool hasMore;
  final int offset;

  const CategoryData({
    this.subState = const InitialState(),
    this.tasks = const [],
    this.hasMore = true,
    this.offset = 0,
  });

  int get length => tasks.length;

  bool get tasksIsEmpty => tasks.isEmpty;

  CategoryData copyWith({
    MainAppSubState? subState,
    List<TaskModel>? tasks,
    bool? hasMore,
    int? offset
  }) {
    return CategoryData(
      tasks: tasks ?? this.tasks,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      subState: subState ?? this.subState,
    );
  }
}