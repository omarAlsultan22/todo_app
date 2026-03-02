import '../cubits/tasks_cubit.dart';
import '../states/tasks_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository_impl/local/database_repository.dart';
import 'package:todo_app/presentation/widgets/layouts/home_layout.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = TasksRepository()
      ..createDatabase();
    return BlocProvider<TasksCubit>(
        create: (BuildContext context) =>
            TasksCubit(repository: repository),
        child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              return HomeLayout();
            }
        )
    );
  }
}
