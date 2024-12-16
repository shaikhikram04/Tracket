import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tracket/models/team.dart';
import 'package:tracket/screens/add_player_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/player_tile.dart';
import 'package:tracket/widgets/stats_data.dart';

class TeamDetailsScreen extends StatelessWidget {
  const TeamDetailsScreen({super.key, required this.teamData});

  final Team teamData;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    void addPlayer() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AddPlayerScreen(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
        backgroundColor: greenColor,
        actions: [
          IconButton(
            onPressed: () {},
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
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: whiteColor,
              elevation: 7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
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
            ),
            const SizedBox(height: 20),
            //! Players Detail
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: whiteColor,
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
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
                          const Spacer(),
                          IconButton(
                            onPressed: addPlayer,
                            iconSize: 30,
                            icon: const Icon(Icons.group_add),
                          )
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
                                const SizedBox(height: 20),
                                Text(
                                  "No Player joined yet!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Tap the button above to request player to join.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                ZoomIn(
                                  child: Icon(
                                    Icons.arrow_outward,
                                    size: 50,
                                    color: Colors.green.shade400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: List.generate(
                            6,
                            (index) {
                              return const PlayerTile(
                                isCaptain: true,
                                isWicketKeeper: true,
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
