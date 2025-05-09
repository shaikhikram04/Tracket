// Player-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/authentication/models/player_signup_data.dart';
import 'package:tracket/features/players/models/all_format_stats.dart';
import 'package:tracket/features/players/models/bowling_stats.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/features/players/models/player_stats.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class PlayerAuthService {
  // Private constructor to prevent instantiation
  PlayerAuthService._();

  // Firebase instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Game format constants - these could be moved to TTextStrings if reused elsewhere
  static const List<String> _gameFormats = [
    TTextStrings.over5Key,
    TTextStrings.over10Key,
    TTextStrings.over20Key,
    TTextStrings.over50Key,
    TTextStrings.testKey,
  ];

  //* Signs up a player with the provided data
  ///
  /// Returns [TTextStrings.success] on success or error message on failure
  static Future<String> signupPlayer({
    required PlayerSignupData data,
  }) async {
    try {
      // Validate required fields
      _validatePlayerData(data);

      // Create player document with all required data
      final player = _createPlayerDocument(data);

      // Save player data to Firestore in a batch transaction
      await _savePlayerData(data.playerId, player);

      return TTextStrings.success;
    } catch (e) {
      // Log the error for debugging
      print('Player signup error: $e');
      return e.toString();
    }
  }

  /// Validates required player data fields
  static void _validatePlayerData(PlayerSignupData data) {
    if (data.playerId.isEmpty) {
      throw ArgumentError('Player ID cannot be empty');
    }

    if (data.playerName.isEmpty) {
      throw ArgumentError('Player name cannot be empty');
    }

    if (data.email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
  }

  /// Creates a complete player document from signup data
  static Player _createPlayerDocument(PlayerSignupData data) {
    // Determine if player can bowl based on their cricket role
    final bool cantBowl = _playerCantBowl(data.cricketRole);

    // Create cricket details with appropriate stats based on player role
    final playerCricketDetail = _createPlayerCricketDetails(data, cantBowl);

    // Create and return the complete player document
    return Player(
      name: data.playerName,
      email: data.email,
      createdAt: Timestamp.now(),
      id: data.playerId,
      role: TTextStrings.playerRole,
      profileImageUrl: data.imageUrl,
      following: const [],
      followingTeams: const [],
      followers: const [],
      playerCricketDetails: playerCricketDetail,
    );
  }

  /// Determines if a player can bowl based on their role
  static bool _playerCantBowl(CricketRole cricketRole) {
    return cricketRole == CricketRole.batsman || cricketRole == CricketRole.wicketKeeper;
  }

  /// Creates cricket details with appropriate stats based on player role
  static PlayerCricketDetails _createPlayerCricketDetails(PlayerSignupData data, bool cantBowl) {
    // Create a map of all format stats for the player
    final allFormatStats = AllFormatStats(
      over5: _createDefaultPlayerStats(cantBowl),
      over10: _createDefaultPlayerStats(cantBowl),
      over20: _createDefaultPlayerStats(cantBowl),
      over50: _createDefaultPlayerStats(cantBowl),
      test: _createDefaultPlayerStats(cantBowl),
    );

    return PlayerCricketDetails(
      cricketRole: data.cricketRole,
      battingPosition: data.battingPosition,
      bowlingArm: data.bowlingArm,
      bowlingStyle: data.bowlingStyle,
      isPrivate: false,
      achievements: const [],
      requestedTeams: const [],
      teams: const [],
      allFormatStats: allFormatStats,
    );
  }

  /// Creates default player stats based on whether they can bowl
  static PlayerStats _createDefaultPlayerStats(bool cantBowl) {
    return PlayerStats(
      bowlingStats: cantBowl ? null : const BowlingStats(),
    );
  }

  /// Saves player data to Firestore using a batch operation
  static Future<void> _savePlayerData(String playerId, Player player) async {
    // Create a batch operation for atomic writes
    final WriteBatch batch = _firestore.batch();

    // Reference to the player document
    final DocumentReference playerDocRef = _firestore.collection(FirestoreCollections.players).doc(playerId);

    // Add player document to batch
    batch.set(playerDocRef, player.toJsonForPlayer);

    // Add stats documents to batch
    final playerCricketDetails = player.playerCricketDetails;
    final allFormatStats = playerCricketDetails!.allFormatStats;

    // Map of format keys to their corresponding stats
    final Map<String, Map<String, dynamic>> statsMap = {
      TTextStrings.over5Key: allFormatStats.over5.toJson,
      TTextStrings.over10Key: allFormatStats.over10.toJson,
      TTextStrings.over20Key: allFormatStats.over20.toJson,
      TTextStrings.over50Key: allFormatStats.over50.toJson,
      TTextStrings.testKey: allFormatStats.test.toJson,
    };

    // Add all stats documents to the batch
    for (final format in _gameFormats) {
      final DocumentReference statsDocRef = playerDocRef.collection(FirestoreCollections.stats).doc(format);

      batch.set(statsDocRef, statsMap[format]!);
    }

    // Commit the batch operation
    await batch.commit();
  }
}
