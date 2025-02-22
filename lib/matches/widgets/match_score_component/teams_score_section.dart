import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class TeamsScoreSection extends StatelessWidget {
  const TeamsScoreSection({
    super.key,
    required this.match,
    this.onTeamTap,
    this.showRunRate = true,
  });

  final Match match;
  final void Function(String teamId)? onTeamTap;
  final bool showRunRate;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLightMode
            ? LightThemeColors.surfaceColor
            : DarkThemeColors.surfaceColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isLightMode
                ? LightThemeColors.cardColor
                : DarkThemeColors.cardColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTeamSection(context, isTeam1: true),
          _buildVersusLabel(context),
          _buildTeamSection(context, isTeam1: false),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context, {required bool isTeam1}) {
    final team = isTeam1 ? match.team1 : match.team2;
    final innings = isTeam1 ? match.inning1 : match.inning2;

    return Expanded(
      child: InkWell(
        onTap: onTeamTap != null ? () => onTeamTap!(team.teamId) : null,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          textDirection: isTeam1 ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Expanded(
              flex: 3,
              child: TeamColumn(
                teamName: team.teamName,
                teamLogo: team.logoUrl,
                // isHighlighted: innings?.isCurrentlyBatting ?? false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: _buildScoreInfo(context, innings, isTeam1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreInfo(BuildContext context, Inning? innings, bool isTeam1) {
    if (innings == null) {
      return _buildYetToBat(context);
    }

    return Column(
      crossAxisAlignment:
          isTeam1 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${innings.runs}/${innings.wickets}',
              style: MyTextStyle(context).titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isTeam1 ? StatusColors.liveMatch : null,
                  ),
            ),
            if (isTeam1) _buildLiveIndicator(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${innings.oversDisplay} overs',
          style: MyTextStyle(context).bodyMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? LightThemeColors.tertiaryText
                    : DarkThemeColors.tertiaryText,
              ),
        ),
        if (showRunRate && innings.oversDisplay != '0.0')
          Text(
            'RR: ${innings.runRate.toStringAsFixed(2)}',
            style: MyTextStyle(context).bodySmall.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? LightThemeColors.tertiaryText
                      : DarkThemeColors.tertiaryText,
                ),
          ),
      ],
    );
  }

  Widget _buildYetToBat(BuildContext context) {
    return Center(
      child: Text(
        'Yet to bat',
        style: MyTextStyle(context).bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? LightThemeColors.secondaryText
                  : DarkThemeColors.secondaryText,
            ),
      ),
    );
  }

  Widget _buildVersusLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'vs',
        style: MyTextStyle(context).bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.light
                  ? LightThemeColors.secondaryText
                  : DarkThemeColors.secondaryText,
            ),
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: StatusColors.liveMatch,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: StatusColors.liveMatch.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
