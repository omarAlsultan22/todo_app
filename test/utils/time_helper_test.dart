import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/utils/time_helper.dart';


void main() {
  group('formatTo12Hour', () {
    test('converts 00:00 to 12:00 AM (midnight)', () {
      expect(TimeHelper.formatTo12Hour('00:00'), '12:00 AM');
    });

    test('converts 01:00 to 1:00 AM', () {
      expect(TimeHelper.formatTo12Hour('01:00'), '1:00 AM');
    });

    test('converts 09:30 to 9:30 AM', () {
      expect(TimeHelper.formatTo12Hour('09:30'), '9:30 AM');
    });

    test('converts 11:59 to 11:59 AM', () {
      expect(TimeHelper.formatTo12Hour('11:59'), '11:59 AM');
    });

    test('converts 12:00 to 12:00 PM (noon)', () {
      expect(TimeHelper.formatTo12Hour('12:00'), '12:00 PM');
    });

    test('converts 13:00 to 1:00 PM', () {
      expect(TimeHelper.formatTo12Hour('13:00'), '1:00 PM');
    });

    test('converts 23:59 to 11:59 PM', () {
      expect(TimeHelper.formatTo12Hour('23:59'), '11:59 PM');
    });

    test('returns input unchanged when format is invalid', () {
      expect(TimeHelper.formatTo12Hour('invalid'), 'invalid');
    });

    test('returns input unchanged when hour is not a number', () {
      expect(TimeHelper.formatTo12Hour('xx:00'), 'xx:00');
    });
  });

  group('formatTo24Hour', () {
    test('converts 12:00 AM to 00:00 (midnight)', () {
      expect(TimeHelper.formatTo24Hour('12:00 AM'), '00:00');
    });

    test('converts 01:00 AM to 01:00', () {
      expect(TimeHelper.formatTo24Hour('01:00 AM'), '01:00');
    });

    test('converts 09:30 AM to 09:30', () {
      expect(TimeHelper.formatTo24Hour('09:30 AM'), '09:30');
    });

    test('converts 12:00 PM to 12:00 (noon)', () {
      expect(TimeHelper.formatTo24Hour('12:00 PM'), '12:00');
    });

    test('converts 01:00 PM to 13:00', () {
      expect(TimeHelper.formatTo24Hour('01:00 PM'), '13:00');
    });

    test('converts 11:59 PM to 23:59', () {
      expect(TimeHelper.formatTo24Hour('11:59 PM'), '23:59');
    });

    test('pads single-digit hour with zero', () {
      expect(TimeHelper.formatTo24Hour('01:05 AM'), '01:05');
    });

    test('returns input unchanged when format is invalid', () {
      expect(TimeHelper.formatTo24Hour('invalid'), 'invalid');
    });
  });

  group('round-trip conversion', () {
    test('24 -> 12 -> 24 preserves valid times', () {
      const times = ['00:00', '06:30', '12:00', '18:45', '23:59'];
      for (final t in times) {
        final twelve = TimeHelper.formatTo12Hour(t);
        final back = TimeHelper.formatTo24Hour(twelve);
        expect(back, t, reason: 'Round-trip failed for $t');
      }
    });
  });
}