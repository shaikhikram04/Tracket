import 'package:flutter/material.dart';
import 'package:tracket/features/notifications/screens/notifications_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    required this.hasNotification,
  });

  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: TSizes.sm),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: onPrimary,
            iconSize: TSizes.iconAppBar,
            tooltip: 'Notifications',
            onPressed: () => THelperFunction.pushScreen(
              context,
              const NotificationsScreen(),
            ),
          ),
          // Uncomment when notification badge is needed
          if (hasNotification)
            const Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 5,
              ),
            ),
        ],
      ),
    );
  }
}
