import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/widgets/achievements.dart';
import 'package:tracket/players/widgets/batting_stats.dart';
import 'package:tracket/players/widgets/bowling_stats.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
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
  late Player _playerData;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.player != null) {
      _playerData = widget.player!;
    } else {
      _loadPlayerData();
    }

    super.initState();
  }

  Future<void> _loadPlayerData() async {
    setState(() => _isLoading = true);
    try {
      final player = await FirestoreMethods.getPlayerFromId(widget.playerId!);
      setState(() => _playerData = player);
    } catch (error) {
      if (mounted) {
        showSnackBar('Error fetching player data: $error', context);
      }
    } finally {
      setState(() => _isLoading = false);
    }
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
                          backgroundImage: _playerData.profileImageUrl == null
                              ? const AssetImage(
                                  'assets/images/Default_user_pfp.jpg')
                              : NetworkImage(_playerData.profileImageUrl!),
                          onBackgroundImageError: (_, __) => const AssetImage(
                            'assets/images/Default_user_pfp.jpg',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _playerData.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          _playerData.cricketRole!.name,
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
                                number: _playerData.playerStats!.matches!,
                                label: 'Matches',
                                numColor:
                                    const Color.fromARGB(255, 29, 130, 212),
                              ),
                              StatsData(
                                number: _playerData.playerStats!.totalRuns,
                                label: 'Runs',
                                numColor:
                                    const Color.fromARGB(255, 39, 141, 42),
                              ),
                              StatsData(
                                number: _playerData.playerStats!.wicket,
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
                            tabs: const [
                              Tab(text: 'Batting'),
                              Tab(text: 'Bowling'),
                            ],
                          ),
                          SizedBox(
                            height: 270,
                            child: TabBarView(
                              children: [
                                BattingStats(
                                    playerStats: _playerData.playerStats!),
                                BowlingStats(
                                    playerStats: _playerData.playerStats!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Achievements Section
                  Achievements(
                    achievements: _playerData.achievements!,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
