import 'package:todo_app/core/constants/app_constants.dart';

import '../states/tasks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/helpers/tasks_transformer.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';
import 'package:todo_app/domain/repository/repository.dart';


class TasksCubit extends Cubit<TasksState> {
  final DataRepository _repository;

  TasksCubit({required DataRepository repository})
      : _repository = repository,
        super(const TasksState());

  static TasksCubit get(context) => BlocProvider.of(context);


  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }


  Future<void> insertData({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      _repository.insertToDatabase(
          title: title,
          time: time,
          date: date
      );
      emit(state.copyWith(isLoading: true));
      loadTasks();
    }
    catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }


  Future<void> loadTasks() async {
    try {
      final data = await _repository.getDataFromDatabase();
      final categorizedTasks = TasksTransformer.categorizeTasks(data);
      emit(
          state.copyWith(categorizedTasks: categorizedTasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }


  void updateData({
    required String status,
    required int id
  }) {
    try {
      _repository.updateData(status: status, id: id).then((_) async {
        loadTasks();
      });
    }
    catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }


  void deleteData({
    required int id
  }) {
    try {
      _repository.deleteData(id: id).then((_) async {
        loadTasks();
      });
    }
    catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }


  void toggleBottomSheet({
    required bool isVisible,
    required IconData icon
  }) {
    try {
      final bottomSheetState = BottomSheetState(
        isVisible: isVisible,
        icon: isVisible ? AppConstants.editIcon: Icons.close,
      );
      emit(state.copyWith(bottomSheetState: bottomSheetState));
    }
    catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
