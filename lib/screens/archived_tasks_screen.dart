import 'package:todo_app/shared/components/widgets/states/error_state.dart';
import '../shared/components/widgets/states/init_state.dart';
import 'package:todo_app/shared/cubit/tasks_cubit.dart';
import 'package:todo_app/shared/states/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../layout/tasks_layout.dart';


class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksStates>(
      builder: (context, state) {
        return state.when<Widget>(
            initial: () => TasksInitStateWidget(),
            loaded: (newData) => TasksLayout(tasks: newData!.archivedTasks),
            error: (error) =>
                TasksErrorStateWidget(error: error,
                    onRetry: () => TasksCubit.get(context).loadTasks()));
      },
    );
  }
}