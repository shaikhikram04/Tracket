import 'package:flutter/material.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';

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
              getTitleText('Select a team', context),
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
                              showSnackBar(
                                'This team has already challenged the current team.',
                                context,
                              );
                            },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: canChallenge ? 1 : 0.4,
                              child: getCircleAvatar(
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
