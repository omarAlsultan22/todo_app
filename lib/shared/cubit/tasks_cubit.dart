import 'package:todo_app/models/ChangeBottomSheetStateModel.dart';
import '../local/repository/DatabaseRepository.dart';
import 'package:todo_app/shared/states/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helpers/tasks_transformer.dart';
import 'package:flutter/material.dart';


class TasksCubit extends Cubit<TasksStates> {
  final TasksRepository repository;

  TasksCubit(this.repository) : super(TasksStates.initial());

  static TasksCubit get(context) => BlocProvider.of(context);


  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }


  Future<void> loadTasks() async {
    try {
      final data = await repository.getDataFromDatabase();
      final categorizedTasks = TasksTransformer.categorizeTasks(data);
      emit(TasksStates.success(categorizedTasks));
    } catch (e) {
      emit(TasksStates.failure(e.toString()));
    }
  }


  void updateData({
    required String status,
    required int id
  }) {
    try {
      repository.updateData(status: status, id: id).then((_) async {
        loadTasks();
      });
    }
    catch (e) {
      emit(TasksStates.failure(e.toString()));
    }
  }


  void deleteData({
    required int id
  }) {
    try {
      repository.deleteData(id: id).then((_) async {
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
        icon: isVisible ? Icons.edit : Icons.close,
      );
      emit(state.copyWith(bottomSheetState: bottomSheetState));
    }
    catch (e) {
      emit(TasksStates.failure(e.toString()));
    }
  }
}
