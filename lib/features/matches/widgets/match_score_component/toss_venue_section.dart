import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TossVenueSection extends StatelessWidget {
  const TossVenueSection({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context),
            const SizedBox(height: 12),
            _buildTossInfo(context, isDark ? primaryLight : primaryColor),
            const SizedBox(height: 8),
            _buildVenueInfo(context, isDark ? primaryLight : primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: theme.colorScheme.secondary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Match Information',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTossInfo(BuildContext context, Color labelColor) {
    if (match.isTeam1WonToss == null || match.tossDecision == null) {
      return _buildNoTossInfo(context);
    }

    final tossWinner =
        match.isTeam1WonToss! ? match.team1.teamName : match.team2.teamName;

    final decision =
        match.tossDecision! == TossDecision.batting ? 'bat' : 'bowl';

    return _buildInfoRow(
      context: context,
      icon: Icons.sports_cricket,
      label: 'Toss',
      labelColor: labelColor,
      value: '$tossWinner won the toss and decided to $decision first',
    );
  }

  Widget _buildNoTossInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.sports_cricket,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          'Toss: ',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          'Awaiting toss',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildVenueInfo(BuildContext context, Color labelColor) {
    return _buildInfoRow(
      context: context,
      icon: Icons.location_on,
      label: 'Venue',
      labelColor: labelColor,
      value: match.venue,
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color labelColor,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: labelColor,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
