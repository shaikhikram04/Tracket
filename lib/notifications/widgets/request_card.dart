import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.isSent,
    required this.onCancelRequest,
    required this.onAcceptRequest,
    required this.onRejectRequest,
  });

  final model.Notification request;
  final bool isSent;
  final void Function() onCancelRequest;
  final void Function(WidgetRef ref) onAcceptRequest;
  final void Function() onRejectRequest;

  void _navigateToProfile(
    BuildContext context,
    bool isPlayer,
    model.Notification request,
  ) {
    final profileScreen = isPlayer
        ? PlayerProfileScreen(playerId: request.from)
        : TeamProfileScreen.fromId(teamId: request.to);
    pushScreen(context, profileScreen);
  }

  void _loadData(
    Map<String, dynamic> data,
  ) {
    if (isSent) {
      if (request.type == model.NotificationType.offerPlayerRequest) {
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
      if (request.type == model.NotificationType.offerPlayerRequest) {
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
                  secontBoldName: requestMap['secondNameInMessage'],
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
    return getCircleAvatar(url: imageUrl, isTeam: !isPlayer, radius: 30);
  }

  Widget _buildRequestDetails(BuildContext context,
      {required String firstBoldName,
      required String secontBoldName,
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
            _buildBoldTextSpan(secontBoldName, context),
            _buildTextSpan(lastMessage, context),
          ],
        ),
      ),
    );
  }

  TextSpan _buildBoldTextSpan(String text, BuildContext context) {
    return TextSpan(
      text: text,
      style: MyTextStyle(context).boldBodyLarge,
    );
  }

  TextSpan _buildTextSpan(String text, BuildContext context) {
    return TextSpan(
      text: text,
      style: MyTextStyle(context).bodyLarge,
    );
  }

  Widget _buildCancelButton(BuildContext context, model.Notification request) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: MyElevatedButton.secondaryElevatedButton(
        context,
        text: 'Cancel',
        onPressed: () {
          // Handle cancel logic
          showAlertDoubleBtnDialog(
            context,
            title: 'Cancel Request',
            content: 'Are you sure you want to cancel this request?',
            sureButtonText: 'Yes',
            onSureButtonPressed: onCancelRequest,
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isPlayer,
    model.Notification request,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final requestStatus = ref.watch(requestStatusProvider);
          final isRequestInProgress =
              requestStatus.requestInProgress.contains(request.notificationId);
          final isRequestSuccess =
              requestStatus.requestSuccess.contains(request.notificationId);

          if (isRequestSuccess) {
            return Text('This request has been accept',
                style: MyTextStyle(context).bodyLarge);
          }

          return Row(
            children: [
              Text(
                timeAgo(request.createdAt.toDate()),
                style: MyTextStyle(context).bodyMedium,
              ),
              const Spacer(),
              MyElevatedButton.primaryElevatedButton(
                context,
                text: 'Accept',
                isLoading: isRequestInProgress,
                primaryColor: const Color.fromARGB(255, 47, 134, 50),
                onPressed: () => onAcceptRequest(ref),
              ),
              const SizedBox(width: 10),
              MyElevatedButton.secondaryElevatedButton(
                context,
                text: 'Reject',
                onPressed: onRejectRequest,
              ),
            ],
          );
        },
      ),
    );
  }

  String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 356) {
      final int year = (difference.inDays / 365).floor();
      return '${year}y ago';
    } else if (difference.inDays >= 30) {
      final int month = (difference.inDays / 30).floor();
      return '${month}month ago';
    } else if (difference.inDays >= 7) {
      final int week = (difference.inDays / 7).floor();
      return '${week}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    }

    return 'just now';
  }
}
