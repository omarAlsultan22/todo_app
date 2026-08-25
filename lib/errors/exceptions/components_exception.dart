import 'base/app_exception.dart';


class ComponentsException extends AppException {
  const ComponentsException(
      ) : super(
    message: 'The application component initialization process failed.',
    code: 'INSERT_ERROR',
  );
}