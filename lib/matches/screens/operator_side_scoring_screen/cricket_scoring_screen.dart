import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/player_stats_section.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/scoreboard_section.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/scoring_controls.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class CricketScoringScreen extends ConsumerStatefulWidget {
  const CricketScoringScreen({Key? key}) : super(key: key);

  @override
  _CricketScoringScreenState createState() => _CricketScoringScreenState();
}

class _CricketScoringScreenState extends ConsumerState<CricketScoringScreen> {
  late ValueNotifier<bool> isLoading;
  bool _isBlur = false;

  @override
  void initState() {
    super.initState();
    isLoading = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        loadMatchData();
      },
    );
  }

  void loadMatchData() {
    setState(() {
      isLoading.value = true;
    });
    Match match = Match(
      team1: MatchTeamInfo(
        teamId: '1',
        captainId: '12',
        logoUrl: '',
        shortName: 'T1',
        teamName: 'Team1',
        wicketkeeperId: '13',
      ),
      team2: MatchTeamInfo(
        teamId: '2',
        captainId: '21',
        logoUrl: '',
        shortName: 'T2',
        teamName: 'Team2',
        wicketkeeperId: '21',
      ),
      team1Players: [
        MatchPlayerInfo(
          playerId: '11',
          cricketRole: CricketRole.batsman,
          playerName: 'Player 1',
          profileImageUrl: '',
          longCricketRole: 'Right-handed .......',
          battingStatus: BattingStatus.playing,
        ),
        MatchPlayerInfo(
          playerId: '12',
          cricketRole: CricketRole.allRounder,
          playerName: 'Player 2',
          profileImageUrl: '',
          longCricketRole: 'Right-handed .......',
          battingStatus: BattingStatus.playing,
        ),
        MatchPlayerInfo(
          playerId: '13',
          cricketRole: CricketRole.bowler,
          playerName: 'Player 3',
          profileImageUrl: '',
          longCricketRole: 'Right-handed .......',
          battingStatus: BattingStatus.notOut,
        ),
      ],
      team2Players: [
        MatchPlayerInfo(
          playerId: '21',
          cricketRole: CricketRole.batsman,
          playerName: 'Player 1',
          profileImageUrl: '',
          longCricketRole: 'Right-handed .......',
          battingStatus: BattingStatus.notOut,
        ),
        MatchPlayerInfo(
          playerId: '22',
          cricketRole: CricketRole.allRounder,
          playerName: 'Player 2',
          profileImageUrl: '',
          longCricketRole: 'Right-handed .......',
          battingStatus: BattingStatus.notOut,
        ),
        MatchPlayerInfo(
          playerId: '23',
          cricketRole: CricketRole.bowler,
          playerName: 'Player 3',
          profileImageUrl: '',
          longCricketRole: 'Right-handed .......',
          battingStatus: BattingStatus.notOut,
        ),
      ],
      noOfPlayer: 3,
      matchFormat: MatchFormat.over5,
      matchType: MatchType.friendly,
      venue: 'Wafa Complex',
      schedule: DateTime.now(),
      isTeam1WonToss: true,
      createdAt: Timestamp.now(),
      tossDecision: TossDecision.batting,
      spectatorsAllowed: true,
      updatedAt: Timestamp.now(),
      currentBatsmen: [
        StrikerData(
          id: '11',
          playerName: 'Player 1',
          runs: 0,
          balls: 0,
        ),
        StrikerData(
          id: '12',
          playerName: 'Player 2',
          runs: 0,
          balls: 0,
        ),
      ],
      strikerIndex: 0,
      currentBowlers: CurrentBowlerData(
        playerName: 'Player 3',
        id: '23',
        runsGiven: 0,
        wickets: 0,
        balls: 0,
      ),
      participants: ['1', '2'],
    );

    ref.read(matchStateProvider.notifier).createMatch(
          team1: match.team1,
          team2: match.team2,
          team1Players: match.team1Players,
          team2Players: match.team2Players,
          matchFormat: match.matchFormat,
          matchType: match.matchType,
          venue: match.venue,
          schedule: match.schedule,
          noOfPlayer: match.noOfPlayer,
        );
    ref
        .read(matchStateProvider.notifier)
        .setTossResult(match.isTeam1WonToss!, match.tossDecision!);

    ref.read(matchStateProvider.notifier).startFirstInnings();

    ref.read(matchStateProvider.notifier).updateStrikers(
          batsmen: match.currentBatsmen,
          strikerIndex: match.strikerIndex,
        );

    ref
        .read(matchStateProvider.notifier)
        .setCurrentBowler(match.currentBowlers);

    setState(() {
      isLoading.value = false;
    });
  }

  void _onExtraButtonTab() {
    setState(() {
      _isBlur = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchStateProvider);

    return Scaffold(
      backgroundColor: LightThemeColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: LightThemeColors.primaryText,
        elevation: 0,
        title: Text(
          'Live Scoring',
          style: GoogleFonts.poppins(
            color: LightThemeColors.surfaceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: LightThemeColors.primaryText),
            onPressed: () {
              // Implement undo functionality
            },
          ),
        ],
      ),
      body: isLoading.value == true
          ? getCircleLoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Score Summary Section
                  ScoreboardSection(
                    matchState: matchState!,
                    isBlur: _isBlur,
                  ),

                  // Current Over Indicator with animation
                  CurrentOverIndicator(
                    balls: matchState.currentOverRuns,
                    isBlur: _isBlur,
                    remainingBalls:
                        ref.watch(matchStateProvider.notifier).remainingBalls,
                  ),

                  // Player Stats Section with cards
                  PlayerStatsSection(
                    striker: matchState.currentBatsmen![0],
                    nonStriker: matchState.currentBatsmen![1],
                    bowler: matchState.currentBowlers!,
                    strikerIndex: matchState.strikerIndex,
                    isBlur: _isBlur,
                  ),

                  ScoringControls(
                    onExtra: _onExtraButtonTab,
                    isBlur: _isBlur,
                    makeUnBlur: () {
                      setState(() {
                        _isBlur = false;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
