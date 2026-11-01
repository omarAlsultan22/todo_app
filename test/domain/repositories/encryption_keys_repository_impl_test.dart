import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';
import 'package:todo_app/data/repositories_impl/local/encryption_keys_repository_impl.dart';


// Mock للـ FlutterSecureStorage
class MockFlutterSecureStorage extends Mock
    implements FlutterSecureStorage {}

// Mock للـ EncryptionService — لكنه static، لذا لا يمكن تزييفه بـ mocktail
// سنكتفي بالتحقق من النتيجة (المفتاح المولّد نفسه)

void main() {
  late EncryptionKeysRepository repository;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    repository = EncryptionKeysRepositoryImpl(
      flutterSecureStorage: mockStorage,
      generateKey: () => 'fixed-key-for-test',
    );
  });

  group('saveEncryptionKey', () {
    test('writes a non-empty key to secure storage under "encryptionKey"',
            () async {
          // 1. stub الكتابة لتنجح
          when(() =>
              mockStorage.write(
                key: any(named: 'key'),
                value: any(named: 'value'),
              )).thenAnswer((_) async {});

          // 2. استدعِ
          await repository.saveEncryptionKey();

          // 3. تحقق: تم استدعاء write مرة واحدة، بالمفتاح الصحيح، وقيمة غير فارغة
          final captured = verify(() =>
              mockStorage.write(
                key: captureAny(named: 'key'),
                value: captureAny(named: 'value'),
              )).captured;

          expect(captured[0], 'encryptionKey');
          expect(captured[1], isA<String>());
          expect((captured[1] as String).isNotEmpty, true);
        });

    test('generates a different key on each call', () async {
      final captured = <String>[];

      when(() =>
          mockStorage.write(
            key: any(named: 'key'),
            value: captureAny(named: 'value'),
          )).thenAnswer((invocation) async {
        captured.add(invocation.namedArguments[#value] as String);
      });

      await repository.saveEncryptionKey();
      await repository.saveEncryptionKey();

      expect(captured.length, 2);
      expect(captured[0], isNot(captured[1]));
    });

    test('propagates storage write errors', () async {
      when(() =>
          mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenThrow(Exception('storage full'));

      expect(
            () => repository.saveEncryptionKey(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getEncryptionKey', () {
    test('returns the stored key when present', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'stored-key-123');

      final result = await repository.getEncryptionKey();

      expect(result, 'stored-key-123');
      verify(() => mockStorage.read(key: 'encryptionKey')).called(1);
    });

    test('returns null when no key is stored', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await repository.getEncryptionKey();

      expect(result, isNull);
    });

    test('propagates storage read errors', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenThrow(Exception('storage unavailable'));

      expect(
            () => repository.getEncryptionKey(),
        throwsA(isA<Exception>()),
      );
    });
  });
}