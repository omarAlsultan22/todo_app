abstract class DataRepository {

  void createDatabase();

  Future<Map<String, Object?>> insertToDatabase({
    required String title,
    required String time,
    required String date,
  });

  Future<int> getTaskPosition({
    required String date,
    required String time,
    required String status,
  });

  Future <List<Map<String, Object?>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  });

  Future<Map<String, Object?>> updateInDatabase({
    required String status,
    required int id,
  });

  Future <void> deleteFromDatabase({
    required int id,
  });
}