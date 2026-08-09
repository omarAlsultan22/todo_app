import '../service _locator.dart';
import '../../utils/pagination_state_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton(() => PaginationHandler());
    sl.registerLazySingleton(() => FlutterSecureStorage());
  }
}