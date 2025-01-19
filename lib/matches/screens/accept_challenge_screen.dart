import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class AcceptChallengeScreen extends StatelessWidget {
  const AcceptChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Challenge  '),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //! Team Detail
            MyCard(
              child: Column(
                children: [
                  getTitleText('Teams', context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      const TeamColumn(
                        teamName: 'Challenged Team Name',
                        teamLogo: '',
                      ),
                      Text(
                        'v/s',
                        style: MyTextStyle(context).boldBodyLarge,
                      ),
                      const TeamColumn(
                        teamName: 'Challenger Team Name',
                        teamLogo: '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //! Match detail
            MyCard(
              child: Column(
                spacing: 20,
                children: [
                  getTitleText('Match Details', context),
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      matchDetailRow('No of players', '11', context),
                      matchDetailRow('Match Format', 'T20', context),
                      matchDetailRow('Match type', 'challenge', context),
                      matchDetailRow('Spectator', 'Allow', context),
                      matchDetailRow('Date', '22 Jan 2025', context),
                      matchDetailRow('Time', '5:00 pm', context),
                      matchDetailRow('Venue', 'Wafa complex', context),
                    ],
                  ),
                ],
              ),
            ),
            MyCard(
              child: MatchSquad(
                selectedPlayer: List.generate(
                  7,
                  (index) => PlayerDetails(
                    cricketRole: CricketRole.allRounder.name,
                    id: 'id',
                    imageUrl: '',
                    name: 'name',
                    role: TeamRole.admin,
                  ),
                ),
                captainId: '',
                wicketkeeperId: '',
                onAdd: () {},
                isPlayerCanAdd: false,
                title: 'Challenger Squad',
              ),
            ),
            MyCard(
              child: MatchSquad(
                selectedPlayer: const [],
                captainId: '',
                wicketkeeperId: '',
                onAdd: () {},
                title: 'Your Squad',
              ),
            ),
            const SizedBox(height: 5),
            Row(
              spacing: 20,
              children: [
                const SizedBox(),
                Expanded(
                  child: MyElevatedButton.secondaryElevatedButton(
                    context,
                    text: 'Reject',
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: MyElevatedButton.primaryElevatedButton(
                    context,
                    onPressed: () {},
                    text: 'Accept',
                    primaryColor: const Color.fromARGB(255, 43, 114, 45),
                  ),
                ),
                const SizedBox(),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget matchDetailRow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title : ',
            style: MyTextStyle(context).boldBodyLarge,
          ),
          Text(
            value,
            style: MyTextStyle(context)
                .boldBodyLarge
                .copyWith(color: const Color.fromARGB(255, 50, 124, 53)),
          )
        ],
      ),
    );
  }
}
