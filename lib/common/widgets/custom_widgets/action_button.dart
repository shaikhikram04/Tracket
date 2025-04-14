import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/notifications/services/requests_services.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/players/services/players_services.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
    this.height = TSizes.buttonMinHeight,
    this.borderRadius = TSizes.buttonRadius,
    this.loadingSize = TSizes.loadingIndicatorSm,
    this.loadingStrokeWidth = TSizes.loadingStrokeWidthSm,
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
    final baseText = isOffer ? TTextStrings.addButton : TTextStrings.joinButton;
    final pastText =
        isOffer ? TTextStrings.addedButton : TTextStrings.joinedButton;

    if (!isPrivate) return isAdded ? pastText : baseText;

    final privateText =
        isOffer ? TTextStrings.offerButton : TTextStrings.requestButton;
    final privatePastText =
        isOffer ? TTextStrings.offeredButton : TTextStrings.requestedButton;
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
        (buttonType == ActionButtonType.addPlayer ||
            buttonType == ActionButtonType.joinTeam)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            TTextStrings.teamCapacityError,
            style: TextStyle(color: Colors.white),
          ),
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
              elevation: isAdded ? 0 : TSizes.buttonMinElevation,
              padding: TPadding.buttonPaddingSm,
            ),
            onPressed: (isAdded || isRequestInProgress)
                ? null  
                : () => _handlePress(ref, context),
            child: isRequestInProgress
                ? THelperFunction. getCircleLoadingIndicator(
                    dimension: loadingSize,
                    strokeWidth: loadingStrokeWidth,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black54),
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
