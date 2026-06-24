import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:todo_app/data/constants/data_strings.dart';
import '../../../domain/repositories/data_repository.dart';
import 'package:todo_app/presentation/constants/ui_strings.dart';
import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';


class TasksRepository implements DataRepository {
  final EncryptionKeysRepository _repository;

  TasksRepository({
    required EncryptionKeysRepository repository
  })
      : _repository = repository;

  static late Database _database;

  static const _text = 'TEXT';
  static const _tasks = 'tasks';
  static const _id = DataStrings.id;
  static const _time = DataStrings.time;
  static const _date = DataStrings.date;
  static const _title = DataStrings.title;
  static const _status = DataStrings.status;

  @override
  Future<void> createDatabase(VoidCallback onLoad) async {
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
        await database
            .execute(
            'CREATE TABLE $_tasks ('
                '$_id INTEGER PRIMARY KEY, $_title $_text, $_date $_text, $_time $_text, $_status $_text)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          throw('Error When Creating Table ${error.toString()}');
        });
        // 2. إنشاء فهرس للترتيب الزمني 🚀
        await database.execute('''
          CREATE INDEX idx_tasks_time ON tasks($_date, $_time)
        ''');

        // 3. فهرس للحالة (للتقسيم)
        await database.execute('''
          CREATE INDEX idx_tasks_status ON tasks($_status)
        ''');
      },
      onOpen: (database) {
        _database = database;
        print('database opened');
      },
    ).then((_) async {
      onLoad();
    });
  }

  @override
  Future<Map<String, Object?>> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      // 1. استخدام transaction مع rawQuery
      final result = await _database.transaction((txn) async {
        return await txn.rawQuery('''
          INSERT INTO $_tasks ($_title, $_date, $_time, $_status) 
          VALUES (?, ?, ?, ?)
          RETURNING $_id, $_title, $_date, $_time, $_status
        ''', [title, date, time, UiStrings.newStatus]);
      });

      // 2. التحقق من النتيجة
      if (result.isEmpty) {
        throw Exception('Failed to insert task');
      }

      final insertedTask = result.first;
      print(
          '✅ Task inserted: ID ${insertedTask[_id]}, Title: ${insertedTask[_title]}');

      return insertedTask; // Map<String, Object?>

    } catch (error) {
      print('❌ Error inserting task: $error');
      throw Exception('Error When Inserting New Record: ${error.toString()}');
    }
  }

  @override
  Future<int> getTaskPosition({
    required String date,
    required String time,
    required String status,
  }) async {
    try {
      // count = عدد المهام التي وقتها < وقت المهمة الجديدة
      final result = await _database.rawQuery('''
        SELECT COUNT(*) as position 
        FROM $_tasks 
        WHERE $_status = ? 
          AND (
            $_date < ? 
            OR ($_date = ? AND $_time < ?)
          )
      ''', [status, date, date, time]);

      // الرقم المسترجع = موقع المهمة في القائمة
      final position = Sqflite.firstIntValue(result) ?? 0;

      print('📍 Position calculated: $position');
      return position;
    } catch (e) {
      print('❌ Error calculating position: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, Object?>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  }) async {
    try {
      return await _database.query(
        _tasks,
        where: '$_status = ?',
        whereArgs: [status],
        orderBy: '$_date ASC, $_time ASC',
        // 🔥 ترتيب زمني من الأقدم للأحدث
        limit: limit,
        offset: offset,
      );
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>> updateInDatabase({
    required String status,
    required int id,
  }) async {
    try {
      final result = await _database.transaction((txn) async {
        return await txn.rawQuery('''
        UPDATE $_tasks 
        SET $_status = ? 
        WHERE $_id = ?
        RETURNING $_id, $_title, $_date, $_time, $_status
      ''', [status, id]);
      });

      if (result.isNotEmpty) {
        final insertedTask = result.first;
        print(
            '✅ Task updated: ${insertedTask[_title]} (ID: ${insertedTask[_id]})');
        return insertedTask;
      } else {
        throw Exception('Task with ID $id not found');
      }
    } catch (e) {
      print('❌ Error updating task: $e');
      rethrow;
    }
  }

  @override
  Future <void> deleteFromDatabase({
    required int id,
  }) async
  {
    try {
      await _database.rawDelete('DELETE FROM $_tasks WHERE $_id = ?', [id]);
    }
    catch (e) {
      rethrow;
    }
  }
}

