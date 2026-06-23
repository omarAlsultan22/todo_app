import '../states/tasks_state.dart';
import 'package:flutter/material.dart';
import '../../errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/app_icons.dart';
import 'package:todo_app/data/models/task_model.dart';
import '../../domain/useCases/useCase_operations.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/states/app_sub_states.dart';


class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase _useCase;

  TasksCubit({
    required GetTasksUseCase useCase,
  })
      : _useCase = useCase,
        super(TasksState.initial()) {
    _initializeDatabase();
  }

  static TasksCubit get(context) => BlocProvider.of(context);

  static const _limit = UiSizes.defaultPageSize;

  Future<void> _initializeDatabase() async {
    try {
      await _useCase.executeInitializeDatabase(() => changeScreen(index: 0));
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> _loadTasks({int limit = 0}) async {
    final tasks = await _useCase.executeGetData(
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

  int _calculateSafePosition({
    required int position,
    required int tasksLength,
  }) {
    if (tasksLength == 0) {
      return 0;
    }

    if (position >= 0 && position <= tasksLength) {
      return position;
    }

    if (position < 0) {
      print('⚠️ Position ($position) < 0, adding at beginning');
      return 0;
    }
    return tasksLength;
  }

  Future<void> _addNewTask({
    required int index,
    required TaskModel taskModel,
  }) async {
    // 1. حساب الموقع من قاعدة البيانات
    final position = await _useCase.executeGetTaskPosition(
      taskModel: taskModel,
    );

    // 2. الحصول على البيانات الحالية
    final tabData = state.getTabData(index);
    if (tabData == null) {
      throw Exception('Tab data not found for index: $index');
    }

    final currentTasks = tabData.tasks;

    // 3. حساب الموقع الآمن للإضافة
    final safePosition = _calculateSafePosition(
      position: position,
      tasksLength: currentTasks.length,
    );

    if (currentTasks.length >= _limit && currentTasks.length < safePosition) {
      return;
    }

    // 4. إضافة المهمة في الموقع الآمن
    final updatedTasks = state.insertTaskByPosition(
        position, currentTasks, taskModel);
    // 5. تحديث الحالة
    final newTabData = tabData.copyWith(
      tasks: updatedTasks,
    );

    state.updateTab(index, newTabData);
    emit(state.copyWith(subState: SuccessState()));
  }

  Future<void> changeScreen({required int index}) async {
    emit(state.copyWith(
        currentTabIndex: index));

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
    int index = 0
  }) async {
    try {
      final newTask = await _useCase.executeInsertData(
          title: title,
          time: time,
          date: date
      );
      _addNewTask(index: index, taskModel: newTask);
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
    required int index,
    required String status,
  }) async {
    try {
      if (status != state.status) {
        final taskModel = await _useCase.executeUpdateData(
            status: status, id: id);
        _updateTasks(id);
        _addNewTask(index: index, taskModel: taskModel);
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
      await _useCase.executeDeleteData(id: id);
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
