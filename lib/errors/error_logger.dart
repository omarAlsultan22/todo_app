import 'exceptions/base/app_exception.dart';


class ErrorLogger {
  final AppException exception;
  final StackTrace stackTrace;

  ErrorLogger({
    required this.exception,
    required this.stackTrace,
  });

  AppException logAndReturn() {
    _logError(exception.error, stackTrace);
    return exception;
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