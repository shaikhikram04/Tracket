import 'package:flutter/material.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';

class TeamSelectionDialog extends StatelessWidget {
  const TeamSelectionDialog({super.key, required this.teamList});

  final List<TeamDetails> teamList;

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
                    final TeamDetails team = teamList[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(team),
                      child: Column(
                        children: [
                          getCircleAvatar(
                              url: team.logoUrl, isTeam: true, radius: 35),
                          Text(team.name),
                          Text(team.shortName),
                        ],
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
