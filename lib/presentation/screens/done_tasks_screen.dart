import '../states/states.dart';
import '../cubits/tasks_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/states/tasks_state_widget.dart';
import '../widgets/states/error_state_widget.dart';
import '../widgets/states/initial_state_widget.dart';


class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksStates>(
      builder: (context, state) {
        return state.when<Widget>(
            initial: () => InitialStateWidget(),
            loaded: (data) => TasksStateWidget(tasks: data!.doneTasks),
            error: (error) =>
                ErrorStateWidget(error: error,
                    onRetry: () => TasksCubit.get(context).loadTasks()));
      },
    );
  }
}
