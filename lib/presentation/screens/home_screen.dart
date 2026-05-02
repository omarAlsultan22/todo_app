import '../cubits/tasks_cubit.dart';
import '../states/tasks_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/app_sizes.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/constants/ui_strings.dart';
import 'package:todo_app/domain/useCases/useCase_operations.dart';
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
    final repository = TasksRepository(
        repository: keysRepository)
      ..createDatabase()
      ..getDataFromDatabase(
          offset: AppSizes.none,
          status: UIStrings.newStatus,
          limit: UISizes.defaultPageSize
      );
    final useCase = GetTasksUseCase(repository: repository);
    return BlocProvider<TasksCubit>(
        create: (BuildContext context) =>
            TasksCubit(repository: repository, useCase: useCase),
        child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              return HomeLayout(
                  currentIndex: state.currentTabIndex,
                  isVisible: state.isVisible,
                  icon: state.icon
              );
            }
        )
    );
  }
}
