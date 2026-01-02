import 'package:sqflite/sqflite.dart';


class TasksRepository {

  late Database database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase();
        print('database opened');
      },
    ).then((value) {
      database = value;
    });
  }


  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) =>
        txn
            .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
        )
            .then((value) {
          print('$value inserted successfully');
          getDataFromDatabase();
        }).catchError((error) {
          print('Error When Inserting New Record ${error.toString()}');
        })
    );
  }


  Future <dynamic> getDataFromDatabase() {
    return database.rawQuery('SELECT * FROM tasks');
  }


  Future<void> updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    );
  }


  Future <void> deleteData({
    required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  }
}