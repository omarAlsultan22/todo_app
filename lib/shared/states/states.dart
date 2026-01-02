import 'package:todo_app/models/ChangeBottomSheetStateModel.dart';
import '../../models/categorized_tasks_model.dart';


class TasksStates {
  final CategorizedTasks? categorizedTasks;
  final BottomSheetState? bottomSheetState;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  const TasksStates({
    this.categorizedTasks,
    this.bottomSheetState,
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
  });

  factory TasksStates.initial() => const TasksStates();

  factory TasksStates.success(CategorizedTasks data, {int index = 0}) =>
      TasksStates(
        categorizedTasks: data,
        currentIndex: index,
        isLoading: false,
      );

  factory TasksStates.failure(String error, {CategorizedTasks? oldData}) =>
      TasksStates(
        categorizedTasks: oldData,
        error: error,
        isLoading: false,
      );

  TasksStates copyWith({
    CategorizedTasks? categorizedTasks,
    BottomSheetState? bottomSheetState,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return TasksStates(
      categorizedTasks: categorizedTasks ?? this.categorizedTasks,
      bottomSheetState: bottomSheetState ?? this.bottomSheetState,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  R when<R>({
    required R Function() initial,
    required R Function(CategorizedTasks? tasks) loaded,
    required R Function(String error) error,
  }) {

    if (this.error != null) {
      return error(this.error!);
    }
    if (categorizedTasks != null) {
      return loaded(categorizedTasks!);
    }
    return initial();
  }
}


class TasksInitialState extends TasksStates {}

class TasksChangeIndexState extends TasksStates {}

class AppChangeBottomNavBarState extends TasksStates {}

class AppCreateDatabaseState extends TasksStates {}

class AppGetDatabaseLoadingState extends TasksStates {}

class AppGetDatabaseState extends TasksStates {}

class AppInsertDatabaseState extends TasksStates {}

class AppUpdateDatabaseState extends TasksStates {}

class AppDeleteDatabaseState extends TasksStates {}

class AppChangeBottomSheetState extends TasksStates {}

class AppErrorDatabaseState extends TasksStates {
  AppErrorDatabaseState({super.error});
}