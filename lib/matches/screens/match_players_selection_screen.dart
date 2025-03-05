import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/cricket_scoring_screen.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/matches/widgets/opening_batsman_sheet.dart';
import 'package:tracket/matches/widgets/opening_bowler_sheet.dart';
import 'package:tracket/players/widgets/squad_player_tile.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class MatchPlayersSelectionScreen extends ConsumerStatefulWidget {
  const MatchPlayersSelectionScreen({super.key});

  @override
  ConsumerState<MatchPlayersSelectionScreen> createState() =>
      _MatchPlayersSelectionScreenState();
}

class _MatchPlayersSelectionScreenState
    extends ConsumerState<MatchPlayersSelectionScreen> {
  // Match match = Match(
  //   participants: ['1', '2'],
  //   challengerPlayerId: '12',
  //   challengeAcceptedBy: '21',
  //   team1: MatchTeamInfo(
  //     teamId: '1',
  //     captainId: '12',
  //     logoUrl: '',
  //     shortName: 'T1',
  //     teamName: 'Team1',
  //     wicketkeeperId: '13',
  //   ),
  //   team2: MatchTeamInfo(
  //     teamId: '2',
  //     captainId: '21',
  //     logoUrl: '',
  //     shortName: 'T2',
  //     teamName: 'Team2',
  //     wicketkeeperId: '21',
  //   ),
  //   team1Players: [
  //     MatchPlayerInfo(
  //       playerId: '11',
  //       cricketRole: CricketRole.batsman,
  //       playerName: 'Player 1',
  //       profileImageUrl: '',
  //       longCricketRole: 'Right-handed .......',
  //       battingStatus: BattingStatus.playing,
  //     ),
  //     MatchPlayerInfo(
  //       playerId: '12',
  //       cricketRole: CricketRole.allRounder,
  //       playerName: 'Player 2',
  //       profileImageUrl: '',
  //       longCricketRole: 'Right-handed .......',
  //       battingStatus: BattingStatus.playing,
  //     ),
  //     MatchPlayerInfo(
  //       playerId: '13',
  //       cricketRole: CricketRole.bowler,
  //       playerName: 'Player 3',
  //       profileImageUrl: '',
  //       longCricketRole: 'Right-handed .......',
  //       battingStatus: BattingStatus.notOut,
  //     ),
  //   ],
  //   team2Players: [
  //     MatchPlayerInfo(
  //       playerId: '21',
  //       cricketRole: CricketRole.batsman,
  //       playerName: 'Player 1',
  //       profileImageUrl: '',
  //       longCricketRole: 'Right-handed .......',
  //       battingStatus: BattingStatus.notOut,
  //     ),
  //     MatchPlayerInfo(
  //       playerId: '22',
  //       cricketRole: CricketRole.allRounder,
  //       playerName: 'Player 2',
  //       profileImageUrl: '',
  //       longCricketRole: 'Right-handed .......',
  //       battingStatus: BattingStatus.notOut,
  //     ),
  //     MatchPlayerInfo(
  //       playerId: '23',
  //       cricketRole: CricketRole.bowler,
  //       playerName: 'Player 3',
  //       profileImageUrl: '',
  //       longCricketRole: 'Right-handed .......',
  //       battingStatus: BattingStatus.notOut,
  //     ),
  //   ],
  //   noOfPlayer: 3,
  //   matchFormat: MatchFormat.over10,
  //   matchType: MatchType.friendly,
  //   venue: 'Wafa Complex',
  //   schedule: DateTime.now(),
  //   isTeam1WonToss: true,
  //   createdAt: Timestamp.now(),
  //   tossDecision: TossDecision.batting,
  //   spectatorsAllowed: true,
  //   updatedAt: Timestamp.now(),
  //   currentBatsmen: [
  //     StrikerData(
  //       id: '11',
  //       playerName: 'Player 1',
  //       runs: 0,
  //       balls: 0,
  //     ),
  //     StrikerData(
  //       id: '12',
  //       playerName: 'Player 2',
  //       runs: 0,
  //       balls: 0,
  //     ),
  //   ],
  //   strikerIndex: 0,
  //   currentBowlers: CurrentBowlerData(
  //     playerName: 'Player 3',
  //     id: '23',
  //     runsGiven: 0,
  //     wickets: 0,
  //     balls: 0,
  //   ),
  // );

  List<MatchPlayerInfo> _openers = [];
  MatchPlayerInfo? _bowler;
  bool isStarting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onStart() async {
    setState(() {
      isStarting = true;
    });

    ref.read(matchStateProvider.notifier).startFirstInning();

    final match = ref.read(matchStateProvider)!;

    final inning1 = match.initializeFirstInnings(
      striker: _openers.first,
      nonStriker: _openers.last,
      bowler: _bowler!,
    );
    try {
      await MatchesServices.startMatch(
        matchId: match.id,
        isTeam1WonToss: match.isTeam1WonToss!,
        decision: match.tossDecision!,
        inning1: inning1,
        striker: _openers[0],
        nonStriker: _openers[1],
        bowler: _bowler!,
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CricketScoringScreen(),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      showSnackBar('Failed to start match : $e', context);
    } finally {
      setState(() {
        isStarting = false;
      });
    }
  }

  Future<void> _showOpeningBatsmenSheet(List<MatchPlayerInfo> players) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OpeningBatsmenSheet(
          availablePlayers: players,
          onConfirm: (MatchPlayerInfo striker, MatchPlayerInfo nonStriker) {
            setState(() {
              _openers = [striker, nonStriker];
            });
          },
        );
      },
    );
  }

  Future<void> _showOpeningBowlerSheet(List<MatchPlayerInfo> players) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OpeningBowlerSheet(
          availablePlayers: players,
          onConfirm: (MatchPlayerInfo bowler) {
            setState(() {
              _bowler = bowler;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final match = ref.watch(matchStateProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Players'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          MyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getTitleText('Opening Batsman', context),
                SizedBox(height: 15),
                _openers.isEmpty
                    ? InkWell(
                        onTap: () => _showOpeningBatsmenSheet(
                            match.getBattingTeamPlayers()),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Select Openers',
                              style: MyTextStyle(context).bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: grassGreen),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SquadPlayerTile(
                            cricketRole: _openers[0].longCricketRole,
                            playerName: _openers[0].playerName,
                            profileImageUrl: _openers[0].profileImageUrl,
                            playerId: _openers[0].playerId,
                          ),
                          SquadPlayerTile(
                            cricketRole: _openers[1].longCricketRole,
                            playerName: _openers[1].playerName,
                            profileImageUrl: _openers[1].profileImageUrl,
                            playerId: _openers[1].playerId,
                          ),
                        ],
                      )
              ],
            ),
          ),
          MyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getTitleText('Opening Bowler', context),
                SizedBox(height: 10),
                _bowler == null
                    ? InkWell(
                        onTap: () => _showOpeningBowlerSheet(
                            match.getBowlingTeamPlayers()),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Select Opening bowler',
                              style: MyTextStyle(context).bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: darkGrassGreen),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SquadPlayerTile(
                            cricketRole: _bowler!.longCricketRole,
                            playerName: _bowler!.playerName,
                            profileImageUrl: _bowler!.profileImageUrl,
                            playerId: _bowler!.playerId,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomButton.primary(
              onPressed:
                  _openers.isNotEmpty && _bowler != null ? _onStart : null,
              text: 'Start Match',
              backgroundColor: grassGreen,
              borderRadius: 15,
              isLoading: isStarting,
              textStyle: MyTextStyle(context).titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: LightThemeColors.surfaceColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
