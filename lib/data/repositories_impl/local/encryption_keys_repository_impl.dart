import 'package:todo_app/security/encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';


class EncryptionKeysRepositoryImpl implements EncryptionKeysRepository {
  final FlutterSecureStorage _storage;
  final String Function() _generateKey;

  EncryptionKeysRepositoryImpl({
  required FlutterSecureStorage flutterSecureStorage,
  String Function()? generateKey,
  })  : _storage = flutterSecureStorage,
  _generateKey = generateKey ?? EncryptionService.generateSecureKey;

  static const encryptionKey = 'encryptionKey';

  @override
  Future<void> saveEncryptionKey() async {
    await _storage.write(
        key: encryptionKey, value: _generateKey());
  }

  @override
  Future<String?> getEncryptionKey() async {
    return await _storage.read(key: encryptionKey);
  }
}