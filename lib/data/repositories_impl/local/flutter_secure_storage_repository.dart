import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';
import 'package:todo_app/presentation/utils/helpers/encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class FlutterSecureStorageRepository extends EncryptionKeysRepository {
  final FlutterSecureStorage _flutterSecureStorage;

  FlutterSecureStorageRepository({required FlutterSecureStorage flutterSecureStorage})
      : _flutterSecureStorage = flutterSecureStorage;

  @override
  Future<void> saveEncryptionKey() async {
    final encryptionValue = EncryptionService.generateSecureKey();
    await _flutterSecureStorage.write(
        key: 'encryptionKey', value: encryptionValue);
  }

  @override
  Future<String?> getEncryptionKey() async {
    return await _flutterSecureStorage.read(key: 'encryptionKey');
  }
}