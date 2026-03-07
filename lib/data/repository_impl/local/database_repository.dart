import 'package:sqflite/sqflite.dart';
import '../../../domain/repository/repository.dart';


class TasksRepository implements DataRepository {

  late Database _database;

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
      _database = value;
    });
  }


  @override
  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await _database.transaction((txn) =>
        txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',)
            .then((value) {
          print('$value inserted successfully');
        }).catchError((error) {
          throw('Error When Inserting New Record ${error.toString()}');
        })
    );
  }


  @override
  Future <dynamic> getDataFromDatabase() {
    return _database.rawQuery('SELECT * FROM tasks');
  }


  @override
  Future<void> updateData({
    required String status,
    required int id,
  }) async
  {
    _database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    );
  }


  @override
  Future <void> deleteData({
    required int id,
  }) async
  {
    _database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  }
}