import 'package:sqflite/sqflite.dart';
import '../../../domain/repository/repository.dart';


class TasksRepository implements DataRepository{

  late Database database;

  @override
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
          throw('Error When Creating Table ${error.toString()}');
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


  @override
  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    final sql = 'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")';
    await database.transaction((txn) =>
        txn.rawInsert(sql,)
            .then((value) {
          print('$value inserted successfully');
        }).catchError((error) {
          throw('Error When Inserting New Record ${error.toString()}');
        })
    );
  }


  @override
  Future <dynamic> getDataFromDatabase() {
    const sql = 'SELECT * FROM tasks';
    return database.rawQuery(sql);
  }


  @override
  Future<void> updateData({
    required String status,
    required int id,
  }) async
  {
    const sql = 'UPDATE tasks SET status = ? WHERE id = ?';
    database.rawUpdate(
      sql,
      [status, id],
    );
  }


  @override
  Future <void> deleteData({
    required int id,
  }) async
  {
    const sql = 'DELETE FROM tasks WHERE id = ?';
    database.rawDelete(sql, [id]);
  }
}