import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import '../shared/local/database/database_cubit.dart';
import '../shared/local/database/database_states.dart';


class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit
            .get(context)
            .archivedTasks;
        return tasksBuilder(
            tasks: tasks
        );
      },
    );
  }
}