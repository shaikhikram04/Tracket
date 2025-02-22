import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/screens/match_scoring_screen.dart';
import 'package:tracket/matches/screens/start_match_screen.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    Match _match = match;
    final String currentUserId = FirebaseAuthMethods().currentUserId;

    return GestureDetector(
      onTap: () => pushScreen(
          context,
          MatchScoringScreen(
            match: _match,
          )),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        color: LightThemeColors.surfaceColor,
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
                      color: LightThemeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _match.status == MatchStatus.live
                      ? HighlightedLabel(
                          text: 'LIVE',
                          textStyle: MyTextStyle(context).bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: StatusColors.liveMatch,
                              ),
                          color: StatusColors.liveMatch.withValues(alpha: 0.2),
                        )
                      : Text(
                          DateFormat.MMMEd().format(_match.schedule),
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
                  _buildMatchTeamColumn(
                    context,
                    team: _match.team1,
                    isMatchStarted: _match.status == MatchStatus.live ||
                        _match.status == MatchStatus.completed,
                    isInningStarted: _match.inning1 != null,
                    runs: _match.inning1?.runs,
                    wickets: _match.inning1?.wickets,
                    oversDisplay: _match.inning1?.oversDisplay,
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

                  // Team B
                  _buildMatchTeamColumn(
                    context,
                    team: _match.team2,
                    isMatchStarted: _match.status == MatchStatus.live ||
                        _match.status == MatchStatus.completed,
                    isInningStarted: _match.inning2 != null,
                    runs: _match.inning2?.runs,
                    wickets: _match.inning2?.wickets,
                    oversDisplay: _match.inning2?.oversDisplay,
                  ),
                ],
              ),
              if (_match.status == MatchStatus.scheduled) ...[
                Text(
                  'Starts at ${DateFormat('hh:mm a').format(_match.schedule)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (_match.schedule.isBefore(DateTime.now()) &&
                    (_match.challengerPlayerId == currentUserId ||
                        _match.challengeAcceptedBy == currentUserId)) ...[
                  const SizedBox(height: 10),
                  CustomButton.primary(
                    text: 'Start Match',
                    borderRadius: 16,
                    onPressed: () {
                      pushScreen(
                          context,
                          StartMatchScreen(
                            match: _match,
                          ));
                    },
                  ),
                ]
              ],
              if (_match.status == MatchStatus.live) ...[
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
                          _buildStatsSubtitle(context, 'Batsmen'),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildMatchPlayerText(
                                context,
                                _match.currentBatsmen![0].playerName,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_match.currentBatsmen![0].runs} (${_match.currentBatsmen![0].balls})',
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
                              _buildMatchPlayerText(
                                context,
                                _match.currentBatsmen![1].playerName,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_match.currentBatsmen![1].runs} (${_match.currentBatsmen![1].balls})',
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
                          _buildStatsSubtitle(context, 'Bowler'),
                          const SizedBox(height: 4),
                          _buildMatchPlayerText(
                            context,
                            _match.currentBowlers!.playerName,
                          ),
                          Text(
                            '${_match.currentBowlers!.runsGiven}/${_match.currentBowlers!.wickets} (${_match.currentBowlers!.oversDisplay})',
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
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchTeamColumn(
    BuildContext context, {
    required MatchTeamInfo team,
    required bool isMatchStarted,
    required bool isInningStarted,
    required int? runs,
    required int? wickets,
    required String? oversDisplay,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TeamColumn(
            teamName: team.teamName,
            teamLogo: team.logoUrl,
            textStyle: MyTextStyle(context).bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 8),
          if (isInningStarted) ...[
            Text(
              '$runs/$wickets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '($oversDisplay)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
          if (!isInningStarted && isMatchStarted)
            Text(
              'Yet to bat',
              style: MyTextStyle(context).bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSubtitle(
    BuildContext context,
    String label,
  ) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    );
  }

  Widget _buildMatchPlayerText(
    BuildContext context,
    String playerName,
  ) {
    return Text(
      playerName,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }
}
