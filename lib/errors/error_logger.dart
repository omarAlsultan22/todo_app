import 'exceptions/base/app_exception.dart';


class ErrorLogger {
  final AppException error;
  final StackTrace stackTrace;

  ErrorLogger({
    required this.error,
    required this.stackTrace,
  });

  AppException logAndReturn() {
    _logError(error, stackTrace);
    return error;
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