import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/widgets/match_score_component/match_status_card.dart';
import 'package:tracket/features/matches/widgets/match_score_component/toss_venue_section.dart';
import 'package:tracket/features/matches/widgets/scoreboard_component/match_scoreboard.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic here in the future
            await Future.delayed(const Duration(milliseconds: 800));
          },
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        MatchStatusCard(match: match),
        const SizedBox(height: 8),
        _buildScoreboardSection(context),
        const SizedBox(height: 8),
        TossVenueSection(match: match),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildScoreboardSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = THelperFunction.isDarkMode(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.scoreboard_outlined,
                    size: 20,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Scoreboard',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Scoreboard(
              matchId: match.id,
              team1Players: match.team1Players,
              team2Players: match.team2Players,
              team1: match.team1,
              team2: match.team2,
              team1InningNumber: match.team1InningNumber,
              team2InningNumber: match.team2InningNumber,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'Match Details',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDarkMode
          ? theme.colorScheme.surface
          : LightThemeColors.surfaceColor,
      elevation: 0,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
    );
  }
}
