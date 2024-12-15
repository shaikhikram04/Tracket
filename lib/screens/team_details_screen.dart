import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/stats_data.dart';

class TeamDetailsScreen extends StatelessWidget {
  const TeamDetailsScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
              size: 25,
            ),
          ),
        ],
        centerTitle: false,
        shape: Border.all(color: greenColor, width: 0),
      ),
      body: Column(
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
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/team_logo.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Team Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'TSN',
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
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatsData(
                        number: 256,
                        label: 'Matches',
                        numColor: Color.fromARGB(255, 29, 130, 212),
                      ),
                      StatsData(
                        number: 148,
                        label: 'Wins',
                        numColor: Color.fromARGB(255, 39, 141, 42),
                      ),
                      StatsData(
                        number: 102,
                        label: 'Losses',
                        numColor: Colors.red,
                      ),
                      StatsData(
                        number: 6,
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
          const Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: whiteColor,
            elevation: 7,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              child: Column(
                children: [Text('Squrd')],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
