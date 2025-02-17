import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/screens/challenge_match_screen.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/widgets/squad.dart';
import 'package:tracket/teams/widgets/team_options.dart';
import 'package:tracket/teams/widgets/team_selection_dialog.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/stats_data.dart';

const primaryGreen = Color(0xFF2E7D32); // Dark green
const secondaryGreen = Color(0xFF4CAF50); // Medium green
const lightGreen = Color(0xFFA5D6A7); // Light green
const accentGreen = Color(0xFF1B5E20); // Darker green
const surfaceGreen = Color(0xFFE8F5E9); // Very light green
const textOnGreen = Colors.white;
const gradientGreenStart = Color(0xFF43A047);
const gradientGreenEnd = Color(0xFF2E7D32);

class TeamProfileScreen extends ConsumerStatefulWidget {
  const TeamProfileScreen({
    super.key,
    required this.teamData,
    // required this.isAdmin,
  }) : teamId = null;

  const TeamProfileScreen.fromId({
    super.key,
    required this.teamId,
    // required this.isAdmin,
  }) : teamData = null;

  final String? teamId;
  final Map<String, dynamic>? teamData;

  @override
  ConsumerState<TeamProfileScreen> createState() => _TeamProfileScreenState();
}

class _TeamProfileScreenState extends ConsumerState<TeamProfileScreen> {
  bool _isLoading = false;
  bool isFollowing = false;
  final List<Map<String, dynamic>> _playerTeamsAsAdmin = [];

  @override
  void initState() {
    _loadTeam();
    super.initState();
  }

