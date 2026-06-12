import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/common/widgets/stats_widget/stat_basic_card.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/models/player_stats.dart';
import 'package:tracket/features/players/screens/edit_player_profile_screen.dart';
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
    this.showAppBar = true,
  });

  final String? playerId;
  final bool showAppBar;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  late Player _playerData;
  bool _isLoading = false;
  // Selected format index (default to ODI/50 overs)
  int _selectedFormatIndex = 2;

  final List<String> _formats = ['T5', 'T10', 'T20', 'ODI', 'Test'];

  @override
  void initState() {
    _loadPlayerData();

    super.initState();
  }

  String get _resolvedPlayerId =>
      widget.playerId ?? FirebaseAuthMethods().currentUserId;

  Future<void> _loadPlayerData() async {
    setState(() => _isLoading = true);
    try {
      final player = await PlayersServices.getPlayerFromId(_resolvedPlayerId);
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

  PlayerStats _getCurrentPlayerStats() {
    switch (_selectedFormatIndex) {
      case 0:
        return _playerData.playerCricketDetails!.allFormatStats.over5;
      case 1:
        return _playerData.playerCricketDetails!.allFormatStats.over10;
      case 2:
        return _playerData.playerCricketDetails!.allFormatStats.over20;
      case 3:
        return _playerData.playerCricketDetails!.allFormatStats.over50;
      case 4:
        return _playerData.playerCricketDetails!.allFormatStats.test;
      default:
        return _playerData.playerCricketDetails!.allFormatStats.over20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Player Profile'),
              backgroundColor: primaryColor,
              foregroundColor: onPrimary,
              actions: [
                if (_resolvedPlayerId == FirebaseAuthMethods().currentUserId)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final updated =
                                await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditPlayerProfileScreen(player: _playerData),
                              ),
                            );

                            if (updated == true) {
                              await _loadPlayerData();
                            }
                          },
                  ),
              ],
              centerTitle: false,
              shape: Border.all(color: primaryColor, width: 0),
            )
          : null,
      floatingActionButton: !widget.showAppBar &&
              !_isLoading &&
              _resolvedPlayerId == FirebaseAuthMethods().currentUserId
          ? FloatingActionButton.small(
              backgroundColor: primaryColor,
              foregroundColor: onPrimary,
              tooltip: 'Edit Profile',
              onPressed: () async {
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) =>
                        EditPlayerProfileScreen(player: _playerData),
                  ),
                );
                if (updated == true) await _loadPlayerData();
              },
              child: const Icon(Icons.edit),
            )
          : null,
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_formats.length, (index) {
                                final isSelected =
                                    _selectedFormatIndex == index;
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                          index < _formats.length - 1 ? 8 : 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedFormatIndex = index;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (isDark
                                                ? primaryColor
                                                : primaryLight)
                                            : (isDark
                                                ? Colors.grey[800]
                                                : Colors.grey[200]),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _formats[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? (isDark
                                                  ? Colors.black
                                                  : Colors.white)
                                              : (isDark
                                                  ? Colors.white70
                                                  : Colors.black87),
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                  playerStats: _getCurrentPlayerStats(),
                                ),
                                BowlingStats(
                                  playerStats: _getCurrentPlayerStats(),
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
