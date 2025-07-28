import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/local/database/database_states.dart';
import '../shared/components/components.dart';
import '../shared/local/database/database_cubit.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit
              .get(context)
              .doneTasks;
          return tasksBuilder(tasks: tasks);
        }
    );
  }
}
