import '../states/states.dart';
import '../cubits/tasks_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/states/error_state_widget.dart';
import '../widgets/states/initial_state_widget.dart';
import '../widgets/states/tasks_state_widget.dart';


class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksStates>(
      builder: (context, state) {
        return state.when<Widget>(
            initial: () => InitialStateWidget(),
            loaded: (newData) => TasksStateWidget(tasks: newData!.archivedTasks),
            error: (error) =>
                ErrorStateWidget(error: error,
                    onRetry: () => TasksCubit.get(context).loadTasks()));
      },
    );
  }
}
