import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.isPlayer,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool isPlayer;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getCircleAvatar(url: imageUrl, isTeam: !isPlayer, radius: 30),
      title: Text(
        title,
        style: MyTextStyle(context).bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: MyTextStyle(context).bodyMedium,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
