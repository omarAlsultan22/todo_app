import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/repositories_impl/local/flutter_secure_storage_repository.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late FlutterSecureStorage flutterSecureStorage;
  late FlutterSecureStorageRepository repository;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    flutterSecureStorage = FlutterSecureStorage();
    repository = FlutterSecureStorageRepository(
        flutterSecureStorage: flutterSecureStorage);

    await repository.saveEncryptionKey();

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await repository.saveEncryptionKey();
  }
}