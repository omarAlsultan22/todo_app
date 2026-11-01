import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/presentation/constants/ui_strings.dart';
import 'package:todo_app/domain/data_sources/tasks_data_source.dart';
import 'package:todo_app/errors/exceptions/database_operations.dart';
import 'package:todo_app/data/data_sources/tasks_data_source_impl.dart';


void main() {
  // تهيئة sqflite_common_ffi (يعمل في flutter test بدون جهاز)
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late bool onLoadCalled;
  late TasksDataSource dataSource;

  setUp(() async {
    onLoadCalled = false;
    dataSource = TasksDataSourceImpl();

    // إنشاء قاعدة بيانات في الذاكرة
    await dataSource.createDatabase(
      databasePath: inMemoryDatabasePath,
      onLoad: () {
        onLoadCalled = true;
      },
    );
  });

  group('createDatabase', () {
    test('calls onLoad when database opens', () {
      expect(onLoadCalled, true);
    });
  });

  group('insertToDatabase', () {
    test('inserts a task and returns its full row with generated id', () async {
      final result = await dataSource.insertToDatabase(
        title: 'Buy milk',
        date: '2024-05-01',
        time: '10:00',
      );

      expect(result['id'], isA<int>());
      expect(result['title'], 'Buy milk');
      expect(result['date'], '2024-05-01');
      expect(result['time'], '10:00');
      expect(result['status'], UiStrings.newStatus);
    });

    test('assigns auto-increment ids to multiple inserts', () async {
      final first = await dataSource.insertToDatabase(
          title: 'First', date: '2024-05-01', time: '10:00');
      final second = await dataSource.insertToDatabase(
          title: 'Second', date: '2024-05-01', time: '11:00');

      expect(second['id'], (first['id'] as int) + 1);
    });
  });

  group('getDataFromDatabase', () {
    test('returns tasks filtered by status ordered by date/time ASC', () async {
      await dataSource.insertToDatabase(
          title: 'A', date: '2024-05-02', time: '09:00');
      await dataSource.insertToDatabase(
          title: 'B', date: '2024-05-01', time: '10:00');
      await dataSource.insertToDatabase(
          title: 'C', date: '2024-05-01', time: '08:00');

      final result = await dataSource.getDataFromDatabase(
        limit: 10,
        offset: 0,
        status: UiStrings.newStatus,
      );

      expect(result.map((r) => r['title']).toList(), ['C', 'B', 'A']);
    });

    test('respects limit and offset', () async {
      for (var i = 0; i < 5; i++) {
        await dataSource.insertToDatabase(
            title: 'Task $i',
            date: '2024-05-01',
            time: '1${i.toString().padLeft(1, '0')}:00');
      }

      final page1 = await dataSource.getDataFromDatabase(
          limit: 2, offset: 0, status: UiStrings.newStatus);
      final page2 = await dataSource.getDataFromDatabase(
          limit: 2, offset: 2, status: UiStrings.newStatus);

      expect(page1.map((r) => r['title']).toList(), ['Task 0', 'Task 1']);
      expect(page2.map((r) => r['title']).toList(), ['Task 2', 'Task 3']);
    });

    test('returns empty list when no tasks match status', () async {
      await dataSource.insertToDatabase(
          title: 'A', date: '2024-05-01', time: '10:00');

      final result = await dataSource.getDataFromDatabase(
        limit: 10,
        offset: 0,
        status: 'done', // لا توجد مهام بهذه الحالة
      );

      expect(result, isEmpty);
    });
  });

  group('updateInDatabase', () {
    test('updates status and returns updated row', () async {
      final inserted = await dataSource.insertToDatabase(
          title: 'A', date: '2024-05-01', time: '10:00');
      final id = inserted['id'] as int;

      final updated = await dataSource.updateInDatabase(
        status: 'done',
        id: id,
      );

      expect(updated['id'], id);
      expect(updated['status'], 'done');
      expect(updated['title'], 'A'); // باقي الحقول لم تتغير
    });

    test('throws UpdateException when id does not exist', () async {
      expect(
            () => dataSource.updateInDatabase(status: 'done', id: 9999),
        throwsA(isA<UpdateException>()),
      );
    });
  });

  group('deleteFromDatabase', () {
    test('deletes the task so it no longer appears in queries', () async {
      final inserted = await dataSource.insertToDatabase(
          title: 'A', date: '2024-05-01', time: '10:00');
      final id = inserted['id'] as int;

      await dataSource.deleteFromDatabase(id: id);

      final remaining = await dataSource.getDataFromDatabase(
          limit: 10, offset: 0, status: UiStrings.newStatus);
      expect(remaining, isEmpty);
    });
  });

  group('getTaskPosition', () {
    test('returns 0 when inserting the earliest task', () async {
      final position = await dataSource.getTaskPosition(
        date: '2024-05-01',
        time: '08:00',
        status: UiStrings.newStatus,
      );
      expect(position, 0);
    });

    test('counts tasks with earlier date/time in same status', () async {
      await dataSource.insertToDatabase(
          title: 'A', date: '2024-05-01', time: '08:00');
      await dataSource.insertToDatabase(
          title: 'B', date: '2024-05-01', time: '09:00');
      await dataSource.insertToDatabase(
          title: 'C', date: '2024-05-02', time: '07:00');

      // مهمة جديدة في 2024-05-01 10:00 → قبلها A و B (نفس اليوم، وقت أقل)
      final position = await dataSource.getTaskPosition(
        date: '2024-05-01',
        time: '10:00',
        status: UiStrings.newStatus,
      );
      expect(position, 2);
    });

    test('does not count tasks with different status', () async {
      final inserted = await dataSource.insertToDatabase(
          title: 'A', date: '2024-05-01', time: '08:00');
      await dataSource.updateInDatabase(
          status: 'done', id: inserted['id'] as int);

      final position = await dataSource.getTaskPosition(
        date: '2024-05-01',
        time: '10:00',
        status: UiStrings.newStatus,
      );
      expect(position, 0);
    });

    test('counts earlier dates even with later times', () async {
      await dataSource.insertToDatabase(
          title: 'A', date: '2024-04-30', time: '23:00');

      final position = await dataSource.getTaskPosition(
        date: '2024-05-01',
        time: '01:00',
        status: UiStrings.newStatus,
      );
      expect(position, 1);
    });
  });
}