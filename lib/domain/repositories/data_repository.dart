abstract class DataRepository {

  void createDatabase();


  Future<void> insertToDatabase({
    required String title,
    required String time,
    required String date,
  });


  Future <List<Map<String, Object?>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  });


  Future<void> updateInDatabase({
    required String status,
    required int id,
  });


  Future <void> deleteFromDatabase({
    required int id,
  });
}