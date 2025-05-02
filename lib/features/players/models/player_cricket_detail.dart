import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/players/models/all_format_stats.dart';
import 'package:tracket/features/teams/models/team_details.dart';

enum CricketRole {
  batsman('Batsman'),
  bowler('Bowler'),
  allRounder('All-Rounder'),
  wicketKeeper('Wicketkeeper');

  const CricketRole(this.description);
  final String description;
}

enum Position {
  righty,
  lefty,
}

enum BowlingStyle {
  none,
  fast,
  mediumFast,
  legSpin,
  offSpin,
  chinaMan,
}

class PlayerCricketDetails {
  final CricketRole cricketRole;
  final Position battingPosition;
  final Position? bowlingArm;
  final BowlingStyle bowlingStyle;
  final bool isPrivate;
  final List achievements;
  final List requestedTeams;
  final List<TeamDetails> teams;
  final AllFormatStats allFormatStats;

  PlayerCricketDetails({
    required this.cricketRole,
    required this.battingPosition,
    required this.bowlingArm,
    required this.bowlingStyle,
    required this.isPrivate,
    required this.achievements,
    required this.requestedTeams,
    required this.teams,
    required this.allFormatStats,
  });

  Map<String, dynamic> get toMap => {
        'cricketRole': cricketRole.name,
        'battingPosition': battingPosition.name,
        'bowlingArm': bowlingArm?.name,
        'bowlingStyle': bowlingStyle.name,
        'isPrivate': isPrivate,
        'achievements': achievements,
        'requestedTeams': requestedTeams,
      };

  factory PlayerCricketDetails.fromMap(
    Map<String, dynamic> map,
    List<QueryDocumentSnapshot>? playerTeams,
    Map<String, dynamic>? allFormatStats,
  ) {
    return PlayerCricketDetails(
      cricketRole: getCricketRole(map['cricketRole']),
      battingPosition: getPosition(map['battingPosition'])!,
      bowlingArm: getPosition(map['bowlingArm']),
      bowlingStyle: getBowlingStyle(map['bowlingStyle']),
      isPrivate: map['isPrivate'],
      achievements: map['achievements'],
      requestedTeams: map['requestedTeams'],
      teams: playerTeamsToList(playerTeams) ?? [],
      allFormatStats: AllFormatStats.fromJson(allFormatStats),
    );
  }

  PlayerCricketDetails copywith({
    CricketRole? cricketRole,
    Position? battingPosition,
    Position? bowlingArm,
    BowlingStyle? bowlingStyle,
    bool? isPrivate,
    List? achievements,
    List? requestedTeams,
    List<TeamDetails>? teams,
    AllFormatStats? allFormatStats,
  }) {
    return PlayerCricketDetails(
      cricketRole: cricketRole ?? this.cricketRole,
      battingPosition: battingPosition ?? this.battingPosition,
      bowlingArm: bowlingArm ?? this.bowlingArm,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      isPrivate: isPrivate ?? this.isPrivate,
      achievements: achievements ?? this.achievements,
      requestedTeams: requestedTeams ?? this.requestedTeams,
      teams: teams ?? this.teams,
      allFormatStats: allFormatStats ?? this.allFormatStats,
    );
  }

  static CricketRole getCricketRole(String role) {
    switch (role) {
      case 'batsman':
        return CricketRole.batsman;
      case 'bowler':
        return CricketRole.bowler;
      case 'allRounder':
        return CricketRole.allRounder;
      case 'wicketKeeper':
        return CricketRole.wicketKeeper;
      default:
        return CricketRole.batsman;
    }
  }

  static Position? getPosition(String? position) {
    if (position == null) return null;
    switch (position) {
      case 'righty':
        return Position.righty;
      case 'lefty':
        return Position.lefty;
      default:
        return Position.righty;
    }
  }

  static BowlingStyle getBowlingStyle(String style) {
    for (final bStyle in BowlingStyle.values) {
      if (bStyle.name == style) return bStyle;
    }
    return BowlingStyle.none;
  }

  String formatBowlingStyle() {
    // Convert enum value to string and remove the enum type prefix
    String enumString = bowlingStyle.toString().split('.').last;

    // Convert camelCase to a readable format
    String formattedString = enumString.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match match) => '${match.group(1)} ${match.group(2)}',
    );

    // Capitalize the first letter
    return formattedString[0].toUpperCase() +
        formattedString.substring(1).toLowerCase();
  }

  static List<TeamDetails>? playerTeamsToList(
          List<QueryDocumentSnapshot>? teams) =>
      teams?.map(
        (team) {
          final teamInfo = team.data()! as Map<String, dynamic>;
          return TeamDetails.formMap(teamInfo);
        },
      ).toList();

  String get detailedCricketRole {
    String result = '';

    if (battingPosition == Position.righty) {
      result += 'Right-handed ';
    } else if (battingPosition == Position.lefty) {
      result += 'Left-handed ';
    }
    result += 'Batsman';

    if (bowlingStyle != BowlingStyle.none) {
      result += ' | ';
      if (bowlingArm == Position.righty) {
        result += 'Right-arm ';
      } else if (bowlingArm == Position.lefty) {
        result += 'Left-arm ';
      }
      result += formatBowlingStyle();
      result += ' Bowler';
    }
    return result;
  }

  // ... rest of the implementation
}
