import '../base/app_exception.dart';


class  InitializationException extends AppException {
  const InitializationException(
      ) : super(
    message: 'Failed to initialize the database.',
    code: 'INSERT_ERROR',
  );
}

class InsertException extends AppException {
  const InsertException(
      ) : super(
    message: 'Failed to add the data.',
    code: 'INSERT_ERROR',
  );
}

class UpdateException extends AppException {
  const UpdateException() : super(
    message: 'Failed to update data.',
    code: 'UPDATE_ERROR',
  );
}

class DeleteException extends AppException {
  const DeleteException() : super(
    message: 'Failed to delete the data.',
    code: 'DELETE_ERROR',
  );
}

class LoadException extends AppException {
  const LoadException() : super(
    message: 'Failed to load data.',
    code: 'LOAD_ERROR',
  );
}

class LoadMoreException extends AppException {
  const LoadMoreException() : super(
    message: 'Failed to load more data.',
    code: 'LOAD_MORE_ERROR',
  );
}