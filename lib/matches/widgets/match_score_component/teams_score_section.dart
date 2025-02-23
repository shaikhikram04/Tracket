import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class TeamsScoreSection extends StatelessWidget {
  const TeamsScoreSection({
    super.key,
    required this.match,
    this.onTeamTap,
    this.showRunRate = true,
    this.showProjectedScore = true,
  });

  final Match match;
  final void Function(String teamId)? onTeamTap;
  final bool showRunRate;
  final bool showProjectedScore;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLightMode
            ? LightThemeColors.surfaceColor
            : DarkThemeColors.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: isLightMode
                ? grassGreen.withOpacity(0.1)
                : darkGrassGreen.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildTeamRow(context, true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildTeamRow(context, false),
          if (match.status == MatchStatus.live) _buildMatchStatus(context),
        ],
      ),
    );
  }

  Widget _buildTeamRow(BuildContext context, bool isTeam1) {
    final team = isTeam1 ? match.team1 : match.team2;
    final innings = isTeam1 ? match.inning1 : match.inning2;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTeamTap != null ? () => onTeamTap!(team.teamId) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              // Team Logo
              CircleAvatar(
                radius: 20,
                backgroundColor: isLightMode
                    ? LightThemeColors.cardColor
                    : DarkThemeColors.cardColor,
                backgroundImage: NetworkImage(team.logoUrl),
              ),
              const SizedBox(width: 12),

              // Team Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.teamName,
                      style: MyTextStyle(context).bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: innings?.status == InningsStatus.inProgress
                                ? primaryColor
                                : isLightMode
                                    ? LightThemeColors.primaryText
                                    : DarkThemeColors.primaryText,
                          ),
                    ),
                    if (showRunRate && innings?.oversDisplay != '0.0')
                      Text(
                        'RR: ${innings?.runRate.toStringAsFixed(2)}',
                        style: MyTextStyle(context).bodySmall.copyWith(
                              color: isLightMode
                                  ? LightThemeColors.tertiaryText
                                  : DarkThemeColors.tertiaryText,
                            ),
                      ),
                  ],
                ),
              ),

              // Score Section
              if (innings != null)
                _buildScoreSection(context, innings)
              else
                _buildYetToBat(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSection(BuildContext context, Inning innings) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (innings.status == InningsStatus.inProgress)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildLiveIndicator(),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  '${innings.runs}/${innings.wickets}',
                  style: MyTextStyle(context).titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: innings.status == InningsStatus.inProgress
                            ? primaryColor
                            : isLightMode
                                ? LightThemeColors.primaryText
                                : DarkThemeColors.primaryText,
                      ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isLightMode
                    ? LightThemeColors.cardColor
                    : DarkThemeColors.cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${innings.oversDisplay} ov',
                style: MyTextStyle(context).bodySmall.copyWith(
                      color: isLightMode
                          ? LightThemeColors.secondaryText
                          : DarkThemeColors.secondaryText,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYetToBat(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLightMode
            ? LightThemeColors.cardColor
            : DarkThemeColors.cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Yet to bat',
        style: MyTextStyle(context).bodySmall.copyWith(
              color: isLightMode
                  ? LightThemeColors.secondaryText
                  : DarkThemeColors.secondaryText,
            ),
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: StatusColors.liveMatch,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: StatusColors.liveMatch.withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStatus(BuildContext context) {
    if (match.target == null) return const SizedBox.shrink();

    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final requiredRuns = match.target! - (match.inning2?.runs ?? 0);
    final remainingBalls = ((20 * 6) - (match.inning2?.runRate ?? 0)).round();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isLightMode
            ? LightThemeColors.cardColor
            : DarkThemeColors.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
        ),
      ),
      child: Text(
        'Need $requiredRuns runs from $remainingBalls balls',
        style: MyTextStyle(context).bodyMedium.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
