import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({
    super.key,
    required this.match,
    this.showDate = true,
    this.dateFormat,
  });

  final Match match;
  final bool showDate;
  final DateFormat? dateFormat;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLightMode
            ? LightThemeColors.cardColor
            : DarkThemeColors.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showDate) _buildDate(context),
          const Spacer(),
          _buildMatchStatus(context),
        ],
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    final formattedDate =
        (dateFormat ?? DateFormat.yMMMMd()).format(match.createdAt.toDate());

    return Text(
      formattedDate,
      style: MyTextStyle(context).bodyMedium.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? LightThemeColors.secondaryText
                : DarkThemeColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _buildMatchStatus(BuildContext context) {
    if (match.status != MatchStatus.live) {
      return _buildNonLiveStatus(context);
    }

    return HighlightedLabel(
      text: 'LIVE',
      color: StatusColors.liveMatch.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: BorderRadius.circular(8),
      textStyle: MyTextStyle(context).bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: StatusColors.liveMatch,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildNonLiveStatus(BuildContext context) {
    final status = match.status;
    late final Color statusColor;
    late final String statusText;

    switch (status) {
      case MatchStatus.scheduled:
        statusColor = StatusColors.upcoming;
        statusText = 'UPCOMING';
        break;
      case MatchStatus.completed:
        statusColor = StatusColors.completed;
        statusText = 'COMPLETED';
        break;
      default:
        return const SizedBox.shrink();
    }

    return HighlightedLabel(
      text: statusText,
      color: statusColor.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: BorderRadius.circular(8),
      textStyle: MyTextStyle(context).bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: statusColor,
            letterSpacing: 0.5,
          ),
    );
  }
}
