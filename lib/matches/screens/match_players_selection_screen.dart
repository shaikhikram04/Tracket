import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/players_selection_dialog.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/players/widgets/squad_player_tile.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
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
      ),
      MatchPlayerInfo(
        playerId: '12',
        cricketRole: CricketRole.allRounder,
        playerName: 'Player 2',
        profileImageUrl: '',
        longCricketRole: 'Right-handed .......',
      ),
      MatchPlayerInfo(
        playerId: '13',
        cricketRole: CricketRole.bowler,
        playerName: 'Player 3',
        profileImageUrl: '',
        longCricketRole: 'Right-handed .......',
      ),
    ],
    team2Players: [
      MatchPlayerInfo(
        playerId: '21',
        cricketRole: CricketRole.batsman,
        playerName: 'Player 1',
        profileImageUrl: '',
        longCricketRole: 'Right-handed .......',
      ),
      MatchPlayerInfo(
        playerId: '22',
        cricketRole: CricketRole.allRounder,
        playerName: 'Player 2',
        profileImageUrl: '',
        longCricketRole: 'Right-handed .......',
      ),
      MatchPlayerInfo(
        playerId: '23',
        cricketRole: CricketRole.bowler,
        playerName: 'Player 3',
        profileImageUrl: '',
        longCricketRole: 'Right-handed .......',
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
    stricker: [
      StrikerData(runs: 0, balls: 0, id: '11', playerName: 'Player 1'),
      StrikerData(runs: 0, balls: 0, id: '12', playerName: 'Player 2'),
    ],
    currentBowlers: [
      CurrentBowlerData(
        playerName: 'Player 3',
        id: '23',
        runsGiven: 0,
        wickets: 0,
        balls: 0,
      )
    ],
  );

  List<MatchPlayerInfo> _openers = [];
  List<MatchPlayerInfo> _bowler = [];

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
                        onTap: () async {
                          final selectedPlayers = await showDialog(
                            context: context,
                            builder: (context) => PlayersSelectionDialog(
                              playerList: match.team1Players,
                              selectedPlayers: _openers,
                              noOfPlayerCanBeSelected: 2,
                            ),
                          );

                          if (selectedPlayers != null) {
                            setState(() {
                              _openers = List.from(selectedPlayers);
                            });
                          }
                        },
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
                                  color: darkGreenColor),
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
                        onTap: () async {
                          final selectedPlayers = await showDialog(
                            context: context,
                            builder: (context) => PlayersSelectionDialog(
                              playerList: match.team2Players,
                              selectedPlayers: _bowler,
                              noOfPlayerCanBeSelected: 1,
                            ),
                          );

                          if (selectedPlayers != null) {
                            setState(() {
                              _bowler = List.from(selectedPlayers);
                              ;
                            });
                          }
                        },
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
                                  color: darkGreenColor),
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
            child: MyElevatedButton.primaryElevatedButton(
              onPressed: () {},
              text: 'Start Match',
              backgroundColor: darkGreenTextColor,
              borderRadius: 15,
              textStyle: MyTextStyle(context).titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
