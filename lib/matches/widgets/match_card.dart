import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/screens/match_scoring_screen.dart';
import 'package:tracket/matches/screens/start_match_screen.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/matches/widgets/match_teams_row.dart';
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

  Future<void> onStart(BuildContext context, Match match, String startBy) async {
    await MatchesServices.setMatchStartBy(
      startBy: startBy,
      matchId: match.id,
    );

    pushScreen(
        context,
        StartMatchScreen(
          match: match,
        ));
  }

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
                    match.matchType.name,
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
              MatchTeamsRow(match: match, versusBgColor: Colors.grey[200]!),
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
                    onPressed: () => onStart(context, match, currentUserId),
                  ),
                ]
              ],
              if (_match.status == MatchStatus.live) ...[
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                // Current Players

                // Row(
                //   children: [
                //     // Batsmen
                //     Expanded(
                //       flex: 1,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           _buildStatsSubtitle(context, 'Batsmen'),
                //           const SizedBox(height: 4),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               _buildMatchPlayerText(
                //                 context,
                //                 _match.currentBatsmen![0].playerName,
                //               ),
                //               const SizedBox(width: 8),
                //               Text(
                //                 '${_match.currentBatsmen![0].runs} (${_match.currentBatsmen![0].balls})',
                //                 style: TextStyle(
                //                   color: Theme.of(context).primaryColor,
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               _buildMatchPlayerText(
                //                 context,
                //                 _match.currentBatsmen![1].playerName,
                //               ),
                //               const SizedBox(width: 8),
                //               Text(
                //                 '${_match.currentBatsmen![1].runs} (${_match.currentBatsmen![1].balls})',
                //                 style: TextStyle(
                //                   color: Theme.of(context).primaryColor,
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),

                //     // Bowler
                //     Expanded(
                //       flex: 1,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           _buildStatsSubtitle(context, 'Bowler'),
                //           const SizedBox(height: 4),
                //           _buildMatchPlayerText(
                //             context,
                //             _match.currentBowlers!.playerName,
                //           ),
                //           Text(
                //             '${_match.currentBowlers!.runsGiven}/${_match.currentBowlers!.wickets} (${_match.currentBowlers!.oversDisplay})',
                //             style: TextStyle(
                //               color: Theme.of(context).primaryColor,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStatsSubtitle(
  //   BuildContext context,
  //   String label,
  // ) {
  //   return Text(
  //     label,
  //     style: TextStyle(
  //       color: Colors.grey[600],
  //       fontSize: 12,
  //     ),
  //   );
  // }

  // Widget _buildMatchPlayerText(
  //   BuildContext context,
  //   String playerName,
  // ) {
  //   return Text(
  //     playerName,
  //     style: TextStyle(
  //       fontWeight: FontWeight.w600,
  //       fontSize: 14,
  //     ),
  //   );
  // }
}
