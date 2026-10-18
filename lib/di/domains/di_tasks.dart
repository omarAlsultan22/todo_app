import '../../data/repositories_impl/local/encryption_keys_repository_impl.dart';
import 'package:todo_app/data/data_sources/tasks_data_source_impl.dart';
import '../../data/repositories_impl/local/tasks_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/use_cases/tasks_use_case.dart';
import '../../presentation/cubits/tasks_cubit.dart';
import '../../utils/pagination_state_manager.dart';
import '../service _locator.dart';


class TasksDependencies {
  static void register() {
    //DataSource
    sl.registerLazySingleton(() =>
    TasksDataSourceImpl());

    // Repository
    sl.registerLazySingleton(() =>
        EncryptionKeysRepositoryImpl(
            flutterSecureStorage: sl<FlutterSecureStorage>()));

    sl.registerLazySingleton(() =>
        TasksRepositoryImpl(
            dataSource: sl<TasksDataSourceImpl>(),
            encryptionKeysRepository: sl<EncryptionKeysRepositoryImpl>())
    );

    // UseCase
    sl.registerLazySingleton(() =>
        TasksUseCase(
            repository: sl<TasksRepositoryImpl>(),
            paginationHandler: sl<PaginationHandler>()));

    // Cubit
    sl.registerFactory(() =>
        TasksCubit(useCase: sl<TasksUseCase>()));
  }
}