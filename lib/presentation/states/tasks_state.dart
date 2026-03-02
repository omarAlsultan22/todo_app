import 'package:flutter/widgets.dart';
import '../../data/models/categorized_tasks_model.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';


class TasksState {
  final CategorizedTasks? categorizedTasks;
  final BottomSheetState? bottomSheetState;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  const TasksState({
    this.categorizedTasks,
    this.bottomSheetState,
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
  });

  bool get isVisible => bottomSheetState!.isVisible;

  IconData get icon => bottomSheetState!.icon;

  TasksState copyWith({
    CategorizedTasks? categorizedTasks,
    BottomSheetState? bottomSheetState,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return TasksState(
      categorizedTasks: categorizedTasks ?? this.categorizedTasks,
      bottomSheetState: bottomSheetState ?? this.bottomSheetState,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategorizedTasks? tasks) onLoaded,
    required R Function(String error) onError,
  }) {
    if (error != null) {
      return onError(error!);
    }
    if (categorizedTasks != null) {
      return onLoaded(categorizedTasks!);
    }
    return onInitial();
  }
}