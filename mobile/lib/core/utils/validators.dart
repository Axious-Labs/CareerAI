/// Form input validation helpers for the CareerAI application.
class AppValidators {
  AppValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _urlRegExp = RegExp(
    r'^(https?:\/\/)?([a-zA-Z0-9.-]+(\.[a-zA-Z]{2,}))(:[0-9]+)?(\/.*)?$',
  );

  /// Validates standard email structure.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed) || !trimmed.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password length and structure.
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates that a required text field is non-empty.
  static String? requiredField(String? value, [String? fieldName]) {
    final name = fieldName ?? 'This field';
    if (value == null || value.trim().isEmpty) {
      return '$name is required';
    }
    return null;
  }

  /// Validates web URL format (optional if value is empty unless specified).
  static String? url(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) return 'URL is required';
      return null;
    }
    final trimmed = value.trim();
    if (!_urlRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates that string can be parsed as a numeric value within optional range.
  static String? number(
    String? value, {
    num? min,
    num? max,
    String? fieldName,
  }) {
    final name = fieldName ?? 'Value';
    if (value == null || value.trim().isEmpty) {
      return '$name is required';
    }
    final parsed = num.tryParse(value.trim());
    if (parsed == null) {
      return '$name must be a valid number';
    }
    if (min != null && parsed < min) {
      return '$name must be at least $min';
    }
    if (max != null && parsed > max) {
      return '$name cannot exceed $max';
    }
    return null;
  }

  /// Validates minimum string length.
  static String? minLength(String? value, int min, [String? fieldName]) {
    final name = fieldName ?? 'Field';
    if (value == null || value.trim().length < min) {
      return '$name must be at least $min characters';
    }
    return null;
  }

  /// Validates maximum string length.
  static String? maxLength(String? value, int max, [String? fieldName]) {
    final name = fieldName ?? 'Field';
    if (value != null && value.trim().length > max) {
      return '$name cannot exceed $max characters';
    }
    return null;
  }

  /// Validates international phone format.
  static String? phone(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) return 'Phone number is required';
      return null;
    }
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-().+]'), '');
    if (cleanPhone.length < 7 || cleanPhone.length > 15 || !RegExp(r'^\d+$').hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}

