enum UserType {
  user,
  player,
}

class UnverifiedEmail {
  final UserType userType;
  final String email;

  UnverifiedEmail(this.userType, this.email);
}
