final class FormValidator {
  FormValidator._();

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }
}