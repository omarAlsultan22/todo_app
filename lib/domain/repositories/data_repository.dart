abstract class DataRepository {

  void createDatabase();


  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  });


  Future <dynamic> getDataFromDatabase();


  Future<void> updateData({
    required String status,
    required int id,
  });


  Future <void> deleteData({
    required int id,
  });
}