import '../base/app_exception.dart';


class  InitializationException extends AppException {
  const InitializationException({super.error}) : super(
    message: 'Error When Creating Table.',
    code: 'INSERT_ERROR',
  );
}

class InsertException extends AppException {
  const InsertException({
    super.error,
    String? message
  })
      : super(
    message: message ?? 'Failed to insert task.',
    code: 'INSERT_ERROR',
  );
}
class UpdateException extends AppException {
  const UpdateException({
    super.error,
    String? message
  }) : super(
    message: message ?? 'Failed to update data.',
    code: 'UPDATE_ERROR',
  );
}

class DeleteException extends AppException {
  const DeleteException({super.error}) : super(
    message: 'Failed to delete the data.',
    code: 'DELETE_ERROR',
  );
}

class LoadException extends AppException {
  const LoadException({super.error}) : super(
    message: 'Failed to load data.',
    code: 'LOAD_ERROR',
  );
}

class TabDataException extends AppException {
  final int index;

  const TabDataException({
    super.error,
    required this.index
  }) : super(
    message: 'Tab data not found for index: $index.',
    code: 'LOAD_ERROR',
  );
}
