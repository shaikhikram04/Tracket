import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/services/players_services.dart';
import 'package:tracket/requests/services/requests_services.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/colors.dart';

class MyConsumer extends StatelessWidget {
  const MyConsumer({
    super.key,
    required this.idsList,
    required this.isPrivate,
    required this.buttonType,
    required this.playerInfo,
    required this.teamInfo,
    this.isTeamFull = false,
  });

  final List<String> idsList;
  final bool isPrivate;
  final String buttonType;
  final Map<String, dynamic> playerInfo;
  final Map<String, dynamic> teamInfo;
  final bool isTeamFull;

  String get currentId =>
      buttonType == 'joinTeam' ? teamInfo['id'] : playerInfo['id'];

  String buttonText(bool isAdded) {
    if (buttonType == 'addPlayer' || buttonType == 'addAdmin') {
      if (isPrivate) {
        return isAdded ? 'send' : 'Offer';
      } else {
        return isAdded ? 'Added' : 'Add';
      }
    } else if (buttonType == 'joinTeam') {
      if (isPrivate) {
        return isAdded ? 'send' : 'Request';
      } else {
        return isAdded ? 'Joined' : 'Join';
      }
    }
    return '';
  }

  void toggleButton(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
    }
  }

  Future<void> onPressed(WidgetRef ref, BuildContext context) async {
    toggleButton(currentId, true, ref);
    try {
      if (buttonType == 'addPlayer' || buttonType == 'joinTeam') {
        if (isPrivate) {
          if (buttonType == 'addPlayer') {
            await RequestsServices.requestPlayerToJoinTeam(
                teamInfo: teamInfo, context: context, playerInfo: playerInfo);
          } else {
            RequestsServices.requestTeamToAddPlayer(
                playerInfo: playerInfo, context: context, teamInfo: teamInfo);
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
          playerId: playerInfo['id'],
          teamId: teamInfo['id'],
          newRole: 'admin',
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
        final requestStatus = ref.watch(requestStatusProvider);
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
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(
                  buttonText(isAdded),
                  style: const TextStyle(color: blackColor),
                ),
        );
      },
    );
  }
}
