import '../../data/repositories_impl/local/encryption_keys_repository_impl.dart';
import 'package:todo_app/data/data_sources/tasks_data_source_impl.dart';
import '../../data/repositories_impl/local/tasks_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/encryption_keys_repository.dart';
import '../../domain/data_sources/tasks_data_source.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../domain/use_cases/tasks_use_case.dart';
import '../../presentation/cubits/tasks_cubit.dart';
import '../../utils/pagination_state_manager.dart';
import '../service _locator.dart';


class TasksDependencies {
  static void register() {
    //DataSource
    sl.registerLazySingleton<TasksDataSource>(() =>
        TasksDataSourceImpl());

    // Repository
    sl.registerLazySingleton<EncryptionKeysRepository>(() =>
        EncryptionKeysRepositoryImpl(
            flutterSecureStorage: sl<FlutterSecureStorage>()));

    sl.registerLazySingleton<TasksRepository>(() =>
        TasksRepositoryImpl(
            dataSource: sl<TasksDataSource>(),
            encryptionKeysRepository: sl<EncryptionKeysRepository>())
    );

    // UseCase
    sl.registerLazySingleton<TasksUseCase>(() =>
        TasksUseCase(
            repository: sl<TasksRepository>(),
            paginationHandler: sl<PaginationHandler>()));

    // Cubit
    sl.registerFactory<TasksCubit>(() =>
        TasksCubit(useCase: sl<TasksUseCase>()));
  }
}