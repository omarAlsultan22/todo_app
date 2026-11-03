import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/utils/position_utils.dart';


void main() {
  group('PositionUtils.calculateSafePosition', () {
    // ===== tasksLength == 0 =====
    test('returns 0 when tasksLength is 0 (empty list)', () {
      expect(
        PositionUtils.calculateSafePosition(position: 5, tasksLength: 0),
        0,
      );
    });

    test('returns 0 when tasksLength is 0 and position is 0', () {
      expect(
        PositionUtils.calculateSafePosition(position: 0, tasksLength: 0),
        0,
      );
    });

    // ===== valid position (in range) =====
    test('returns position when in range (middle)', () {
      expect(
        PositionUtils.calculateSafePosition(position: 3, tasksLength: 10),
        3,
      );
    });

    test('returns 0 when position is 0 (lower boundary)', () {
      expect(
        PositionUtils.calculateSafePosition(position: 0, tasksLength: 10),
        0,
      );
    });

    test('returns tasksLength when position is at upper boundary', () {
      // position == tasksLength → valid (<=)
      expect(
        PositionUtils.calculateSafePosition(position: 10, tasksLength: 10),
        10,
      );
    });

    // ===== negative position =====
    test('returns 0 when position is negative', () {
      expect(
        PositionUtils.calculateSafePosition(position: -5, tasksLength: 10),
        0,
      );
    });

    test('returns 0 when position is -1', () {
      expect(
        PositionUtils.calculateSafePosition(position: -1, tasksLength: 10),
        0,
      );
    });

    // ===== position > tasksLength =====
    test('returns tasksLength when position exceeds tasksLength', () {
      expect(
        PositionUtils.calculateSafePosition(position: 15, tasksLength: 10),
        10,
      );
    });

    test('returns tasksLength when position is tasksLength + 1', () {
      expect(
        PositionUtils.calculateSafePosition(position: 11, tasksLength: 10),
        10,
      );
    });

    // ===== edge cases =====
    test('returns 0 for position 0 and tasksLength 0', () {
      expect(
        PositionUtils.calculateSafePosition(position: 0, tasksLength: 0),
        0,
      );
    });

    test('handles large values', () {
      expect(
        PositionUtils.calculateSafePosition(
            position: 999999, tasksLength: 100),
        100,
      );
    });
  });
}