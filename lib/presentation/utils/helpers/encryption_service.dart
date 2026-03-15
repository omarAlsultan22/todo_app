import 'dart:math';


class EncryptionService {
  static String generateSecureKey() {
    // توليد مفتاح عشوائي آمن - 64 حرف hex (32 بايت)
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}