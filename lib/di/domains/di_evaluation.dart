import '../../data/repositories_impl/local/flutter_secure_storage_repository.dart';
import '../../data/repositories_impl/local/database_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/useCases/useCase_operations.dart';
import '../../presentation/cubits/tasks_cubit.dart';
import '../../utils/pagination_state_manager.dart';
import '../service _locator.dart';


class TasksDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FlutterSecureStorageRepository(
            flutterSecureStorage: sl<FlutterSecureStorage>()));

    sl.registerLazySingleton(() =>
        TasksRepository(
            repository: sl<FlutterSecureStorageRepository>()));

    // UseCase
    sl.registerLazySingleton(() =>
        GetTasksUseCase(
            repository: sl<TasksRepository>(),
            paginationHandler: sl<PaginationHandler>()));

    // Cubit
    sl.registerFactory(() =>
        TasksCubit(useCase: sl<GetTasksUseCase>()));
  }
}