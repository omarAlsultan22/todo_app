import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/cubits/tasks_cubit.dart';
import '../domain/useCases/useCase_operations.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import '../data/repositories_impl/local/database_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../presentation/utils/helpers/pagination_state_manager.dart';
import '../data/repositories_impl/local/flutter_secure_storage_repository.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final flutterSecureStorage = FlutterSecureStorage();
    final keysRepository = FlutterSecureStorageRepository(
        flutterSecureStorage: flutterSecureStorage);
    final repository = TasksRepository(
        repository: keysRepository)
      ..createDatabase();
    final paginationHandler = PaginationHandler();
    final useCase = GetTasksUseCase(
        repository: repository, paginationHandler: paginationHandler);
    return BlocProvider<TasksCubit>(
        create: (BuildContext context) =>
        TasksCubit(repository: repository, useCase: useCase)
          ..changeScreen(index: 0),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        )
    );
  }
}