import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/screens/accept_challenge_screen.dart';
import 'package:tracket/notifications/models/notification.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.isSent,
    required this.onCanceChallenge,
    required this.onRejectChallenge,
    required this.onAccepted,
  });

  final NotificationModel challenge;
  final bool isSent;
  final void Function() onCanceChallenge;
  final void Function() onRejectChallenge;
  final void Function() onAccepted;

  void _navigateToAcceptChallenge(BuildContext context) {
    pushScreen(
        context,
        AcceptChallengeScreen(
          challenge: challenge.challengeMatch!,
          isSender: isSent,
          challengeId: challenge.notificationId,
          onAccepted: onAccepted,
        ));
  }

  void _loadData(
    Map<String, dynamic> data,
  ) {
    if (isSent) {
      data['initialMessage'] = 'Your team ';
      data['firstTeamName'] = challenge.challengeMatch!.challengerTeam.teamName;
      data['middleMessage'] = ' has challenged team ';
      data['secondTeamName'] =
          challenge.challengeMatch!.challengedTeam.teamName;
      data['logoUrl'] = challenge.challengeMatch!.challengedTeam.logoUrl;
    } else {
      data['initialMessage'] = 'Team ';
      data['firstTeamName'] = challenge.challengeMatch!.challengerTeam.teamName;
      data['middleMessage'] = ' has challenged your team ';
      data['secondTeamName'] =
          challenge.challengeMatch!.challengedTeam.teamName;
      data['logoUrl'] = challenge.challengeMatch!.challengerTeam.logoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> notificationData = {
      'initialMessage': '',
      'middleMessage': '',
      'firstTeamName': '',
      'secondTeamName': '',
      'logoUrl': '',
    };
    _loadData(notificationData);
    return MyCard(
      child: Column(
        children: [
          InkWell(
            onTap: () => _navigateToAcceptChallenge(context),
            child: Row(
              children: [
                _buildProfileImage(notificationData['logoUrl']),
                const SizedBox(width: 10),
                _buildRequestDetails(
                  context,
                  firstBoldName: notificationData['firstTeamName'],
                  secontBoldName: notificationData['secondTeamName'],
                  initialMessage: notificationData['initialMessage'],
                  middleMessage: notificationData['middleMessage'],
                ),
                // const Spacer(),
                if (isSent) _buildCancelButton(context),
              ],
            ),
          ),
          if (!isSent) _buildActionButtons(context, challenge),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String logoUrl) {
    return getCircleAvatar(url: logoUrl, isTeam: true, radius: 30);
  }

  Widget _buildRequestDetails(
    BuildContext context, {
    required String firstBoldName,
    required String secontBoldName,
    required String initialMessage,
    required String middleMessage,
  }) {
    return Flexible(
      child: RichText(
        text: TextSpan(
          children: [
            _buildTextSpan(initialMessage, context),
            _buildBoldTextSpan(firstBoldName, context),
            _buildTextSpan(middleMessage, context),
            _buildBoldTextSpan(secontBoldName, context),
          ],
        ),
      ),
    );
  }

  TextSpan _buildBoldTextSpan(String text, BuildContext context) {
    return TextSpan(
      text: text,
      style:
          MyTextStyle(context).bodyLarge.copyWith(fontWeight: FontWeight.bold),
    );
  }

  TextSpan _buildTextSpan(String text, BuildContext context) {
    return TextSpan(
      text: text,
      style: MyTextStyle(context).bodyLarge,
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: CustomButton.secondary(
        onPressed: () {
          // Handle cancel logic
          showAlertDoubleBtnDialog(
            context,
            title: 'Cancel Request',
            content: 'Are you sure you want to cancel this request?',
            sureButtonText: 'Yes',
            onSureButtonPressed: onCanceChallenge,
          );
        },
        textStyle: MyTextStyle(context).buttonText.copyWith(
              color: StatusColors.error,
            ),
        backgroundColor: StatusColors.error,
        text: 'Cancel',
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
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
            return Text('This challenge has been accept',
                style: MyTextStyle(context).bodyLarge);
          }

          return Row(
            children: [
              Text(
                timeAgo(request.createdAt.toDate()),
                style: MyTextStyle(context).bodyMedium,
              ),
              const Spacer(),
              CustomButton.secondary(
                onPressed: onRejectChallenge,
                text: 'Reject',
                textStyle: MyTextStyle(context).buttonText.copyWith(
                      color: StatusColors.error,
                    ),
                backgroundColor: StatusColors.error,
              ),
              const SizedBox(width: 10),
              CustomButton.primary(
                text: 'Accept',
                isLoading: isRequestInProgress,
                backgroundColor: const Color.fromARGB(255, 47, 134, 50),
                onPressed: () => _navigateToAcceptChallenge(context),
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
