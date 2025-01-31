// Data class for player signup
import 'package:tracket/players/models/player_cricket_detail.dart';

class PlayerSignupData {
  final String playerId;
  final String playerName;
  final String email;
  final CricketRole cricketRole;
  final Position battingPosition;
  final BowlingStyle bowlingStyle;
  final Position? bowlingArm;
  final String imageUrl;

  PlayerSignupData({
    required this.playerId,
    required this.playerName,
    required this.email,
    required this.cricketRole,
    required this.battingPosition,
    required this.bowlingStyle,
    this.bowlingArm,
    required this.imageUrl,
  });
}
