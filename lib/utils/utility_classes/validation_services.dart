class ValidationServices {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }

    //! Regular expression for validating an email
    const emailRegex = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; //? Valid email
  }

  static String? passwordValidator(String? value, bool isLogin) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (isLogin) return null;

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }

    if (value.trim().contains(' ')) {
      return 'Username cannot contain a space';
    }

    if (value.trim().length < 4) {
      return 'Username must contain at least 4 characters';
    }
    return null;
  }

  static String? teamShortNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Team Short Name cannot be empty';
    }

    if (value.trim().contains(' ')) {
      return 'Team Short Name cannot contain a space';
    }

    if (value.trim().length > 4) {
      return 'Team Short Name must contain at most 4 characters';
    }
    return null;
  }

  static String? nameValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }

    if (value.trim().length < 4) {
      return '$fieldName must contain at least 4 characters';
    }
    return null;
  }
}
