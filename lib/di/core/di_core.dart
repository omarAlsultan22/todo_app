import '../service _locator.dart';
import '../../domain/use_cases/pagination_state_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton<PaginationHandler>(() => PaginationHandler());
    sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  }
}