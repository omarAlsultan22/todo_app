import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:todo_app/errors/exceptions/base/app_exception.dart';


class DatabaseAppException extends AppException {
  DatabaseAppException({
    required super.error
  });

  static const String _diskReadWriteError =
      'Disk read/write error. Check that the storage is stable and has enough space.';

  static final Map<int, AppException Function(DatabaseException)> _sqlMap = {
    1: (error) {
      return SqliteSyntaxException(
          message: 'SQL syntax error. Avoid using reserved words such as "order" or "group". ${error.toString()}',
          sqliteErrorCode: error.getResultCode());
    },
    8: (error) =>
        SqliteDatabaseException(
          message: 'Trying to write to a read-only database. Check for file permissions or internal storage issues.',
          sqliteErrorCode: error.getResultCode(),
        ),
    10: (error) =>
        SqliteDatabaseException(
          message: _diskReadWriteError,
          sqliteErrorCode: error.getResultCode(),
        ),
    11: (error) =>
        SqliteDatabaseException(
          message: 'The database file is corrupt. Consider data recovery or app reset.',
          sqliteErrorCode: error.getResultCode(),
        ),
    13: (error) =>
        SqliteDatabaseException(
          message: 'Storage space is full. Free up some space and try again.',
          sqliteErrorCode: error.getResultCode(),
        ),
    14: (error) =>
        SqliteDatabaseException(
          message: 'The database file could not be opened. Check the path and write permissions.',
          sqliteErrorCode: error.getResultCode(),
        ),
    19: (error) =>
        SqliteDatabaseException(
          message: 'Database constraint conflict (eg duplicate primary key or unique violation).',
          sqliteErrorCode: error.getResultCode(),
        ),
    20: (error) =>
        SqliteDatabaseException(
          message: 'A mismatch in the type of data entered with the type of column in the database.',
          sqliteErrorCode: error.getResultCode(),
        ),
    1034: (error) =>
        SqliteDatabaseException(
          message: _diskReadWriteError,
          sqliteErrorCode: error.getResultCode(),
        ),
  };

  int? _getSqliteCode() {
    return (error as DatabaseException).getResultCode();
  }

  String _getErrorMessage() {
    return (error as DatabaseException).toString();
  }

  String _getFullError() {
    final code = _getSqliteCode();
    final msg = _getErrorMessage();
    return code != null ? '$msg (code: $code)' : msg;
  }

  AppException getException() {
    final isKeyFound = _sqlMap.containsKey(_getSqliteCode());
    if (isKeyFound) {
      return _sqlMap[error]!(error);
    }

    return SqliteDatabaseException(
      message: 'Database error: ${_getFullError()}',
      sqliteErrorCode: _getSqliteCode(),
    );
  }
}


class SqliteDatabaseException extends AppException {
  final int? sqliteErrorCode;

  const SqliteDatabaseException({
    required super.message,
    this.sqliteErrorCode,
    super.code = 'SQLITE_ERROR',
  });
}

class SqliteInitException extends AppException {
  const SqliteInitException({
    required super.message,
    super.code = 'SQLITE_INIT_ERROR',
  });
}

class SqliteSyntaxException extends SqliteDatabaseException {
  const SqliteSyntaxException({
    required super.message,
    super.sqliteErrorCode,
    super.code = 'SQLITE_SYNTAX_ERROR',
  });
}
