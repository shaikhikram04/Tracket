import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/teams/models/team_details.dart';
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              THelperFunction.getTitleText('Select a team', context),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: teamList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 2,
                  ),
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
                                'Already Challenged',
                                'This team has already challenged the current team.',
                              );
                            },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: canChallenge ? 1 : 0.4,
                              child: ImageCircleAvatar(
                                  url: team.logoUrl, isTeam: true, radius: 35),
                            ),
                            Text(team.name),
                            Text(team.shortName),
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
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(null)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
