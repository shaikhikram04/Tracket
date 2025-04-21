import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamSelectionDialog extends StatelessWidget {
  const TeamSelectionDialog({super.key, required this.teamList});

  final List<Map<String, dynamic>> teamList;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dialog(
      child: SizedBox(
        height: height * 0.4,
        child: Padding(
          padding: TPadding.md,
          child: Column(
            children: [
              THelperFunction.getTitleText(TTextStrings.selectTeam, context),
              const SizedBox(height: TSizes.sm),
              Expanded(
                child: ListView.builder(
                  itemCount: teamList.length,
                  itemBuilder: (context, index) {
                    final playerTeam = teamList[index];
                    final canChallenge = playerTeam['canChallenge'] as bool;
                    final team = playerTeam['team'] as TeamDetails;
                    return InkWell(
                      onTap: canChallenge
                          ? () => Navigator.of(context).pop(team)
                          : () {
                              THelperFunction.showAlertDialog(
                                context,
                                TTextStrings.alreadyChallenged,
                                TTextStrings.alreadyChallengedDesc,
                              );
                            },
                      child: Container(
                        padding: TPadding.vPaddingXxs,
                        color: canChallenge
                            ? Colors.transparent
                            : Colors.grey.shade200,
                        child: Row(
                          children: [
                            ImageCircleAvatar(
                                url: team.logoUrl, isTeam: true, radius: TSizes.circleAvatarSm),
                            const SizedBox(width: TSizes.sm),
                            Expanded(
                                child: Text(team.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)),
                            const SizedBox(width: TSizes.sm),
                            Text(team.shortName,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: MyTextButton(
                    text: TTextStrings.cancelButton,
                    onPressed: () => Navigator.of(context).pop(null)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
