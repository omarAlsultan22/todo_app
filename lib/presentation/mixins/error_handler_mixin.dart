import '../../errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../errors/exceptions/base/app_exception.dart';


mixin ErrorHandlerMixin<State> on Cubit<State> {
  void handleError({
    required Object error,
    required String operationType,
    required StackTrace stackTrace,
    required State Function(AppException failure) onError,
  }) {
    final errorHandler = ErrorHandler(
      error: error,
      stackTrace: stackTrace,
      operationType: operationType,
    );
    final exception = errorHandler.handleException();
    emit(onError(exception));
  }
}