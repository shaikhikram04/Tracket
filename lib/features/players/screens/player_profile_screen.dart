import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/common/widgets/stats_widget/stat_basic_card.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/services/players_services.dart';
import 'package:tracket/features/players/widgets/achievements.dart';
import 'package:tracket/features/players/widgets/batting_stats.dart';
import 'package:tracket/features/players/widgets/bowling_stats.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({
    super.key,
    this.playerId,
  });

  final String? playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  late Player _playerData;
  bool _isLoading = false;

  @override
  void initState() {
    _loadPlayerData();

    super.initState();
  }

  Future<void> _loadPlayerData() async {
    setState(() => _isLoading = true);
    try {
      final player = await PlayersServices.getPlayerFromId(widget.playerId!);
      setState(() => _playerData = player);
    } catch (error) {
      if (mounted) {
        THelperFunction.showSnackBar(
            'Error fetching player data: $error', context);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, Map<String, int>> _getStatsForFormat() {
    final cricketDetails = _playerData.playerCricketDetails!;

    return {
      'T5': {
        'matches': cricketDetails.allFormatStats.over5.matches ?? 0,
        'runs': cricketDetails.allFormatStats.over5.battingStats.totalRuns,
        'wickets':
            cricketDetails.allFormatStats.over5.bowlingStats?.wicket ?? 0,
      },
      'T10': {
        'matches': cricketDetails.allFormatStats.over10.matches ?? 0,
        'runs': cricketDetails.allFormatStats.over10.battingStats.totalRuns,
        'wickets':
            cricketDetails.allFormatStats.over10.bowlingStats?.wicket ?? 0,
      },
      'T20': {
        'matches': cricketDetails.allFormatStats.over20.matches ?? 0,
        'runs': cricketDetails.allFormatStats.over20.battingStats.totalRuns,
        'wickets':
            cricketDetails.allFormatStats.over20.bowlingStats?.wicket ?? 0,
      },
      'ODI': {
        'matches': cricketDetails.allFormatStats.over50.matches ?? 0,
        'runs': cricketDetails.allFormatStats.over50.battingStats.totalRuns,
        'wickets':
            cricketDetails.allFormatStats.over50.bowlingStats?.wicket ?? 0,
      },
      'Test': {
        'matches': cricketDetails.allFormatStats.test.matches ?? 0,
        'runs': cricketDetails.allFormatStats.test.battingStats.totalRuns,
        'wickets': cricketDetails.allFormatStats.test.bowlingStats?.wicket ?? 0,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
        shape: Border.all(color: primaryColor, width: 0),
      ),
      body: _isLoading
          ? const CircularLoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture and Name
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GradientColors.matchCardStart,
                          GradientColors.matchCardEnd,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    width: width,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ImageCircleAvatar(
                          url: _playerData.profileImageUrl,
                          isTeam: false,
                          radius: 50,
                          hasBorder: false,
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _playerData.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: onPrimary,
                                    ),
                              ),
                              TextSpan(
                                text:
                                    '  (${_playerData.playerCricketDetails!.cricketRole.description})',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: LightThemeColors.backgroundColor,
                                    ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _playerData.playerCricketDetails!.detailedCricketRole,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: onPrimary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  //! Player Stats
                  StatBasicCard(
                    statsData: _getStatsForFormat(),
                  ),

                  const SizedBox(height: 16),

                  // Tabs for Detailed Stats
                  MyCard(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: isDark ? primaryLight : primaryColor,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                            unselectedLabelColor: isDark
                                ? DarkThemeColors.secondaryText
                                : LightThemeColors.secondaryText,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: isDark
                                  ? primaryLight.withValues(alpha: 0.2)
                                  : primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            indicatorWeight: 3,
                            tabs: const [
                              Tab(text: 'Batting'),
                              Tab(text: 'Bowling'),
                            ],
                          ),
                          SizedBox(
                            height: 285,
                            child: TabBarView(
                              children: [
                                BattingStats(
                                  playerStats: _playerData.playerCricketDetails!
                                      .allFormatStats.over50,
                                ),
                                BowlingStats(
                                  playerStats: _playerData.playerCricketDetails!
                                      .allFormatStats.over50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Achievements Section
                  Achievements(
                    achievements:
                        _playerData.playerCricketDetails!.achievements,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
