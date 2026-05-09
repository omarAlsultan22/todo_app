import 'package:todo_app/data/constants/data_strings.dart';


class TaskModel {
  final int id;
  final String status;
  final String title;
  final String time;
  final String date;

  TaskModel({
    required this.id,
    required this.status,
    required this.title,
    required this.time,
    required this.date,
  });

  factory TaskModel.fromJson(Map<String, dynamic> toJson){
    return TaskModel(
        id: toJson[DataStrings.id] ?? 0,
        status: toJson[DataStrings.status] ?? '',
        title: toJson[DataStrings.title] ?? '',
        time: toJson[DataStrings.time] ?? '',
        date: toJson[DataStrings.date] ?? '');
  }
}