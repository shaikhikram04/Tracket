import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/players/models/player_stats.dart';

enum CricketRole {
  batsman,
  bowler,
  allRounder,
  wicketKeeper,
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

class Player {
  final String id;
  final String email;
  final String name;
  final String role;
  final List following;
  final List followers;
  final List followingTeams;
  final String profileImageUrl;
  final List<Map<String, dynamic>>? teams;
  final List? achievements;
  final CricketRole? cricketRole;
  final Position? battingPosition;
  final PlayerStats? playerStats;
  final Position? bowlingArm;
  final BowlingStyle? bowlingStyle;
  final Timestamp createdAt;
  final bool? isPrivate;

  Player({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.achievements,
    required this.teams,
    required this.profileImageUrl,
    required this.following,
    required this.followingTeams,
    required this.followers,
    required this.cricketRole,
    required this.battingPosition,
    required this.bowlingArm,
    required this.bowlingStyle,
    required this.createdAt,
    required this.playerStats,
    required this.isPrivate,
  });

  Player.user({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.createdAt,
    required this.following,
    required this.followers,
    required this.followingTeams,
  })  : battingPosition = null,
        bowlingArm = null,
        bowlingStyle = null,
        cricketRole = null,
        playerStats = null,
        teams = null,
        achievements = null,
        isPrivate = null;

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

  static Position getPosition(String position) {
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
    switch (style) {
      case 'fast':
        return BowlingStyle.fast;
      case 'mediumFast':
        return BowlingStyle.mediumFast;
      case 'legSpin':
        return BowlingStyle.legSpin;
      case 'offSpin':
        return BowlingStyle.offSpin;
      case 'chinaMan':
        return BowlingStyle.chinaMan;
      case 'none':
        return BowlingStyle.none;
      default:
        return BowlingStyle.none;
    }
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

  String get detailedCricketRole {
    String result = '';
    if (cricketRole == CricketRole.batsman ||
        cricketRole == CricketRole.wicketKeeper ||
        cricketRole == CricketRole.allRounder) {
      if (battingPosition == Position.righty) {
        result += 'Right-handed ';
      } else if (battingPosition == Position.lefty) {
        result += 'Left-handed ';
      }
      result += 'Batsman';
    }
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

  Map<String, dynamic> get toJsonForPlayer => {
        'playerId': id,
        'email': email,
        'playerName': name,
        'role': role,
        'profileImageUrl': profileImageUrl,
        'cricketRole': cricketRole!.name,
        'battingPosition': battingPosition!.name,
        'bowlingArm': bowlingArm?.name,
        'bowlingStyle': bowlingStyle!.name,
        'createdAt': createdAt,
        'isPrivate': isPrivate,
        'achievements': achievements,
        'following': following,
        'followingTeams': followingTeams,
        'followers': followers,
        ...playerStats!.toJson,
      };

  static List<Map<String, dynamic>>? playerTeamsToList(
          List<QueryDocumentSnapshot>? teams) =>
      teams?.map(
        (team) {
          final teamInfo = team.data()! as Map<String, dynamic>;
          return teamInfo;
        },
      ).toList();

  List<String> get playerTeamsId {
    List<String> teamsId = [];
    teamsId = teams!.map((team) => team['id'].toString()).toList();

    return teamsId;
  }

  Map<String, dynamic> get toJsonForUser => {
        'userId': id,
        'email': email,
        'username': name,
        'role': role,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt,
        'following': following,
        'followers': followers,
        'followingTeams': followingTeams,
      };

  static Player fromSeed(
      Map<String, dynamic> snap, List<QueryDocumentSnapshot>? playerTeams) {
    return Player(
      role: snap['role'],
      id: snap['playerId'],
      name: snap['playerName'],
      email: snap['email'],
      profileImageUrl: snap['profileImageUrl'],
      cricketRole: getCricketRole(snap['cricketRole']),
      battingPosition: getPosition(snap['battingPosition']),
      bowlingArm: getPosition(snap['bowlingArm']),
      bowlingStyle: getBowlingStyle(snap['bowlingStyle']),
      createdAt: snap['createdAt'],
      teams: playerTeamsToList(playerTeams),
      playerStats: PlayerStats(
        ballDelivered: snap['ballDelivered'],
        ballsFaced: snap['ballsFaced'],
        fifties: snap['fifties'],
        four: snap['four'],
        highestScore: snap['highestScore'],
        hundreds: snap['hundreds'],
        maiden: snap['maiden'],
        runGiven: snap['runGiven'],
        six: snap['six'],
        totalRuns: snap['totalRuns'],
        wicket: snap['wicket'],
        matches: snap['matches'],
        innings: snap['innings'],
        bestBallingFigure: BowlingFigure(
          wicket: snap['bestBallingFigure']['wicket'],
          runGiven: snap['bestBallingFigure']['runGiven'],
          ballDelivered: snap['bestBallingFigure']['ballDelivered'],
        ),
      ),
      achievements: snap['achievements'],
      following: snap['following'],
      followingTeams: snap['followingTeams'],
      followers: snap['followers'],
      isPrivate: snap['isPrivate'],
    );
  }
}
