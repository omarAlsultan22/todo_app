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
        id: toJson['id'] ?? 0,
        status: toJson['status'] ?? '',
        title: toJson['title'] ?? '',
        time: toJson['time'] ?? '',
        date: toJson['date'] ?? '');
  }
}