import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/chat/widgets/chat_input_bar.dart';
import 'package:tracket/features/chat/widgets/message_list.dart';
import 'package:tracket/features/chat/widgets/typing_indicator.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/image_strings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: const ChatAppBar(),
      body: Column(
        children: [
          Expanded(child: MessageList()),
          TypingIndicator(),
          ChatInputBar(),
        ],
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ImageCircleAvatar(
              url: TImages.teamDefaultLogo,
              isTeam: true,
              radius: TSizes.circleAvatarXsLg,
            ),
            const SizedBox(width: TSizes.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Team Name",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(letterSpacingFactor: 1),
                ),
                Text(
                  "status",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .apply(letterSpacingFactor: 1, fontWeightDelta: -2),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(TSizes.appBarHeight);
}
