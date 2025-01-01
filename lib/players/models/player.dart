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
  final String? profileImageUrl;
  final List<Map<String, dynamic>>? teams;
  final List? achievements;
  final CricketRole? cricketRole;
  final Position? battingPosition;
  final PlayerStats? playerStats;
  final Position? bowlingArm;
  final BowlingStyle? bowlingStyle;
  final Timestamp createdAt;
  final bool? allowDirectTeamAdd;

  Player({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.achievements,
    required this.teams,
    required this.profileImageUrl,
    required this.following,
    required this.followers,
    required this.cricketRole,
    required this.battingPosition,
    required this.bowlingArm,
    required this.bowlingStyle,
    required this.createdAt,
    required this.playerStats,
    required this.allowDirectTeamAdd,
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
  })  : battingPosition = null,
        bowlingArm = null,
        bowlingStyle = null,
        cricketRole = null,
        playerStats = null,
        teams = null,
        achievements = null,
        allowDirectTeamAdd = null;

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
        'allowDirectTeamAdd': allowDirectTeamAdd,
        'achievements': achievements,
        'following': following,
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
      followers: snap['followers'],
      allowDirectTeamAdd: snap['allowDirectTeamAdd'],
    );
  }
}
