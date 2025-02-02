import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification_result.dart';
import 'package:tracket/notifications/services/requests_services.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/services/players_services.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class MyConsumer extends StatelessWidget {
  const MyConsumer({
    super.key,
    required this.idsList,
    required this.isPrivate,
    required this.buttonType,
    required this.playerInfo,
    required this.teamInfo,
    this.isTeamHasCapacity = false,
  });

  final List<String> idsList;
  final bool isPrivate;
  final String buttonType;
  final PlayerDetails playerInfo;
  final TeamDetails teamInfo;
  final bool isTeamHasCapacity;

  String get currentId =>
      buttonType == 'joinTeam' ? teamInfo.id : playerInfo.id;

  String buttonText(bool isAdded) {
    if (buttonType == 'addPlayer' || buttonType == 'addAdmin') {
      if (isPrivate) {
        return isAdded ? 'Offered' : 'Offer';
      } else {
        return isAdded ? 'Added' : 'Add';
      }
    } else if (buttonType == 'joinTeam') {
      if (isPrivate) {
        return isAdded ? 'Requested' : 'Request';
      } else {
        return isAdded ? 'Joined' : 'Join';
      }
    }
    return '';
  }

  void toggleButton(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestProvider.notifier).markRequestSuccess(playerId);
    }
  }

  Future<void> onPressed(WidgetRef ref, BuildContext context) async {
    toggleButton(currentId, true, ref);
    try {
      if (buttonType == 'addPlayer' || buttonType == 'joinTeam') {
        if (!isTeamHasCapacity) {
          showSnackBar('Team has reached it capacity.', context);
        }
        if (isPrivate) {
          NotificationResult result;
          if (buttonType == 'addPlayer') {
            result = await RequestsServices().offerPlayerToJoinTeam(
              teamInfo: teamInfo,
              playerInfo: playerInfo,
            );
          } else {
            result = await RequestsServices().joinRequestToTeam(
              playerInfo: playerInfo,
              teamInfo: teamInfo,
            );
          }
          if (!result.success) {
            showSnackBar(result.error!, context);
          }
        } else {
          await TeamsServices.addPlayerToTeam(
            playerInfo: playerInfo,
            teamInfo: teamInfo,
            ref: ref,
            context: context,
          );
        }
      } else if (buttonType == 'addAdmin') {
        await PlayersServices.changePlayerTeamRole(
          playerId: playerInfo.id,
          teamId: teamInfo.id,
          newRole: TeamRole.admin,
          ref: ref,
          context: context,
        );
      }
    } finally {
      toggleButton(currentId, false, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final requestStatus = ref.watch(requestProvider);
        final isRequestInProgress =
            requestStatus.requestInProgress.contains(currentId);
        final isRequestSuccess =
            requestStatus.requestSuccess.contains(currentId);

        final isAdded = idsList.contains(currentId) || isRequestSuccess;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isAdded ? Colors.grey : buttonBgColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            minimumSize: const Size(95, 35),
          ),
          onPressed: (isAdded || isRequestInProgress)
              ? null
              : () => onPressed(ref, context),
          child: isRequestInProgress
              ? getCircleLoadingIndicator(dimension: 20, strokeWidth: 2.5)
              : Text(
                  buttonText(isAdded),
                  style: const TextStyle(color: blackColor),
                ),
        );
      },
    );
  }
}
