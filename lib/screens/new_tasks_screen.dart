import 'package:todo_app/shared/components/components.dart';
import '../shared/local/database/database_states.dart';
import '../shared/local/database/database_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit
              .get(context)
              .newTasks;
          return tasksBuilder(tasks: tasks);
        }
    );
  }
}
