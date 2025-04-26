import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

class ListTileStructure extends StatelessWidget {
  const ListTileStructure({
    super.key,
    required this.backgroundColor,
    required this.onTap,
    required this.children,
  });

  final Color? backgroundColor;
  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor ?? primaryColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        highlightColor: theme.highlightColor.withValues(alpha: 0.1),
        splashColor: theme.splashColor.withValues(alpha: 0.1),
        child: Padding(
          padding: TPadding.paddingMd,
          child: Row(children: children),
        ),
      ),
    );
  }
}
