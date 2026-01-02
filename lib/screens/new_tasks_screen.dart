import '../shared/components/widgets/states/error_state.dart';
import '../shared/components/widgets/states/init_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/cubit/tasks_cubit.dart';
import 'package:flutter/cupertino.dart';
import '../shared/states/states.dart';
import '../layout/tasks_layout.dart';


class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksStates>(
      builder: (context, state) {
        return state.when<Widget>(
            initial: () => TasksInitStateWidget(),
            loaded: (data) => TasksLayout(tasks: data!.newTasks),
            error: (error) =>
                TasksErrorStateWidget(error: error,
                    onRetry: () => TasksCubit.get(context).loadTasks()));
      },
    );
  }
}
