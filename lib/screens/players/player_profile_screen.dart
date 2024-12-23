import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/highlighted_label.dart';
import 'package:tracket/widgets/stats_data.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

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
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/Default_user_pfp.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Player Name',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Cricket Role | Team Name',
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatsData(
                          number: 74,
                          label: 'Matches',
                          numColor: Color.fromARGB(255, 29, 130, 212),
                        ),
                        StatsData(
                          number: 4500,
                          label: 'Runs',
                          numColor: Color.fromARGB(255, 39, 141, 42),
                        ),
                        StatsData(
                          number: 40,
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
              children: [
                HighlightedLabel(
                  text: 'Achievement 1',
                  bgColor: Colors.green.shade100,
                  textColor: Colors.green.shade900,
                  isLabel: false,
                ),
                HighlightedLabel(
                  text: 'Achievement 2',
                  bgColor: Colors.blue.shade100,
                  textColor: Colors.blue.shade900,
                  isLabel: false,
                ),
                HighlightedLabel(
                  text: 'Achievement 3',
                  bgColor: Colors.red.shade100,
                  textColor: Colors.red.shade900,
                  isLabel: false,
                ),
                HighlightedLabel(
                  text: 'Achievement 4',
                  bgColor: Colors.orange.shade100,
                  textColor: Colors.orange.shade900,
                  isLabel: false,
                ),
              ],
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
    return Column(
      spacing: 15,
      children: [
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(74, 'Matches'),
            _getStatBlock(74, 'Innings'),
            _getStatBlock(5000, 'Runs'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(120.4, 'Strike Rate'),
            _getStatBlock(70, 'Average'),
            _getStatBlock(121, 'Highest Score'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(3, 'Hundreds'),
            _getStatBlock(30, 'Fifties'),
            _getStatBlock(10, 'Not Outs'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(90, 'Sixes'),
            _getStatBlock(120, 'Fours'),
          ],
        ),
      ],
    );
  }

  Widget _buildBowlingStats() {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(74, 'Matches'),
            _getStatBlock(55, 'Wickets'),
            _getStatBlock(7.2, 'Economy'),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatBlock(20, 'Average'),
            _getStatBlock('3 / 17', 'Best Bowling'),
          ],
        ),
        // Add more bowling stats
      ],
    );
  }
}
