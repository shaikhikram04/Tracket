import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/opening_batsman_sheet.dart';
import 'package:tracket/matches/widgets/opening_bowler_sheet.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/players/widgets/squad_player_tile.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class MatchPlayersSelectionScreen extends StatefulWidget {
  const MatchPlayersSelectionScreen({super.key});

  @override
  State<MatchPlayersSelectionScreen> createState() =>
      _MatchPlayersSelectionScreenState();
}

class _MatchPlayersSelectionScreenState
    extends State<MatchPlayersSelectionScreen> {
  Match match = Match(
    participants: ['1', '2'],
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
    matchFormat: MatchFormat.over10,
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
  );

  List<MatchPlayerInfo> _openers = [];
  List<MatchPlayerInfo> _bowler = [];

  Future<void> _showOpeningBatsmenSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OpeningBatsmenSheet(
          availablePlayers: match.team1Players,
          onConfirm: (MatchPlayerInfo striker, MatchPlayerInfo nonStriker) {
            setState(() {
              _openers = [striker, nonStriker];
            });
          },
        );
      },
    );
  }

  Future<void> _showOpeningBowlerSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OpeningBowlerSheet(
          availablePlayers: match.team2Players,
          onConfirm: (MatchPlayerInfo bowler) {
            setState(() {
              _bowler = [bowler];
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        onTap: _showOpeningBatsmenSheet,
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
                _bowler.isEmpty
                    ? InkWell(
                        onTap: _showOpeningBowlerSheet,
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
                            cricketRole: _bowler.first.longCricketRole,
                            playerName: _bowler.first.playerName,
                            profileImageUrl: _bowler.first.profileImageUrl,
                            playerId: _bowler.first.playerId,
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
                  _openers.isNotEmpty && _bowler.isNotEmpty ? () {} : null,
              text: 'Start Match',
              backgroundColor: grassGreen,
              borderRadius: 15,
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
