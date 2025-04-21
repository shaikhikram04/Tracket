import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/widgets/team_list.dart';
import 'package:tracket/features/teams/widgets/team_speed_dial.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final playerTeamsId = [
      ...player.playerTeamsId,
      '',
    ]; // Create new list with empty string

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .where('id', whereIn: playerTeamsId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          }

          if (snapshot.hasError) {
            return _ErrorState(error: snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const _EmptyState();
          }

          return TeamsList(
            teams: snapshot.data!.docs,
            player: player,
          );
        },
      ),
      floatingActionButton: TeamSpeedDial(player: player),
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
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: TTextStrings.noTeam,
      message: TTextStrings.noTeamMessage,
      isPointingButton: true,
      rotation: 1,
      iconData: AppIconData.groupOff,
    );
  }
}
