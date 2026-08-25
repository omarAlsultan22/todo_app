import 'database_operations.dart';
import 'package:todo_app/errors/exceptions/base/app_exception.dart';


class DatabaseAppException extends AppException {
  final String? operationType;

  DatabaseAppException({super.message, this.operationType});

  static final Map<String, AppException> _sqlMap = {
    'load': LoadException(),
    'insert': InsertException(),
    'update': UpdateException(),
    'delete': DeleteException(),
    'loadMore': LoadMoreException(),
    'initialization': InitializationException(),
  };

  AppException getException() {
    final isKeyFound = _sqlMap.containsKey(operationType);
    if (isKeyFound) {
      return _sqlMap[operationType]!;
    }

    return DatabaseAppException(
      message: 'Database error.',
    );
  }
}



