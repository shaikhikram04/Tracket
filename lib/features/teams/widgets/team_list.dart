import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/features/teams/screens/team_profile_screen.dart';
import 'package:tracket/features/teams/widgets/team_list_tile.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamsList extends StatelessWidget {
  const TeamsList({
    super.key,
    required this.teams,
    required this.player,
  });

  final List<QueryDocumentSnapshot> teams;
  final dynamic player;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: TPadding.vPaddingLg,
      itemCount: teams.length,
      separatorBuilder: (context, index) => const Divider(height: TSizes.dividerHeight),
      itemBuilder: (context, index) {
        final teamData = teams[index].data() as Map<String, dynamic>;
        final teamRole = player.playerCricketDetails!.teams
            .firstWhere((team) => team.id == teamData['id'])
            .role;

        return TeamListTile(
          teamData: teamData,
          teamRole: teamRole,
          onTap: () => THelperFunction.pushScreen(
              context, TeamProfileScreen(teamData: teamData)),
        );
      },
    );
  }
}
