import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/match_status_card.dart';
import 'package:tracket/matches/widgets/scoreboard_component/scoreboard_section.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        MatchPlayerInfo(
          playerId: '12',
          cricketRole: CricketRole.allRounder,
          playerName: 'Player 2',
          profileImageUrl: '',
        ),
        MatchPlayerInfo(
          playerId: '13',
          cricketRole: CricketRole.bowler,
          playerName: 'Player 3',
          profileImageUrl: '',
        ),
      ],
      team2Players: [
        MatchPlayerInfo(
          playerId: '21',
          cricketRole: CricketRole.batsman,
          playerName: 'Player 1',
          profileImageUrl: '',
        ),
        MatchPlayerInfo(
          playerId: '22',
          cricketRole: CricketRole.allRounder,
          playerName: 'Player 2',
          profileImageUrl: '',
        ),
        MatchPlayerInfo(
          playerId: '23',
          cricketRole: CricketRole.bowler,
          playerName: 'Player 3',
          profileImageUrl: '',
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

    match.initializeFirstInnings();

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          MatchStatusCard(
            match: match,
          ),
          ScoreboardSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Toss : ',
                    style:
                        MyTextStyle(context).coloredBodyLarge(darkGreenColor),
                  ),
                  TextSpan(text: 'Team 1 won the toss and decided to bat first')
                ])),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Venue : ',
                    style:
                        MyTextStyle(context).coloredBodyLarge(darkGreenColor),
                  ),
                  TextSpan(text: 'Wafa Complex')
                ])),
              ],
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Match Details'),
      backgroundColor: whiteColor,
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(color: Colors.black12, width: 0.5),
      ),
    );
  }
}
