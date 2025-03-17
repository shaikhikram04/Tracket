import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
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
  List<MatchPlayerInfo> _openers = [];
  MatchPlayerInfo? _bowler;
  bool isStarting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onStart(List<MatchPlayerInfo> players) async {
    setState(() {
      isStarting = true;
    });

    ref.read(matchStateProvider.notifier).startFirstInning();

    final match = ref.read(matchStateProvider)!;

    final inning1 = match.initializeFirstInnings(bowlerId: _bowler!.playerId);
    try {
      final striker = BattingScore(
        uuid: _openers[0].playerId,
        playerName: _openers[0].playerName,
        battingPosition: 1,
      );

      final nonStriker = BattingScore(
        uuid: _openers[1].playerId,
        playerName: _openers[1].playerName,
        battingPosition: 2,
      );

      final bowler = BowlingScore(
        uuid: _bowler!.playerId,
        playerName: _bowler!.playerName,
      );

      await MatchesServices.startMatch(
        matchId: match.id,
        isTeam1WonToss: match.isTeam1WonToss!,
        decision: match.tossDecision!,
        inning1: inning1,
        striker: striker,
        nonStriker: nonStriker,
        bowler: bowler,
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
                                    color: grassGreen,
                                  ),
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
              onPressed: _openers.isNotEmpty && _bowler != null
                  ? () => _onStart(match.getBattingTeamPlayers())
                  : null,
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
