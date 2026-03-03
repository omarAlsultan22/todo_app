import '../states/tasks_state.dart';
import '../cubits/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/states/tasks_state_widget.dart';
import '../widgets/states/error_state_widget.dart';
import '../widgets/states/initial_state_widget.dart';


class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return state.when<Widget>(
            onInitial: () => const InitialStateWidget(),
            onLoading: () => const CircularProgressIndicator(),
            onLoaded: (newData) => TasksStateWidget(tasks: newData!.archivedTasks),
            onError: (error) =>
                ErrorStateWidget(error: error,
                    onRetry: () => TasksCubit.get(context).loadTasks()));
      },
    );
  }
}
