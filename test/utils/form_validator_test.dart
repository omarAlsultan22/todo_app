import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/utils/form_validators.dart';


void main() {
  group('FormValidator.requiredField', () {
    test('returns error message when value is null', () {
      final result = FormValidator.requiredField(null, 'Name');

      expect(result, 'Please enter your Name');
    });

    test('returns error message when value is empty', () {
      final result = FormValidator.requiredField('', 'Email');

      expect(result, 'Please enter your Email');
    });

    test('returns null when value is not empty', () {
      final result = FormValidator.requiredField('Ali', 'Name');

      expect(result, isNull);
    });

    test('includes the fieldName in the error message', () {
      final result = FormValidator.requiredField('', 'Password');

      expect(result, contains('Password'));
    });

    test('returns null for whitespace-only string (documents behavior)', () {
      // '   ' ليست فارغة → null (bug محتمل)
      final result = FormValidator.requiredField('   ', 'Name');

      expect(result, isNull);
    });
  });
}