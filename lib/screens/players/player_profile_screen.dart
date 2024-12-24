import 'package:flutter/material.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/highlighted_label.dart';
import 'package:tracket/widgets/stats_data.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({required this.player, super.key});

  final Player player;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool isBattingStats = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        backgroundColor: greenColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
        shape: Border.all(color: greenColor, width: 0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture and Name
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
                    backgroundImage: widget.player.profileImageUrl == null
                        ? const AssetImage('assets/images/Default_user_pfp.jpg')
                        : NetworkImage(widget.player.profileImageUrl!),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.player.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    widget.player.role,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //! Player Stats
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
                      'Player Statistics',
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
                          number: widget.player.playerStats!.matches!,
                          label: 'Matches',
                          numColor: const Color.fromARGB(255, 29, 130, 212),
                        ),
                        StatsData(
                          number: widget.player.playerStats!.totalRuns,
                          label: 'Runs',
                          numColor: const Color.fromARGB(255, 39, 141, 42),
                        ),
                        StatsData(
                          number: widget.player.playerStats!.wicket,
                          label: 'Wickets',
                          numColor: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tabs for Detailed Stats
            Card(
              color: whiteColor,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 7,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: greenColor,
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.green,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (value) async {
                        if (value == 0) {
                          setState(() {
                            isBattingStats = true;
                          });
                        } else {
                          await Future.delayed(
                              const Duration(milliseconds: 215), () {
                            setState(() {
                              isBattingStats = false;
                            });
                          });
                        }
                      },
                      tabs: const [
                        Tab(text: 'Batting'),
                        Tab(text: 'Bowling'),
                      ],
                    ),
                    SizedBox(
                      height: isBattingStats ? 270 : 150,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildBattingStats(),
                          _buildBowlingStats(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Achievements Section
            buildAchievements(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildAchievements() {
    return Card(
      color: whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 23),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: List.generate(
                widget.player.achievements!.length,
                (index) => HighlightedLabel(
                  text: widget.player.achievements![index],
                  bgColor: Colors.deepOrange.shade100,
                  textColor: Colors.deepOrange.shade900,
                ),
              ),
            ),

            // Add more achievements
          ],
        ),
      ),
    );
  }

  Widget _getStatBlock(dynamic number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildBattingStats() {
    final playerStats = widget.player.playerStats!;
    final notOut = playerStats.innings! - playerStats.outCount!;
    return Column(
      spacing: 15,
      children: [
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(playerStats.matches, 'Matches'),
            _getStatBlock(playerStats.innings, 'Innings'),
            _getStatBlock(playerStats.totalRuns, 'Runs'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(playerStats.strikeRate, 'Strike Rate'),
            _getStatBlock(playerStats.battingAverage, 'Average'),
            _getStatBlock(playerStats.highestScore, 'Highest Score'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(playerStats.hundreds, 'Hundreds'),
            _getStatBlock(playerStats.fifties, 'Fifties'),
            _getStatBlock(notOut, 'Not Outs'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(playerStats.six, 'Sixes'),
            _getStatBlock(playerStats.four, 'Fours'),
          ],
        ),
      ],
    );
  }

  Widget _buildBowlingStats() {
    final playerStats = widget.player.playerStats!;
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(playerStats.matches, 'Matches'),
            _getStatBlock(playerStats.wicket, 'Wickets'),
            _getStatBlock(playerStats.economyRate, 'Economy'),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(playerStats.bowingAverage, 'Average'),
            _getStatBlock(
              playerStats.bestBallingFigure!.inString,
              'Best Bowling',
            ),
          ],
        ),
        // Add more bowling stats
      ],
    );
  }
}
