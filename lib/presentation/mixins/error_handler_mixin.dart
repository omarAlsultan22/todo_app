import '../../errors/error_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../errors/exceptions/base/app_exception.dart';


mixin ErrorHandlerMixin<State> on Cubit<State> {
  void handleError({
    required AppException exception,
    required StackTrace stackTrace,
    required State Function(AppException failure) onError,
  }) {
    final errorLogger = ErrorLogger(exception: exception, stackTrace: stackTrace);
    final failure = errorLogger.logAndReturn();
    emit(onError(failure));
  }
}