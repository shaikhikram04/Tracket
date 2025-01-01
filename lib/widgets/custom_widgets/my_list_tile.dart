import 'package:flutter/material.dart';

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

  final String? imageUrl;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool isPlayer;
  final void Function()? onTap;

  AssetImage get defaultImage => AssetImage(
        isPlayer
            ? 'assets/images/Default_user_pfp.jpg'
            : 'assets/images/team_logo.png',
      );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            imageUrl == null ? defaultImage : NetworkImage(imageUrl!),
        radius: 30,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
