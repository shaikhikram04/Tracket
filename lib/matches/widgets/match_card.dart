import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/screens/match_scoring_screen.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key});

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

    match.initializeFirstInnings();

    return GestureDetector(
      onTap: () => pushScreen(
          context,
          MatchScoringScreen(
            match: match,
          )),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Match 1',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  match.status == MatchStatus.live
                      ? HighlightedLabel(text: 'LIVE', textColor: primaryColor)
                      : Text(
                          DateFormat.Hm().format(match.schedule),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Team A
                  Expanded(
                    child: Column(
                      children: [
                        getCircleAvatar(url: '', isTeam: true, radius: 32),
                        const SizedBox(height: 8),
                        Text(
                          match.team1.teamName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        match.inning1 != null
                            ? Text(
                                '${match.inning1!.runs}/${match.inning1!.wickets}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : Text(
                                'Yet to bat',
                                style: MyTextStyle(context).bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                        if (match.inning1 != null)
                          Text(
                            '(${match.inning1!.oversDisplay})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // VS Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        getCircleAvatar(url: '', isTeam: true, radius: 32),
                        const SizedBox(height: 8),
                        Text(
                          match.team2.teamName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        match.inning2 != null
                            ? Text(
                                '${match.inning2!.runs}/${match.inning2!.wickets}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : Text(
                                'Yet to bat',
                                style: MyTextStyle(context).bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                        if (match.inning2 != null)
                          Text(
                            '(${match.inning1!.oversDisplay})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              // Current Players
              Row(
                children: [
                  // Batsmen
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Batsmen',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${match.stricker[0].playerName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${match.stricker[0].runs} (${match.stricker[0].balls})',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${match.stricker[1].playerName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${match.stricker[1].runs} (${match.stricker[1].balls})',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bowler
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Bowler',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match.currentBowlers.first.playerName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${match.currentBowlers.first.runsGiven}/${match.currentBowlers.first.wickets} (${match.currentBowlers.first.oversDisplay})',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
