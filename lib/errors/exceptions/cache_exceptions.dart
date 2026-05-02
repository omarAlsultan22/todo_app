import 'base/app_exception.dart';


/// ==================== الاستثناء الأساسي لجميع أخطاء التخزين المؤقت ====================
abstract class CacheException extends AppException {
  final String? operation;
  final StackTrace? stackTrace;

  const CacheException({
    super.code,
    this.operation,
    this.stackTrace,
    super.statusCode,
    required super.message,
  });
}

// ==================== أخطاء SQLite ====================

/// خطأ عام في قاعدة البيانات (يغلف DatabaseException من sqflite)
class SqliteDatabaseException extends CacheException {
  final int? sqliteErrorCode;

  const SqliteDatabaseException({
    required super.message,
    this.sqliteErrorCode,
    super.code = 'SQLITE_ERROR',
    super.stackTrace,
  });
}

/// خطأ في تهيئة قاعدة بيانات SQLite (مثل StateError أو SqfliteFfiException)
class SqliteInitException extends CacheException {
  const SqliteInitException({
    required super.message,
    super.code = 'SQLITE_INIT_ERROR',
    super.stackTrace,
  });
}

/// خطأ في صياغة SQL (مثل الأخطاء النحوية أو الكلمات المحجوزة)
class SqliteSyntaxException extends SqliteDatabaseException {
  const SqliteSyntaxException({
    required super.message,
    super.sqliteErrorCode,
    super.code = 'SQLITE_SYNTAX_ERROR',
    super.stackTrace,
  });
}