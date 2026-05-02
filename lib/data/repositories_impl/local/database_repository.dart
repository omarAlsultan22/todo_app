import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:todo_app/constants/app_strings.dart';
import 'package:todo_app/data/constants/data_strings.dart';
import '../../../domain/repositories/data_repository.dart';
import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';


class TasksRepository implements DataRepository {
  final EncryptionKeysRepository _repository;

  TasksRepository({
    required EncryptionKeysRepository repository
  })
      : _repository = repository;

  late Database _database;

  static const _text = 'TEXT';
  static const _tasks = 'tasks';
  static const _id = DataStrings.id;
  static const _time = DataStrings.time;
  static const _date = DataStrings.date;
  static const _title = DataStrings.title;
  static const _status = DataStrings.status;

  @override
  Future<void> createDatabase() async {
    final password = await _repository.getEncryptionKey();

    openDatabase(
      'todo.db',
      version: 1,
      password: password,
      onCreate: (database, version) async {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
            'CREATE TABLE $_tasks ('
                '$_id INTEGER PRIMARY KEY, $_title $_text, $_date $_text, $_time $_text, $_status $_text)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          throw('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    ).then((value) {
      _database = value;
    });
  }

  @override
  Future<void> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await _database.transaction((txn) =>
        txn.rawInsert(
            'INSERT INTO $_tasks ($_title, $_date, $_time, $_status) VALUES("$title", "$date", "$time", "${AppStrings
                .newStatus}")')
            .then((value) {
          print('$value inserted successfully');
        }).catchError((error) {
          throw('Error When Inserting New Record ${error.toString()}');
        })
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  }) async {
    try {
      return await _database.rawQuery(
          'SELECT * FROM $_tasks WHERE $_status = ? LIMIT ? OFFSET ?',
          [status, limit, offset]
      );
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateInDatabase({
    required String status,
    required int id,
  }) async
  {
    try {
      _database.rawUpdate(
        'UPDATE $_tasks SET $_status = ? WHERE $_id = ?',
        [status, id],
      );
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future <void> deleteFromDatabase({
    required int id,
  }) async
  {
    try {
      _database.rawDelete('DELETE FROM $_tasks WHERE $_id = ?', [id]);
    }
    catch (e) {
      rethrow;
    }
  }
}

