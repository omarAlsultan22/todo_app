import '../states/tasks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/app_icons.dart';
import 'package:todo_app/utils/position_utils.dart';
import 'package:todo_app/data/models/task_model.dart';
import '../../domain/useCases/useCase_operations.dart';
import 'package:todo_app/data/models/message_result.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/states/app_sub_states.dart';
import '../../errors/exceptions/database/database_operations.dart';
import 'package:todo_app/presentation/mixins/error_handler_mixin.dart';


class TasksCubit extends Cubit<TasksState> with ErrorHandlerMixin {
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
      await _useCase.executeInitializeDatabase(() =>
          loadCurrentTabData(index: 0)
      );
    }
    on InitializationException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) {
            final currentTabData = state.currentTabData;
            final newTabData = currentTabData!.copyWith(subState: ErrorState(
                failure: failure
            ));
            return state.updateTab(state.currentTabIndex, newTabData);
          }
      );
    }
  }

  Future<void> _loadTasks({int limit = 0}) async {
    try {
      final currentTabData = state.currentTabData;

      final tasks = await _useCase.executeGetData(
          limit: _limit - limit,
          status: state.status,
          categoryData: state.currentTabData
      );
      if (tasks.tasksIsEmpty && state.tasksIsEmpty) {
        final newTabData = currentTabData!.copyWith(
            subState: const InitialState());
        emit(
            state.updateTab(
                state.currentTabIndex, newTabData
            )
        );
        return;
      }

      final newTabData = currentTabData!.copyWith(
          subState: const SuccessState());
      emit(
          state.updateTab(
              state.currentTabIndex, newTabData
          )
      );
    }
    catch (e) {
      rethrow;
    }
  }

  void _updateTasks(int id) {
    final newCategoryData = state.deleteTask(id);
    emit(state.updateTab(state.currentTabIndex, newCategoryData));
    if (state.length == _limit - 1) {
      _loadTasks(limit: state.length);
    }
  }

  Future<void> _addNewTask({
    required int index,
    required TaskModel taskModel,
  }) async {
    try {
      // 1. حساب الموقع من قاعدة البيانات
      final position = await _useCase.executeGetTaskPosition(
        taskModel: taskModel,
      );

      // 2. الحصول على البيانات الحالية
      final tabData = state.getTabData(index);
      if (tabData == null) {
        throw TabDataException(index: index);
      }

      final currentTasks = tabData.tasks;

      // 3. حساب الموقع الآمن للإضافة
      final safePosition = PositionUtils.calculateSafePosition(
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
          tasks: updatedTasks, subState: const SuccessState()
      );

      emit(state.updateTab(index, newTabData));
    }
    on TabDataException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  messageResult: MessageResult.error(
                      message: failure.message!
                  )
              )
      );
    }
  }

  Future<void> switchTabAndLoadData({required int index}) async {
    changeTab(index);
    await loadCurrentTabData(index: index);
  }

  void changeTab(int index) {
    if (state.currentTabIndex != index) {
      emit(state.copyWith(currentTabIndex: index));
    }
  }

  Future<void> loadCurrentTabData({required int index}) async {
    if (!state.tasksIsEmpty) return;

    final currentTabData = state.currentTabData;
    emit(state.updateTab(index, currentTabData!));

    final newTabData = currentTabData.copyWith(
        subState: const LoadingState());
    emit(state.updateTab(index, newTabData));

    try {
      await _loadTasks();
    }
    on LoadException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) {
            final newTabData = currentTabData.copyWith(subState: ErrorState(
                failure: failure
            ));
            return state.updateTab(index, newTabData);
          }
      );
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

    on InsertException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  messageResult: MessageResult.error(
                      message: failure.message!
                  )
              )
      );
    }
  }

  Future<void> loadMoreData() async {
    if (!state.hasMore) return;
    try {
      await _loadTasks();
    }
    on LoadException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  messageResult: MessageResult.error(
                      message: failure.message!
                  )
              )
      );
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
        emit(state.copyWith(messageResult: MessageResult.success(
            message: 'Successfully added to $status tasks')));
      }
    }
    on UpdateException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  messageResult: MessageResult.error(
                      message: failure.message!
                  )
              )
      );
    }
  }

  Future<void> deleteData({
    required int id,
  }) async {
    try {
      _updateTasks(id);
      await _useCase.executeDeleteData(id: id);
    }
    on DeleteException catch (e, stackTrace) {
      handleError(
          exception: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  messageResult: MessageResult.error(
                      message: failure.message!
                  )
              )
      );
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
