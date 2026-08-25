import 'exceptions/unknown_exception.dart';
import 'exceptions/base/app_exception.dart';
import 'exceptions/components_exception.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'exceptions/database/database_app_exception.dart';


class ErrorHandler {
  final dynamic error;
  final String operationType;
  final StackTrace stackTrace;
  late final DatabaseAppException _databaseAppException;

  ErrorHandler({
    required this.error,
    required this.stackTrace,
    required this.operationType
  }) {
    _databaseAppException = DatabaseAppException(operationType: operationType);
  }

  AppException handleException() {
    _logError(error, stackTrace);

    if (error is DatabaseException) {
      return _databaseAppException.getException();
    }
    if (operationType == 'components') {
      return ComponentsException();
    }
    return UnknownException(
        message: 'An unexpected error occurred. Please try again');
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