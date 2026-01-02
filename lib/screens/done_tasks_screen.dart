import '../shared/components/widgets/states/error_state.dart';
import '../shared/components/widgets/states/init_state.dart';
import 'package:todo_app/shared/cubit/tasks_cubit.dart';
import 'package:todo_app/shared/states/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../layout/tasks_layout.dart';


class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksStates>(
      builder: (context, state) {
        return state.when<Widget>(
            initial: () => TasksInitStateWidget(),
            loaded: (data) => TasksLayout(tasks: data!.doneTasks),
            error: (error) =>
                TasksErrorStateWidget(error: error,
                    onRetry: () => TasksCubit.get(context).loadTasks()));
      },
    );
  }
}
