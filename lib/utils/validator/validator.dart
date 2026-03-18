import 'package:tracket/features/teams/utils/team_constants.dart';

class TValidator {
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
