import '../di/service _locator.dart';
import '../domain/repositories/encryption_keys_repository.dart';
import 'package:todo_app/errors/exceptions/components_exception.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late EncryptionKeysRepository _repository;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    _repository = sl<EncryptionKeysRepository>();

    try {
      await _repository.saveEncryptionKey();
    }
    catch(e){
      throw ComponentsException(error: e);
    }
    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await _repository.saveEncryptionKey();
  }
}