import '../di/service _locator.dart';
import '../data/repositories_impl/local/flutter_secure_storage_repository.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late FlutterSecureStorageRepository _repository;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    _repository = sl<FlutterSecureStorageRepository>();

    await _repository.saveEncryptionKey();

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await _repository.saveEncryptionKey();
  }
}