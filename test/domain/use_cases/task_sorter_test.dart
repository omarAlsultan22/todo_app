import '../../fixtures/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/domain/use_cases/task_sorter.dart';


void main() {
  group('findInsertPosition', () {
    test('returns 0 when tasks is empty', () {
      final position = TaskSorter.findInsertPosition(
        tasks: [],
        newTask: taskA,
      );

      expect(position, 0);
    });

    test('returns 0 when new task is before all tasks', () {
      // tasks = [taskB (11:00), taskC (next day)]
      // newTask = taskA (10:00) → قبل taskB
      final position = TaskSorter.findInsertPosition(
        tasks: [taskB, taskC],
        newTask: taskA,
      );

      expect(position, 0);
    });

    test('returns length when new task is after all tasks', () {
      // tasks = [taskA (10:00), taskB (11:00)]
      // newTask = taskC (next day) → بعد الكل
      final position = TaskSorter.findInsertPosition(
        tasks: [taskA, taskB],
        newTask: taskC,
      );

      expect(position, 2);
    });

    test('returns correct position in the middle', () {
      // tasks = [taskA (10:00), taskC (next day)]
      // newTask = taskB (11:00, same day as A) → بين A و C
      final position = TaskSorter.findInsertPosition(
        tasks: [taskA, taskC],
        newTask: taskB,
      );

      expect(position, 1);
    });

    test('returns 0 when inserting before first of single task', () {
      final position = TaskSorter.findInsertPosition(
        tasks: [taskB],
        newTask: taskA,
      );

      expect(position, 0);
    });

    test('returns 1 when inserting after single task', () {
      final position = TaskSorter.findInsertPosition(
        tasks: [taskA],
        newTask: taskB,
      );

      expect(position, 1);
    });

    test('returns mid when an equal task exists', () {
      // tasks = [taskA, taskB, taskC]
      // newTask = taskA (same as tasks[0])
      // Binary search: mid = 1 (taskB) → comparison > 0?
      // taskB (11:00) vs taskA (10:00) → comparison > 0 → high = 0
      // mid = 0 (taskA) → comparison == 0 → return 0
      final position = TaskSorter.findInsertPosition(
        tasks: [taskA, taskB, taskC],
        newTask: taskA,
      );

      expect(position, 0);
    });

    test('handles two tasks with same date but different times', () {
      // tasks = [taskD (09:00), taskB (11:00)]
      // newTask = taskA (10:00) → بين D و B
      final position = TaskSorter.findInsertPosition(
        tasks: [taskD, taskB],
        newTask: taskA,
      );

      expect(position, 1);
    });

    test('handles tasks across multiple dates', () {
      // tasks = [taskA (May 1, 10:00), taskC (May 2, 09:00)]
      // newTask = taskD (May 1, 09:00) → قبل A
      final position = TaskSorter.findInsertPosition(
        tasks: [taskA, taskC],
        newTask: taskD,
      );

      expect(position, 0);
    });

    test('returns correct position in large sorted list', () {
      // tasks = [taskD (09:00), taskA (10:00), taskB (11:00), taskC (May 2)]
      // newTask = task (May 1, 10:30) → بين A و B → 2
      final newTask = TaskModel(
        id: 99,
        title: 'New',
        date: '2024-05-01',
        time: '10:30',
        status: 'new',
      );

      final position = TaskSorter.findInsertPosition(
        tasks: [taskD, taskA, taskB, taskC],
        newTask: newTask,
      );

      expect(position, 2);
    });

    test('works with single-element list and equal task', () {
      final position = TaskSorter.findInsertPosition(
        tasks: [taskA],
        newTask: taskA,
      );

      expect(position, 0);
    });
  });
}