  Future<void> _loadTeam() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.teamData != null) {
        final teamPlayer = await TeamsServices.getTeamPlayersFromId(
          widget.teamData!['id'],
          context,
        );
        final teamObject = Team.fromJson(widget.teamData!, teamPlayer);
        ref.read(teamProvider.notifier).updateTeam(teamObject);
      } else {
        final team = await FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .doc(widget.teamId)
            .get();

        if (!mounted) return;

        final teamPlayer =
            await TeamsServices.getTeamPlayersFromId(widget.teamId!, context);
        final teamObject = Team.fromJson(team.data()!, teamPlayer);
        ref.read(teamProvider.notifier).updateTeam(teamObject);
      }

      final teamState = ref.read(teamProvider);
      final player = ref.read(playerProvider);

      //* check if player is not the member of a team
      if (!teamState.team.playerIds.contains(player.id)) {
        //* get players teams as admin
        final playerTeamListAsAdmin = player.playerCricketDetails!.teams
            .where((team) => team.role != TeamRole.player)
            .toList();

        for (final team in playerTeamListAsAdmin) {
          List teamChallengedList =
              await TeamsServices.getTeamChallengedList(team.id);

          bool canChallenge = !teamChallengedList.contains(teamState.team.id);

          _playerTeamsAsAdmin.add({'canChallenge': canChallenge, 'team': team});
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(e.toString(), context);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _followTeam(String teamId, String userId, bool isFollow) {
    setState(() {
      isFollowing = true;
    });

    final userId = FirebaseAuthMethods().currentUserId;

    try {
      TeamsServices.followTeam(teamId, userId, isFollow, ref, context);
    } finally {
      setState(() {
        isFollowing = false;
      });
    }
  }

  Future<void> challengeForAMatch({
    required String playerId,
    required String playerName,
    required MatchTeamInfo challengedTeam,
  }) async {
    TeamDetails? challengerTeam;
    if (_playerTeamsAsAdmin.length > 1) {
      //* selecting challenger team
      challengerTeam = await showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        builder: (context) {
          return TeamSelectionDialog(teamList: _playerTeamsAsAdmin);
        },
      );
    } else {
      challengerTeam = _playerTeamsAsAdmin.first['team'];
    }

    if (challengerTeam != null && mounted) {
      pushScreen(
          context,
          ChallengeMatchScreen(
            challengerId: playerId,
            challengerName: playerName,
            challengerTeamId: challengerTeam.id,
            challengedTeam: challengedTeam,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final teamState = ref.watch(teamProvider);

    final player = ref.watch(playerProvider);
    final isFollowed = teamState.team.followers.contains(player.id);
    final isAdmin = teamState.team.admins.any((admin) => admin.id == player.id);

    final isChallengeVisible = _playerTeamsAsAdmin.isNotEmpty;
    final canChallenge =
        _playerTeamsAsAdmin.any((team) => team['canChallenge']);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Team Details',
          style: TextStyle(color: textOnGreen),
        ),
        backgroundColor: gradientGreenStart,
        shape: Border.all(color: gradientGreenStart, width: 0),
        actions: isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => TeamOptions(
                        isOwner: teamState.team.createdBy ==
                            FirebaseAuthMethods().currentUserId,
                      ),
                    );
                  },
                  icon:
                      const Icon(Icons.more_vert, color: textOnGreen, size: 30),
                ),
              ]
            : null,
        centerTitle: false,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Logo & name section
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [gradientGreenStart, gradientGreenEnd],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 15,
                            children: [
                              getCircleAvatar(
                                url: teamState.team.logoUrl,
                                isTeam: true,
                                radius: 50,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: teamState.team.name,
                                            style: MyTextStyle(context)
                                                .titleLarge
                                                .copyWith(
                                                  color: textOnGreen,
                                                ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  (${teamState.team.shortName})',
                                            style: MyTextStyle(context)
                                                .titleMedium
                                                .copyWith(
                                                  color: lightGreen,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      teamState.team.description,
                                      style: MyTextStyle(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: textOnGreen,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StatsData(
                                number: teamState.team.followers.length,
                                label: 'Followers',
                                labelColor: lightGreen,
                                numColor: textOnGreen,
                              ),
                              StatsData(
                                number: teamState.team.stats.rank,
                                label: 'Ranking',
                                labelColor: lightGreen,
                                numColor: textOnGreen,
                              ),
                              StatsData(
                                number: teamState.team.stats.matchesPlayed,
                                label: 'Achievements',
                                labelColor: lightGreen,
                                numColor: textOnGreen,
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              if (!isChallengeVisible)
                                const Expanded(child: SizedBox()),
                              Expanded(
                                flex: 2,
                                child: isFollowed
                                    ? CustomButton.secondary(
                                        isLoading: isFollowing,
                                        onPressed: () => _followTeam(
                                            teamState.team.id,
                                            player.id,
                                            false),
                                        text: 'Unfollow',
                                        backgroundColor: surfaceGreen,
                                        borderColor: primaryGreen,
                                        textStyle: MyTextStyle(context)
                                            .mediumButtonText
                                            .copyWith(color: primaryGreen),
                                      )
                                    : CustomButton.primary(
                                        isLoading: isFollowing,
                                        onPressed: () => _followTeam(
                                            teamState.team.id, player.id, true),
                                        text: 'Follow',
                                        backgroundColor: accentGreen,
                                        textStyle: MyTextStyle(context)
                                            .mediumButtonText
                                            .copyWith(color: textOnGreen),
                                      ),
                              ),
                              if (isChallengeVisible)
                                Expanded(
                                  flex: 2,
                                  child: canChallenge
                                      ? CustomButton.primary(
                                          onPressed: () => challengeForAMatch(
                                            playerId: player.id,
                                            playerName: player.name,
                                            challengedTeam: MatchTeamInfo(
                                              teamId: teamState.team.id,
                                              logoUrl: teamState.team.logoUrl,
                                              teamName: teamState.team.name,
                                              shortName:
                                                  teamState.team.shortName,
                                              captainId:
                                                  teamState.team.captainId,
                                              wicketkeeperId:
                                                  teamState.team.wicketkeeperId,
                                            ),
                                          ),
                                          text: 'Challenge',
                                          backgroundColor: accentGreen,
                                          textStyle: MyTextStyle(context)
                                              .mediumButtonText
                                              .copyWith(color: textOnGreen),
                                        )
                                      : CustomButton.secondary(
                                          text: 'Challenged',
                                          onPressed: null,
                                          backgroundColor: surfaceGreen,
                                          textStyle: MyTextStyle(context)
                                              .mediumButtonText
                                              .copyWith(color: primaryGreen),
                                        ),
                                ),
                              if (!isChallengeVisible)
                                const Expanded(child: SizedBox()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Team Stats section
                  MyCard(
                    child: Column(
                      children: [
                        Text(
                          'Team Statistics',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 23,
                                    color: primaryGreen,
                                  ),
                        ),
                        const SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatsData(
                              number: teamState.team.stats.matchesPlayed,
                              label: 'Matches',
                              numColor: secondaryGreen,
                            ),
                            StatsData(
                              number: teamState.team.stats.wins,
                              label: 'Wins',
                              numColor: accentGreen,
                            ),
                            StatsData(
                              number: teamState.team.stats.losses,
                              label: 'Losses',
                              numColor: Colors.red[700]!,
                            ),
                            StatsData(
                              number: teamState.team.stats.tie,
                              label: 'Ties',
                              numColor: Colors.orange[800]!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Players Detail section
                  const MyCard(child: Squad(isEdit: false)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
