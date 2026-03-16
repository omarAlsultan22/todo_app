abstract class EncryptionKeysRepository {

  Future<void> saveEncryptionKey();

  Future<String?> getEncryptionKey();
}