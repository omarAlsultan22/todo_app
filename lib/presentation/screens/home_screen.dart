import '../cubits/tasks_cubit.dart';
import '../states/tasks_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/useCases/useCase_operations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/repositories_impl/local/database_repository.dart';
import 'package:todo_app/presentation/widgets/layouts/home_layout.dart';
import '../../data/repositories_impl/local/flutter_secure_storage_repository.dart';
import 'package:todo_app/presentation/utils/helpers/pagination_state_manager.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              final cubit = TasksCubit.get(context);
              return HomeLayout(
                currentIndex: state.currentTabIndex,
                isVisible: state.isVisible,
                icon: state.icon,
                insertData: ({
                  required title,
                  required time,
                  required date,
                  required context}) =>
                    cubit.insertData(title: title,
                        time: time,
                        date: date,
                        context: context),
                onChange: (index) => cubit.changeScreen(index: index),
                toggleBottomSheet: ({
                  required isVisible,
                  required icon}) =>
                    cubit.toggleBottomSheet(isVisible: isVisible, icon: icon),
              );
            }
        )
    );
  }
}
