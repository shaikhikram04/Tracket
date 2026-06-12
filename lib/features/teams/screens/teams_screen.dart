import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/screens/create_team_screen.dart';
import 'package:tracket/features/teams/screens/join_team_screen.dart';
import 'package:tracket/features/teams/widgets/team_list.dart';
import 'package:tracket/features/teams/widgets/team_speed_dial.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final playerTeamsId = [
      ...player.playerTeamsId,
      '',
    ];

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.teams)
          .where('id', whereIn: playerTeamsId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: _LoadingState());
        }

        if (snapshot.hasError) {
          return Scaffold(
              body: _ErrorState(error: snapshot.error.toString()));
        }

        if (!snapshot.hasData || snapshot.data!.size == 0) {
          return Scaffold(body: _EmptyState(player: player));
        }

        return Scaffold(
          body: TeamsList(
            teams: snapshot.data!.docs,
            player: player,
          ),
          floatingActionButton: TeamSpeedDial(player: player),
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            TTextStrings.teamLoading,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: TPadding.xl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: TSizes.iconXxl,
              color: StatusColors.error.withValues(alpha: 0.8),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              TTextStrings.somethingWentWrong,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkThemeColors.secondaryText
                    : LightThemeColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.groups_rounded,
            size: 72,
            color: primaryColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No Teams Yet',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create or join a team to start tracking matches and stats.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _TeamActionCard(
            icon: Icons.add_circle_outline_rounded,
            title: TTextStrings.createTeam,
            subtitle: 'Start a new squad and invite your players.',
            color: primaryColor,
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateTeamScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _TeamActionCard(
            icon: Icons.group_add_rounded,
            title: TTextStrings.joinTeam,
            subtitle: 'Enter a team code to join an existing squad.',
            color: Colors.blueAccent,
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JoinTeamScreen(player)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamActionCard extends StatelessWidget {
  const _TeamActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? DarkThemeColors.cardColor
              : LightThemeColors.cardColor,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? DarkThemeColors.primaryText
                          : LightThemeColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? DarkThemeColors.secondaryText
                          : LightThemeColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
