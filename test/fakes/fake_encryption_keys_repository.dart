import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';


class FakeEncryptionKeysRepository implements EncryptionKeysRepository {
  String? keyToReturn;
  int getCallCount = 0;
  Object? getError;

  FakeEncryptionKeysRepository({this.keyToReturn});

  @override
  Future<void> saveEncryptionKey() async {}

  @override
  Future<String?> getEncryptionKey() async {
    getCallCount++;
    if (getError != null) throw getError!;
    return keyToReturn;
  }
}