import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class AcceptChallengeScreen extends StatelessWidget {
  const AcceptChallengeScreen({super.key, required this.challenge});

  final ChallengeMatch challenge;

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
                      TeamColumn(
                        teamName: challenge.challengedTeam.name,
                        teamLogo: challenge.challengedTeam.logoUrl,
                      ),
                      Text(
                        'v/s',
                        style: MyTextStyle(context).boldBodyLarge,
                      ),
                      TeamColumn(
                        teamName: challenge.challengerTeam.name,
                        teamLogo: challenge.challengerTeam.logoUrl,
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
                      matchDetailRow(
                        'No of players',
                        challenge.noOfPlayers.toString(),
                        context,
                      ),
                      matchDetailRow(
                        'Match Format',
                        challenge.overs.name,
                        context,
                      ),
                      matchDetailRow(
                        'Match type',
                        challenge.matchType.name,
                        context,
                      ),
                      matchDetailRow(
                        'Spectator',
                        challenge.allowSpectator ? 'Allow' : 'Not allow',
                        context,
                      ),
                      matchDetailRow(
                        'Date',
                        DateFormat.yMMMd().format(challenge.schedule),
                        context,
                      ),
                      matchDetailRow(
                        'Time',
                        DateFormat.Hms().format(challenge.schedule),
                        context,
                      ),
                      matchDetailRow('Venue', challenge.venue, context),
                    ],
                  ),
                ],
              ),
            ),
            MyCard(
              child: MatchSquad(
                selectedPlayer: challenge.challengerPlayers,
                captainId: '',
                wicketkeeperId: '',
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
          Expanded(
            child: Text(
              title,
              style: MyTextStyle(context).boldBodyLarge,
            ),
          ),
          const Text('   :   '),
          Expanded(
            child: Text(
              value,
              style: MyTextStyle(context)
                  .boldBodyLarge
                  .copyWith(color: const Color.fromARGB(255, 50, 124, 53)),
            ),
          )
        ],
      ),
    );
  }
}
