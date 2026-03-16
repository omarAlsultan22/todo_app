import '../cubits/tasks_cubit.dart';
import '../states/tasks_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/repositories_impl/local/database_repository.dart';
import 'package:todo_app/presentation/widgets/layouts/home_layout.dart';
import '../../data/repositories_impl/local/flutter_secure_storage_repository.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flutterSecureStorage = FlutterSecureStorage();
    final keysRepository = FlutterSecureStorageRepository(
        flutterSecureStorage: flutterSecureStorage);
    final tasksRepository = TasksRepository(
        repository: keysRepository)
      ..createDatabase();
    return BlocProvider<TasksCubit>(
        create: (BuildContext context) =>
            TasksCubit(repository: tasksRepository),
        child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              return HomeLayout();
            }
        )
    );
  }
}
