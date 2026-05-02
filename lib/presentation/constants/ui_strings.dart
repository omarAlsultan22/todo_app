import 'package:todo_app/constants/app_strings.dart';


abstract class UiStrings {
  static const String newStatus = AppStrings.newStatus;
  static const String doneStatus = 'done';
  static const archivedStatus = 'archived';

  static const List<String> statusList = [
    newStatus,
    doneStatus,
    archivedStatus
  ];
}