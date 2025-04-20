import 'package:tracket/features/teams/utils/team_constants.dart';

class TValidator {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }

    //! Use a more comprehensive email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; //? Valid email
  }

  static String? passwordValidator(String? value, bool isLogin) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (!isLogin) {
      if (value.length < 8) {
        return 'Password must be at least 8 characters long';
      }

      final hasUpperCase = value.contains(RegExp(r'[A-Z]'));
      final hasLowerCase = value.contains(RegExp(r'[a-z]'));
      final hasNumbers = value.contains(RegExp(r'[0-9]'));
      final hasSpecialCharacters =
          value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (!hasUpperCase || !hasLowerCase) {
        return 'Password must contain both uppercase and lowercase letters';
      }

      if (!hasNumbers) {
        return 'Password must contain at least one number';
      }

      if (!hasSpecialCharacters) {
        return 'Password must contain at least one special character';
      }
    }

    return null;
  }

  static String? validatePlayerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Player name is required';
    }

    if (value.trim().length < 2) {
      return 'Player name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'Player name cannot exceed 50 characters';
    }

    // Allow letters, spaces, and common special characters
    final nameRegex = RegExp(r"^[a-zA-Z0-9\s\-'\.]+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Player name contains invalid characters';
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

  static String? descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description cannot be empty';
    }

    if (value.trim().length < 10) {
      return 'Description must contain at least 10 characters';
    }

    if (value.length > TeamConstants.maxTeamDescriptionLength) {
      return 'Description cannot exceed 200 characters';
    }
    return null;
  }
}
