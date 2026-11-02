import '../../fixtures/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_tasks_repository.dart';
import '../../fakes/fake_pagination_handler.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/models/category_data.dart';
import 'package:todo_app/domain/use_cases/tasks_use_case.dart';


void main() {
  late FakeTasksRepository fakeRepo;
  late FakePaginationHandler fakePagination;
  late TasksUseCase useCase;

  setUp(() {
    fakeRepo = FakeTasksRepository();
    fakePagination = FakePaginationHandler();
    useCase = TasksUseCase(
      repository: fakeRepo,
      paginationHandler: fakePagination,
    );
  });

  group('executeInitializeDatabase', () {
    test('passes onLoad to repository.createDatabase', () async {
      var onLoadCalled = false;

      await useCase.executeInitializeDatabase(() => onLoadCalled = true);

      expect(fakeRepo.createDatabaseCallCount, 1);
      expect(onLoadCalled, true);
    });

    test('propagates errors from createDatabase', () async {
      fakeRepo.createDatabaseError = Exception('db error');

      expect(
            () => useCase.executeInitializeDatabase(() {}),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('executeInsertData', () {
    test('passes title, time, date to repository.insertToDatabase', () async {
      fakeRepo.insertResult = {
        'id': 1,
        'title': 'Task',
        'time': '10:00',
        'date': '2024-05-01',
        'status': 'new',
      };

      await useCase.executeInsertData(
        title: 'Task',
        time: '10:00',
        date: '2024-05-01',
      );

      expect(fakeRepo.lastTitle, 'Task');
      expect(fakeRepo.lastTime, '10:00');
      expect(fakeRepo.lastDate, '2024-05-01');
    });

    test('returns TaskModel from repository result', () async {
      fakeRepo.insertResult = {
        'id': 1,
        'title': 'Task',
        'time': '10:00',
        'date': '2024-05-01',
        'status': 'new',
      };

      final result = await useCase.executeInsertData(
        title: 'Task',
        time: '10:00',
        date: '2024-05-01',
      );

      expect(result, isA<TaskModel>());
      expect(result.title, 'Task');
    });
  });

  group('executeGetData - offset calculation', () {
    test('computes offset as offset + length - 1', () async {
      final categoryData = CategoryData(
        tasks: [],
        offset: 1,
        hasMore: true,
      );

      await useCase.executeGetData(
        limit: 10,
        status: 'new',
        categoryData: categoryData,
      );

      // 1 + 10 - 1 = 10
      expect(fakeRepo.lastOffset, 10);
    });

    test('computes offset correctly for second page', () async {
      final categoryData = CategoryData(
        tasks: [],
        offset: 2,
        hasMore: true,
      );

      await useCase.executeGetData(
        limit: 10,
        status: 'new',
        categoryData: categoryData,
      );

      // 2 + 10 - 1 = 11
      expect(fakeRepo.lastOffset, 11);
    });

    test('passes limit and status to repository', () async {
      final categoryData = CategoryData(
        tasks: [],
        offset: 1,
        hasMore: true,
      );

      await useCase.executeGetData(
        limit: 20,
        status: 'done',
        categoryData: categoryData,
      );

      expect(fakeRepo.lastLimit, 20);
      expect(fakeRepo.lastStatus, 'done');
    });

    test('converts JSON list to TaskModel list', () async {
      fakeRepo.getResult = [
        {'id': 1, 'title': 'A', 'time': '10:00', 'date': '2024-05-01', 'status': 'new'},
        {'id': 2, 'title': 'B', 'time': '11:00', 'date': '2024-05-01', 'status': 'new'},
      ];
      final categoryData = CategoryData(
        tasks: [],
        offset: 1,
        hasMore: true,
      );

      await useCase.executeGetData(
        limit: 10,
        status: 'new',
        categoryData: categoryData,
      );

      expect(fakePagination.lastNewTasks?.length, 2);
      expect(fakePagination.lastNewTasks?.first.title, 'A');
    });

    test('calls paginationHandler.updateWithNewData with categoryData and tasks', () async {
      final categoryData = CategoryData(
        tasks: [taskA],
        offset: 1,
        hasMore: true,
      );
      fakeRepo.getResult = [
        {'id': 2, 'title': 'B', 'time': '11:00', 'date': '2024-05-01', 'status': 'new'},
      ];

      await useCase.executeGetData(
        limit: 10,
        status: 'new',
        categoryData: categoryData,
      );

      expect(fakePagination.updateCallCount, 1);
      expect(fakePagination.lastCurrentData, same(categoryData));
      expect(fakePagination.lastNewTasks?.length, 1);
    });

    test('returns result from paginationHandler', () async {
      final expected = CategoryData(tasks: [taskB], offset: 2, hasMore: false);
      fakePagination.resultToReturn = expected;
      final categoryData = CategoryData(tasks: [], offset: 1, hasMore: true);

      final result = await useCase.executeGetData(
        limit: 10,
        status: 'new',
        categoryData: categoryData,
      );

      expect(result, same(expected));
    });
  });

  group('executeGetTaskPosition', () {
    test('passes date, time, status to repository', () async {
      fakeRepo.positionResult = 3;

      await useCase.executeGetTaskPosition(taskModel: taskA);

      expect(fakeRepo.lastPositionDate, taskA.date);
      expect(fakeRepo.lastPositionTime, taskA.time);
      expect(fakeRepo.lastPositionStatus, taskA.status);
    });

    test('returns position from repository', () async {
      fakeRepo.positionResult = 7;

      final result = await useCase.executeGetTaskPosition(taskModel: taskA);

      expect(result, 7);
    });
  });

  group('executeUpdateData', () {
    test('passes id and status to repository', () async {
      fakeRepo.updateResult = {
        'id': 1,
        'title': 'Task',
        'time': '10:00',
        'date': '2024-05-01',
        'status': 'done',
      };

      await useCase.executeUpdateData(id: 1, status: 'done');

      expect(fakeRepo.lastUpdateId, 1);
      expect(fakeRepo.lastUpdateStatus, 'done');
    });

    test('returns TaskModel from repository result', () async {
      fakeRepo.updateResult = {
        'id': 1,
        'title': 'Task',
        'time': '10:00',
        'date': '2024-05-01',
        'status': 'done',
      };

      final result = await useCase.executeUpdateData(id: 1, status: 'done');

      expect(result, isA<TaskModel>());
      expect(result.status, 'done');
    });
  });

  group('executeDeleteData', () {
    test('passes id to repository.deleteFromDatabase', () async {
      await useCase.executeDeleteData(id: 42);

      expect(fakeRepo.deleteCallCount, 1);
      expect(fakeRepo.lastDeleteId, 42);
    });

    test('propagates errors from deleteFromDatabase', () async {
      fakeRepo.deleteError = Exception('delete failed');

      expect(
            () => useCase.executeDeleteData(id: 1),
        throwsA(isA<Exception>()),
      );
    });
  });
}