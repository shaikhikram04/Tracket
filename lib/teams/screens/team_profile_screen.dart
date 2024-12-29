import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/widgets/player_tile.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/widgets/team_options.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/stats_data.dart';

class TeamProfileScreen extends ConsumerWidget {
  const TeamProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final teamData = ref.watch(teamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
        backgroundColor: greenColor,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const TeamOptions(),
              );
            },
            icon: const Icon(
              Icons.edit,
              color: blackColor,
              size: 27,
            ),
          ),
        ],
        centerTitle: false,
        shape: Border.all(color: greenColor, width: 0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Team Logo & name
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    greenColor,
                    lightDrawerBgColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: height * 0.23,
              width: width,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: teamData.logoUrl != null
                        ? NetworkImage(teamData.logoUrl!)
                        : const AssetImage('assets/images/team_logo.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    teamData.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    teamData.shortName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //! Team Stats
            MyCard(
              child: Column(
                children: [
                  Text(
                    'Team Statistics',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 23),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatsData(
                        number: teamData.matchesPlayed,
                        label: 'Matches',
                        numColor: const Color.fromARGB(255, 29, 130, 212),
                      ),
                      StatsData(
                        number: teamData.wins,
                        label: 'Wins',
                        numColor: const Color.fromARGB(255, 39, 141, 42),
                      ),
                      StatsData(
                        number: teamData.losses,
                        label: 'Losses',
                        numColor: Colors.red,
                      ),
                      StatsData(
                        number: teamData.tieCount,
                        label: 'Ties',
                        numColor: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            //! Players Detail
            MyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Squad',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  teamData.playersList.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.group_off,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "No Player joined yet!",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: List.generate(
                          teamData.playersList.length,
                          (index) {
                            final playerDetail = teamData.playersList[index];
                            final playerId = playerDetail['id'];
                            final isCaptain = teamData.captainId == null
                                ? false
                                : teamData.captainId == playerId;
                            final isWicketKeeper =
                                teamData.wicketkeeperId == null
                                    ? false
                                    : teamData.wicketkeeperId == playerId;
                            return PlayerTile(
                              playerData: playerDetail,
                              isCaptain: isCaptain,
                              isWicketKeeper: isWicketKeeper,
                            );
                          },
                        )),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
