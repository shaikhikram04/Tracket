enum TeamRole {
  owner('owner'),
  admin('admin'),
  player('player'),
  none('none');

  final String value;
  const TeamRole(this.value);

  static TeamRole fromString(String value) {
    return TeamRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => TeamRole.none,
    );
  }
}