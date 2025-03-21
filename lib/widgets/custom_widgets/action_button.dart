import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/services/requests_services.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/services/players_services.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

enum ActionButtonType {
  addPlayer,
  joinTeam,
  addAdmin,
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.idsList,
    required this.isPrivate,
    required this.buttonType,
    required this.playerInfo,
    required this.teamInfo,
    this.isTeamHasCapacity = false,
    this.minWidth = 95,
    this.height = 35,
    this.borderRadius = 15,
    this.loadingSize = 20,
    this.loadingStrokeWidth = 2.5,
  });

  final List<String> idsList;
  final bool isPrivate;
  final ActionButtonType buttonType;
  final PlayerDetails playerInfo;
  final TeamDetails teamInfo;
  final bool isTeamHasCapacity;

  // Customizable UI parameters
  final double minWidth;
  final double height;
  final double borderRadius;
  final double loadingSize;
  final double loadingStrokeWidth;

  String get currentId =>
      buttonType == ActionButtonType.joinTeam ? teamInfo.id : playerInfo.id;

  String _getButtonText(bool isAdded) {
    final isOffer = buttonType == ActionButtonType.addPlayer ||
        buttonType == ActionButtonType.addAdmin;
    final baseText = isOffer ? 'Add' : 'Join';
    final pastText = isOffer ? 'Added' : 'Joined';

    if (!isPrivate) return isAdded ? pastText : baseText;

    final privateText = isOffer ? 'Offer' : 'Request';
    final privatePastText = isOffer ? 'Offered' : 'Requested';
    return isAdded ? privatePastText : privateText;
  }

  void _updateRequestStatus(String playerId, bool isAdding, WidgetRef ref) {
    final notifier = ref.read(requestProvider.notifier);
    isAdding
        ? notifier.addRequestInProgress(playerId)
        : notifier.markRequestSuccess(playerId);
  }

  Future<void> _handlePress(WidgetRef ref, BuildContext context) async {
    if (!isTeamHasCapacity &&
        (buttonType == 'addPlayer' || buttonType == 'joinTeam')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team has reached its capacity'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _updateRequestStatus(currentId, true, ref);
    try {
      await _processAction(ref, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _updateRequestStatus(currentId, false, ref);
    }
  }

  Future<void> _processAction(WidgetRef ref, BuildContext context) async {
    final requestServices = RequestsServices();

    switch (buttonType) {
      case ActionButtonType.addPlayer:
      case ActionButtonType.joinTeam:
        if (isPrivate) {
          final result = buttonType == ActionButtonType.addPlayer
              ? await requestServices.offerPlayerToJoinTeam(
                  teamInfo: teamInfo,
                  playerInfo: playerInfo,
                )
              : await requestServices.joinRequestToTeam(
                  playerInfo: playerInfo,
                  teamInfo: teamInfo,
                );

          if (!result.success) {
            throw Exception(result.error);
          }
        } else {
          await TeamsServices.addPlayerToTeam(
            playerInfo: playerInfo,
            teamInfo: teamInfo,
            ref: ref,
            context: context,
          );
        }
        break;

      case ActionButtonType.addAdmin:
        await PlayersServices.changePlayerTeamRole(
          playerId: playerInfo.id,
          teamId: teamInfo.id,
          newRole: TeamRole.admin,
          ref: ref,
          context: context,
        );
        break;
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
        final isAdded = (idsList.contains(currentId) &&
                buttonType != ActionButtonType.addAdmin) ||
            isRequestSuccess;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAdded
                  ? LightThemeColors.secondaryBackground
                  : InteractiveColors.buttonEnabled,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              minimumSize: Size(minWidth, height),
              elevation: isAdded ? 0 : 2,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: (isAdded || isRequestInProgress)
                ? null
                : () => _handlePress(ref, context),
            child: isRequestInProgress
                ? getCircleLoadingIndicator(
                    dimension: loadingSize,
                    strokeWidth: loadingStrokeWidth,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black54),
                  )
                : Text(
                    _getButtonText(isAdded),
                    style: TextStyle(
                      color: isAdded ? Colors.black54 : onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
