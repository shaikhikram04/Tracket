import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/notifications/services/requests_services.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/players/services/players_services.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

/// A customizable action button for team and player management operations
class ActionButton extends ConsumerWidget {
  const ActionButton({
    super.key,
    required this.idsList,
    required this.isPrivate,
    required this.buttonType,
    required this.playerInfo,
    required this.teamInfo,
    this.isTeamHasCapacity = false,
    this.minWidth = TSizes.buttonMinWidth,
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

  /// Returns the relevant ID based on the button type
  String get currentId => buttonType == ActionButtonType.joinTeam ? teamInfo.id : playerInfo.id;

  /// Determines whether the button is disabled due to capacity constraints
  bool _isDisabledDueToCapacity() {
    return !isTeamHasCapacity && (buttonType == ActionButtonType.addPlayer || buttonType == ActionButtonType.joinTeam);
  }

  /// Gets the appropriate button text based on state and button type
  String _getButtonText(bool isAdded) {
    final isOffer = buttonType == ActionButtonType.addPlayer || buttonType == ActionButtonType.addAdmin;

    if (!isPrivate) {
      return isAdded
          ? (isOffer ? TTextStrings.addedButton : TTextStrings.joinedButton)
          : (isOffer ? TTextStrings.addButton : TTextStrings.joinButton);
    }

    return isAdded
        ? (isOffer ? TTextStrings.offeredButton : TTextStrings.requestedButton)
        : (isOffer ? TTextStrings.offerButton : TTextStrings.requestButton);
  }

  /// Updates the request status in the provider
  void _updateRequestStatus(String id, bool isAdding, WidgetRef ref) {
    final notifier = ref.read(requestProvider.notifier);
    isAdding ? notifier.addRequestInProgress(id) : notifier.markRequestSuccess(id);
  }

  /// Handles the button press action
  Future<void> _handlePress(WidgetRef ref, BuildContext context) async {
    // Check team capacity first
    if (_isDisabledDueToCapacity()) {
      THelperFunction.showErrorSnackBar(
        TTextStrings.teamCapacityError,
        context,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Show loading state
    _updateRequestStatus(currentId, true, ref);

    try {
      await _processAction(ref, context);
    } catch (e) {
      THelperFunction.showErrorSnackBar(
        'Error: ${e.toString()}',
        context,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _updateRequestStatus(currentId, false, ref);
    }
  }

  /// Process the appropriate action based on button type
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
  Widget build(BuildContext context, WidgetRef ref) {
    final requestStatus = ref.watch(requestProvider);
    final isRequestInProgress = requestStatus.requestInProgress.contains(currentId);
    final isRequestSuccess = requestStatus.requestSuccess.contains(currentId);
    final isAdded = (idsList.contains(currentId) && buttonType != ActionButtonType.addAdmin) || isRequestSuccess;

    final isDisabled = isAdded || isRequestInProgress;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isAdded ? InteractiveColors.buttonDisabled : InteractiveColors.buttonEnabled,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(minWidth, height),
          elevation: isAdded ? 0 : TSizes.buttonMinElevation,
          padding: TPadding.buttonPaddingSm,
        ),
        onPressed: isDisabled ? null : () => _handlePress(ref, context),
        child: isRequestInProgress
            ? CircularLoadingIndicator(
                dimension: loadingSize,
                strokeWidth: loadingStrokeWidth,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
              )
            : Text(
                _getButtonText(isAdded),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isAdded ? Colors.black : onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
      ),
    );
  }
}
