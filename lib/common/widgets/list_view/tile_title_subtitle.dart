import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/sizes.dart';

class TileTitleSubtitle extends StatelessWidget {
  const TileTitleSubtitle({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleMaxLines =1 ,
     this.subTitleMaxLines = 2,
  });

  final String title;
  final String subTitle;
  final int titleMaxLines;
  final int subTitleMaxLines;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            subTitle,
            style: textTheme.bodyMedium!.copyWith(
              color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
            maxLines: subTitleMaxLines,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
