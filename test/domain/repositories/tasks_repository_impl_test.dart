import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_tasks_data_source.dart';
import '../../fakes/fake_encryption_keys_repository.dart';
import 'package:todo_app/domain/repositories/tasks_repository.dart';
import 'package:todo_app/data/repositories_impl/local/tasks_repository_impl.dart';


void main() {
  late FakeTasksDataSource fakeDataSource;
  late FakeEncryptionKeysRepository fakeKeysRepo;
  late TasksRepository repository;

  setUp(() {
    fakeDataSource = FakeTasksDataSource();
    fakeKeysRepo = FakeEncryptionKeysRepository();
    repository = TasksRepositoryImpl(
      dataSource: fakeDataSource,
      encryptionKeysRepository: fakeKeysRepo,
    );
  });

  group('createDatabase', () {
    test('fetches encryption key and passes it to data source', () async {
      fakeKeysRepo.keyToReturn = 'my-secret-key';
      var onLoadCalled = false;
      void onLoad() => onLoadCalled = true;

      await repository.createDatabase(onLoad);

      expect(fakeKeysRepo.getCallCount, 1);
      expect(fakeDataSource.createDatabaseCallCount, 1);
      expect(fakeDataSource.lastPassword, 'my-secret-key');
      expect(onLoadCalled, true);
    });

    test('passes null password when no key is stored', () async {
      fakeKeysRepo.keyToReturn = null;

      await repository.createDatabase(() {});

      expect(fakeDataSource.lastPassword, isNull);
    });

    test('passes the same onLoad callback to data source', () async {
      void onLoad() {}
      fakeKeysRepo.keyToReturn = 'key';

      await repository.createDatabase(onLoad);

      expect(fakeDataSource.lastOnLoad, same(onLoad));
    });

    test('propagates errors from encryption keys repository', () async {
      fakeKeysRepo.getError = Exception('secure storage failed');

      expect(
            () => repository.createDatabase(() {}),
        throwsA(isA<Exception>()),
      );

      // لم يُستدعَ data source
      expect(fakeDataSource.createDatabaseCallCount, 0);
    });
  });

  group('insertToDatabase', () {
    test('delegates to data source and returns its result', () async {
      fakeDataSource.insertResult = {'id': 42, 'title': 'Hello'};

      final result = await repository.insertToDatabase(
        title: 'Hello',
        time: '10:00',
        date: '2024-05-01',
      );

      expect(result, {'id': 42, 'title': 'Hello'});
    });

    test('propagates data source errors', () async {
      fakeDataSource.insertError = Exception('insert failed');

      expect(
            () => repository.insertToDatabase(
          title: 'X',
          time: '10:00',
          date: '2024-05-01',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getTaskPosition', () {
    test('delegates to data source and returns position', () async {
      fakeDataSource.positionResult = 5;

      final result = await repository.getTaskPosition(
        date: '2024-05-01',
        time: '10:00',
        status: 'new',
      );

      expect(result, 5);
    });
  });

  group('getDataFromDatabase', () {
    test('delegates to data source and returns list', () async {
      fakeDataSource.getResult = [
        {'id': 1, 'title': 'A'},
        {'id': 2, 'title': 'B'},
      ];

      final result = await repository.getDataFromDatabase(
        limit: 10,
        offset: 0,
        status: 'new',
      );

      expect(result.length, 2);
      expect(result.first['title'], 'A');
    });

    test('propagates data source errors', () async {
      fakeDataSource.getError = Exception('load failed');

      expect(
            () => repository.getDataFromDatabase(
          limit: 10,
          offset: 0,
          status: 'new',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateInDatabase', () {
    test('delegates to data source and returns updated row', () async {
      fakeDataSource.updateResult = {'id': 1, 'status': 'done'};

      final result = await repository.updateInDatabase(status: 'done', id: 1);

      expect(result, {'id': 1, 'status': 'done'});
    });
  });

  group('deleteFromDatabase', () {
    test('calls data source deleteFromDatabase with the given id', () async {
      await repository.deleteFromDatabase(id: 42);

      expect(fakeDataSource.deleteCallCount, 1);
      expect(fakeDataSource.lastDeleteId, 42);
    });

    test('calls data source exactly once per call', () async {
      await repository.deleteFromDatabase(id: 1);
      await repository.deleteFromDatabase(id: 2);

      expect(fakeDataSource.deleteCallCount, 2);
      expect(fakeDataSource.lastDeleteId, 2);
    });

    test('propagates data source errors', () async {
      fakeDataSource.deleteError = Exception('delete failed');

      expect(
            () => repository.deleteFromDatabase(id: 1),
        throwsA(isA<Exception>()),
      );

      expect(fakeDataSource.deleteCallCount, 1);
      expect(fakeDataSource.lastDeleteId, 1);
    });
  });
}