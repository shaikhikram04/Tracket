import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';

class TournamentList extends StatelessWidget {
  const TournamentList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: NoDataFound(
        title: TTextStrings.noTournaments,
        message: TTextStrings.noTournamentsMessage,
        iconData: AppIconData.noMatch,
      ),
    );
  }
}
