import 'exceptions/unknown_exception.dart';
import 'exceptions/base/app_exception.dart';
import 'exceptions/DatabaseAppException.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';


class ErrorHandler {
  final dynamic error;
  final StackTrace stackTrace;
  late final DatabaseAppException _databaseAppException;

  ErrorHandler({
    required this.error,
    required this.stackTrace
  }) {
    _databaseAppException = DatabaseAppException(error: error);
  }
  AppException handleException() {
    _logError(error, stackTrace);

    if (error is DatabaseException) {
      _databaseAppException.getException();
    }
    if (error.toString().contains('SqfliteFfiException')) {
      return SqliteInitException(
        message: 'FFI layer error. Make sure to add sqlite3_flutter_libs for office projects.',
      );
    }
    if (error is StateError &&
        error.message.contains('databaseFactory') == true) {
      return SqliteInitException(
        message: 'The database is not initialized correctly. Make sure to call sqfliteFfiInit() in office applications.',
      );
    }
    return UnknownException(message: 'Unexpected error: ${error.toString()}');
  }

  void _logError(dynamic error, StackTrace? stackTrace) {
    // For tracking and analytics
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}