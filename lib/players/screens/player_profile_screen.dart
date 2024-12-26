import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/highlighted_label.dart';
import 'package:tracket/widgets/stats_data.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({
    super.key,
    this.player,
    this.playerId,
  });

  final Player? player;
  final String? playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool isBattingStats = true;
  late Player playerData;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.player != null) {
      playerData = widget.player!;
    } else {
      _loadPlayerData();
    }

    super.initState();
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      _isLoading = true;
    });

    await FirestoreMethods.getPlayerFromId(widget.playerId!).then((player) {
      setState(() {
        playerData = player;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Error fetching player data: $error');
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          backgroundImage: playerData.profileImageUrl == null
                              ? const AssetImage(
                                  'assets/images/Default_user_pfp.jpg')
                              : NetworkImage(playerData.profileImageUrl!),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          playerData.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          playerData.cricketRole!.name,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 30),
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
                                number: playerData.playerStats!.matches!,
                                label: 'Matches',
                                numColor:
                                    const Color.fromARGB(255, 29, 130, 212),
                              ),
                              StatsData(
                                number: playerData.playerStats!.totalRuns,
                                label: 'Runs',
                                numColor:
                                    const Color.fromARGB(255, 39, 141, 42),
                              ),
                              StatsData(
                                number: playerData.playerStats!.wicket,
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
    Widget content = Column(children: [
      Text(
        'No Achievements Yet',
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 35, 2, 0)),
      ),
      Text(
        'Complete tasks and challenges to earn your first achievement badge!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontFamily: 'Inter',
              color: Colors.black87,
            ),
      ),
      const SizedBox(height: 25),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
        child: Text(
          'View Available Achievements',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    ]);

    if (playerData.achievements != null &&
        playerData.achievements!.isNotEmpty) {
      content = Wrap(
        children: List.generate(
          playerData.achievements!.length,
          (index) => HighlightedLabel(
            text: playerData.achievements![index],
            bgColor: Colors.deepOrange.shade100,
            textColor: Colors.deepOrange.shade900,
          ),
        ),
      );
    }

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
            const SizedBox(height: 20),

            content,

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
    final playerStats = playerData.playerStats!;
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
    final playerStats = playerData.playerStats!;
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
