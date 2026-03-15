import 'package:todo_app/presentation/utils/helpers/encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class EncryptionKeysStore {
  static const secureStorage = FlutterSecureStorage();

  static Future<void> saveEncryptionKey() async {
    final encryptionValue = EncryptionService.generateSecureKey();
    await secureStorage.write(key: 'encryptionKey', value: encryptionValue);
  }

  static Future<String?> getEncryptionKey() async {
    return await secureStorage.read(key: 'encryptionKey');
  }
}