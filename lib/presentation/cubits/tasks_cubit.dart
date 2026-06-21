import '../states/tasks_state.dart';
import 'package:flutter/material.dart';
import '../../errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/app_icons.dart';
import '../../domain/useCases/useCase_operations.dart';
import '../../domain/repositories/data_repository.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/states/app_sub_states.dart';


class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase _useCase;
  final DataRepository _repository;

  TasksCubit({
    required GetTasksUseCase useCase,
    required DataRepository repository,
  })
      : _useCase = useCase,
        _repository = repository,
        super(TasksState.initial());

  static TasksCubit get(context) => BlocProvider.of(context);

  static const _limit = UiSizes.defaultPageSize;

  Future<void> _loadTasks({int limit = 0, int? length}) async {
    final tasks = await _useCase.execute(
        length: length,
        limit: _limit - limit,
        status: state.status,
        categoryData: state.currentTabData
    );
    if (tasks.productsIsNotEmpty || state.tasksIsNotEmpty) {
      emit(
          state.updateTab(state.currentTabIndex, tasks)
              .copyWith(subState: SuccessState()));
      return;
    }
    emit(state.copyWith(subState: InitialState()));
  }

  Future<void> _errorHandler(Object e, StackTrace stackTrace) async {
    final errorHandler = ErrorHandler(
        error: e,
        stackTrace: stackTrace
    );
    final exception = errorHandler.handleException();
    emit(state.copyWith(subState: ErrorState(failure: exception)));
  }

  void _updateTasks(int id) {
    final newCategoryData = state.deleteTask(id);
    emit(state.updateTab(state.currentTabIndex, newCategoryData));
    if (state.length == _limit - 1) {
      _loadTasks(limit: state.length);
    }
  }

  Future<void> changeScreen({required int index}) async {
    emit(state.copyWith(currentTabIndex: index, subState: SuccessState()));
    if (state.length >= 15) return;

    if (!state.tasksIsNotEmpty) {
      emit(state.copyWith(subState: LoadingState()));
    }

    try {
      await _loadTasks();
    }
    catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> insertData({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      await _repository.insertToDatabase(
          title: title,
          time: time,
          date: date
      );
      _loadTasks(length: 0);
      /*
      final newTask = TaskModel(
          status: 'new',
          title: title,
          time: time,
          date: date,
          id: 0
      );
      final position = TaskSorter.findInsertPosition(
          tasks: state.tasks, newTask: newTask);
      if (position == state.length - 1 && state.length == _limit) {
        emit(state.copyWith(messageResult: MessageResult.success(
            message: 'The task has been added successfully')));
        return;
      }
      if (!state.tasksIsNotEmpty) {
        _loadTasks();
        return;
      }
      final newCategoryData = state.insertNewTask(position, newTask);
      emit(state.updateTab(state.currentTabIndex, newCategoryData));
      */
    }
    catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> loadMoreData() async {
    if (!state.hasMore) return;
    try {
      await _loadTasks();
    }
    catch (e) {
      Future.delayed(const Duration(seconds: 3), () {
        loadMoreData();
      });
    }
  }

  Future<void> updateData({
    required int id,
    required String status,
  }) async {
    try {
      if (status != state.status) {
        await _repository.updateInDatabase(status: status, id: id);
        _updateTasks(id);
      }
    }
    catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> deleteData({
    required int id,
  }) async {
    try {
      await _repository.deleteFromDatabase(id: id);
      _updateTasks(id);
    }
    catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  void toggleBottomSheet({
    required bool isVisible,
  }) {
    final bottomSheetState = BottomSheetState(
      isVisible: isVisible,
      icon: isVisible ? Icons.add : AppIcons.editIcon,
    );
    emit(state.copyWith(bottomSheetState: bottomSheetState));
  }
}
