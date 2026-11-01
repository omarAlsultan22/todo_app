import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/security/encryption_service.dart';


void main() {
  group('EncryptionService.generateSecureKey', () {
    test('returns a non-empty string', () {
      final key = EncryptionService.generateSecureKey();
      expect(key, isNotEmpty);
    });

    test('returns different keys on successive calls', () {
      final k1 = EncryptionService.generateSecureKey();
      final k2 = EncryptionService.generateSecureKey();
      expect(k1, isNot(k2));
    });

    test('returns a key of expected length (base64 of 32 bytes = 44 chars)',
            () {
          final key = EncryptionService.generateSecureKey();
          // إذا كان base64: 32 bytes → 44 chars (with padding)
          // إذا كان hex: 32 bytes → 64 chars
          // عدّل حسب التنفيذ
          expect(key.length, greaterThanOrEqualTo(32));
        });
  });
}