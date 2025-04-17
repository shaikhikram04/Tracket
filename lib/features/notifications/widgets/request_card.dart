import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/notifications/models/notification.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.isSent,
    required this.onCancelRequest,
    required this.onAcceptRequest,
    required this.onRejectRequest,
  });

  final NotificationModel request;
  final bool isSent;
  final void Function() onCancelRequest;
  final void Function(WidgetRef ref) onAcceptRequest;
  final void Function() onRejectRequest;

  void _navigateToProfile(
    BuildContext context,
    bool isPlayer,
    NotificationModel request,
  ) {
    final profileScreen = isPlayer
        ? PlayerProfileScreen(playerId: request.from)
        : TeamProfileScreen.fromId(teamId: request.to);
    THelperFunction.pushScreen(context, profileScreen);
  }

  void _loadData(
    Map<String, dynamic> data,
  ) {
    if (isSent) {
      if (request.type == NotificationType.offerPlayerRequest) {
        data['initialMessage'] = 'Your team ';
        data['middleMessage'] = ' has offered ';
        data['lastMessage'] = ' to join.';
        data['isPlayer'] = true;
        data['firstNameInMessage'] = request.teamDetails!.name;
        data['secondNameInMessage'] = request.playerDetails!.name;
        data['imageUrl'] = request.playerDetails!.imageUrl;
      } else {
        data['middleMessage'] = 'You have requested to join the team ';
        data['lastMessage'] = '.';
        data['isPlayer'] = false;
        data['firstNameInMessage'] = '';
        data['secondNameInMessage'] = request.teamDetails!.name;
        data['imageUrl'] = request.teamDetails!.logoUrl;
      }
    } else {
      if (request.type == NotificationType.offerPlayerRequest) {
        data['middleMessage'] = ' has offered you to join their team.';
        data['lastMessage'] = '';
        data['isPlayer'] = false;
        data['firstNameInMessage'] = request.teamDetails!.name;
        data['secondNameInMessage'] = '';
        data['imageUrl'] = request.teamDetails!.logoUrl;
      } else {
        data['middleMessage'] = ' want to join your team ';
        data['lastMessage'] = '.';
        data['isPlayer'] = true;
        data['firstNameInMessage'] = request.playerDetails!.name;
        data['secondNameInMessage'] = request.teamDetails!.name;
        data['imageUrl'] = request.playerDetails!.imageUrl;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> requestMap = {
      'initialMessage': '',
      'middleMessage': '',
      'lastMessage': '',
      'isPlayer': false,
      'firstNameInMessage': '',
      'secondNameInMessage': '',
      'imageUrl': '',
    };
    _loadData(requestMap);
    return MyCard(
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                _navigateToProfile(context, requestMap['isPlayer'], request),
            child: Row(
              children: [
                _buildProfileImage(
                    requestMap['isPlayer'], requestMap['imageUrl']),
                const SizedBox(width: 10),
                _buildRequestDetails(
                  context,
                  firstBoldName: requestMap['firstNameInMessage'],
                  secondBoldName: requestMap['secondNameInMessage'],
                  initialMessage: requestMap['initialMessage'],
                  middleMessage: requestMap['middleMessage'],
                  lastMessage: requestMap['lastMessage'],
                ),
                // const Spacer(),
                if (isSent) _buildCancelButton(context, request),
              ],
            ),
          ),
          if (!isSent)
            _buildActionButtons(
              context,
              requestMap['isPlayer'],
              request,
            ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(bool isPlayer, String imageUrl) {
    return ImageCircleAvatar(url: imageUrl, isTeam: !isPlayer, radius: 30);
  }

  Widget _buildRequestDetails(BuildContext context,
      {required String firstBoldName,
      required String secondBoldName,
      required String initialMessage,
      required String middleMessage,
      required String lastMessage}) {
    return Flexible(
      child: RichText(
        text: TextSpan(
          children: [
            _buildTextSpan(initialMessage, context),
            _buildBoldTextSpan(firstBoldName, context),
            _buildTextSpan(middleMessage, context),
            _buildBoldTextSpan(secondBoldName, context),
            _buildTextSpan(lastMessage, context),
          ],
        ),
      ),
    );
  }

  TextSpan _buildBoldTextSpan(String text, BuildContext context) {
    return TextSpan(
      text: text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  TextSpan _buildTextSpan(String text, BuildContext context) {
    return TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildCancelButton(BuildContext context, NotificationModel request) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: CustomButton.secondary(
        text: 'Cancel',
        onPressed: () async {
          // Handle cancel logic
          final wantToCancel = await THelperFunction.showConfirmationDialog(
            context,
            title: 'Cancel Request',
            message: 'Are you sure you want to cancel this request?',
            confirmText: 'Yes',
            cancelText: 'No',
          );

          if (wantToCancel) {
            onCancelRequest();
          }
        },
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: StatusColors.error,
            ),
        backgroundColor: LightThemeColors.surfaceColor,
        borderColor: StatusColors.error,
        size: ButtonSize.small,
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isPlayer,
    NotificationModel request,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final requestStatus = ref.watch(requestProvider);
          final isRequestInProgress =
              requestStatus.requestInProgress.contains(request.notificationId);
          final isRequestSuccess =
              requestStatus.requestSuccess.contains(request.notificationId);

          if (isRequestSuccess) {
            return Text('This request has been accept',
                style: Theme.of(context).textTheme.bodyLarge);
          }

          return Row(
            children: [
              Text(
                THelperFunction.timeAgo(request.createdAt.toDate()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              CustomButton.primary(
                text: 'Accept',
                isLoading: isRequestInProgress,
                backgroundColor: primaryColor,
                onPressed: () => onAcceptRequest(ref),
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: onPrimary, letterSpacing: 1),
                size: ButtonSize.small,
              ),
              const SizedBox(width: 10),
              CustomButton.secondary(
                text: 'Reject',
                onPressed: onRejectRequest,
                textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: StatusColors.error,
                    ),
                backgroundColor: LightThemeColors.surfaceColor,
                borderColor: StatusColors.error,
                size: ButtonSize.small,
              ),
            ],
          );
        },
      ),
    );
  }
}
