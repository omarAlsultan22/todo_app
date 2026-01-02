import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/states/states.dart';


abstract class CubitInterfaces extends Cubit<TasksStates> {
  CubitInterfaces() : super(TasksInitialState());

  static CubitInterfaces get(context) => BlocProvider.of(context);

  void changeIndex(int currentIndex);

  Future<void> loadTasks();

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  });
}