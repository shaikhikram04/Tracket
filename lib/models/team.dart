import 'dart:ui';

class Team {
  const Team({
    required this.name,
    required this.shortName,
    required this.logo,
  });

  final String name;
  final String shortName;
  final Image logo;
}
