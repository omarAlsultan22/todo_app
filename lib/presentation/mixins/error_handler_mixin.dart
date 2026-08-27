import '../../errors/error_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../errors/exceptions/base/app_exception.dart';


mixin ErrorHandlerMixin<State> on Cubit<State> {
  void handleError({
    required AppException error,
    required StackTrace stackTrace,
    required State Function(AppException failure) onError,
  }) {
    final errorHandler = ErrorLogger(error: error, stackTrace: stackTrace);
    final exception = errorHandler.logAndReturn();
    emit(onError(exception));
  }
}