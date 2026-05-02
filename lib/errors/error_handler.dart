import 'exceptions/cache_exceptions.dart';
import 'exceptions/unknown_exception.dart';
import 'exceptions/base/app_exception.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';


class ErrorHandler {
  static AppException handleException(dynamic error, {StackTrace? stackTrace}) {
    if (error is DatabaseException ||
        error.toString().contains('SqfliteFfiException') ||
        (error is StateError &&
            error.message.contains('databaseFactory') == true)) {
      return _handleSqliteError(error, stackTrace ?? StackTrace.current);
    }
    return UnknownException(message: error.toString());
  }
  // ==================== معالجة أخطاء SQLite ====================

  static AppException _handleSqliteError(dynamic error, StackTrace? stackTrace) {
    // الحالة 1: خطأ التهيئة (قبل فتح قاعدة البيانات)
    if (error is StateError && error.message.contains('databaseFactory') == true) {
      return SqliteInitException(
        message: 'The database is not initialized correctly. Make sure to call sqfliteFfiInit() in office applications.',
        stackTrace: stackTrace,
      );
    }

    if (error.toString().contains('SqfliteFfiException')) {
      return SqliteInitException(
        message: 'FFI layer error. Make sure to add sqlite3_flutter_libs for office projects.',
        stackTrace: stackTrace,
      );
    }

    // الحالة 2: خطأ SQLite العادي
    if (error is DatabaseException) {
      final code = error.getResultCode();
      final message = error.toString();
      final fullError = '$message (code: $code)';

      // تجميع الأخطاء حسب الكود
      switch (code) {
        case 1: // SQLITE_ERROR
          if (message.toLowerCase().contains('syntax') == true) {
            return SqliteSyntaxException(
              message: 'SQL syntax error. Avoid using reserved words such as "order" or "group". $fullError',
              sqliteErrorCode: code,
              stackTrace: stackTrace,
            );
          }
          break;
        case 8: // SQLITE_READONLY
          return SqliteDatabaseException(
            message: 'Trying to write to a read-only database. Check for file permissions or internal storage issues.',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        case 10: // SQLITE_IOERR
        case 1034: // extension for Disk I/O
          return SqliteDatabaseException(
            message: 'Disk read/write error. Check that the storage is stable and has enough space.',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        case 11: // SQLITE_CORRUPT
          return SqliteDatabaseException(
            message: 'The database file is corrupt. Consider data recovery or app reset.',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        case 13: // SQLITE_FULL
          return SqliteDatabaseException(
            message: 'Storage space is full. Free up some space and try again.',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        case 14: // SQLITE_CANTOPEN
          return SqliteDatabaseException(
            message: 'The database file could not be opened. Check the path and write permissions.',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        case 19: // SQLITE_CONSTRAINT
          return SqliteDatabaseException(
            message: 'Database constraint conflict (eg duplicate primary key or unique violation).',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        case 20: // SQLITE_MISMATCH
          return SqliteDatabaseException(
            message: 'A mismatch in the type of data entered with the type of column in the database.',
            sqliteErrorCode: code,
            stackTrace: stackTrace,
          );
        default:
          break;
      }

      // أي خطأ آخر في قاعدة البيانات
      return SqliteDatabaseException(
        message: 'Database error: $fullError',
        sqliteErrorCode: code,
        stackTrace: stackTrace,
      );
    }

    // الحالة 3: خطأ عام
    return SqliteDatabaseException(
      message: 'Unexpected database error: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }
}
