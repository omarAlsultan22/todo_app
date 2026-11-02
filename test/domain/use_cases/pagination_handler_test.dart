import '../../fixtures/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/models/category_data.dart';
import 'package:todo_app/domain/use_cases/pagination_state_manager.dart';


void main() {
  late PaginationHandler handler;

  setUp(() {
    handler = PaginationHandler();
  });

  group('updateWithNewData', () {
    test('appends new tasks after current tasks (order preserved)', () {
      final current = CategoryData(
        tasks: [taskA, taskB],
        offset: 0,
        hasMore: true,
      );

      final result = handler.updateWithNewData(current, [taskC]);

      expect(result.tasks, [taskA, taskB, taskC]);
    });

    test('increments offset when newArticles is not empty', () {
      final current = CategoryData(
        tasks: [taskA],
        offset: 3,
        hasMore: true,
      );

      final result = handler.updateWithNewData(current, [taskB]);

      expect(result.offset, 4);  // 3 + 1
    });

    test('keeps offset unchanged when newArticles is empty', () {
      final current = CategoryData(
        tasks: [taskA],
        offset: 5,
        hasMore: true,
      );

      final result = handler.updateWithNewData(current, []);

      expect(result.offset, 5);  // يبقى 5
    });

    test('sets hasMore to true when newArticles is not empty', () {
      final current = CategoryData(
        tasks: [],
        offset: 0,
        hasMore: false,
      );

      final result = handler.updateWithNewData(current, [taskA]);

      expect(result.hasMore, true);
    });

    test('sets hasMore to false when newArticles is empty', () {
      final current = CategoryData(
        tasks: [taskA],
        offset: 1,
        hasMore: true,
      );

      final result = handler.updateWithNewData(current, []);

      expect(result.hasMore, false);
    });

    test('returns empty tasks when both lists are empty', () {
      final current = CategoryData(
        tasks: [],
        offset: 0,
        hasMore: false,
      );

      final result = handler.updateWithNewData(current, []);

      expect(result.tasks, isEmpty);
      expect(result.offset, 0);
      expect(result.hasMore, false);
    });

    test('does not modify the original currentData', () {
      final current = CategoryData(
        tasks: [taskA],
        offset: 1,
        hasMore: true,
      );
      final originalTasks = List<TaskModel>.from(current.tasks);

      handler.updateWithNewData(current, [taskB]);

      expect(current.tasks, originalTasks);
      expect(current.offset, 1);
    });
  });
}