import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/screens/challenge_match_screen.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/features/teams/widgets/squad.dart';
import 'package:tracket/features/teams/widgets/team_options.dart';
import 'package:tracket/features/teams/widgets/team_selection_dialog.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/stats_data.dart';

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
        THelperFunction.showSnackBar(e.toString(), context);
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
      THelperFunction.pushScreen(
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
          style: TextStyle(color: LightThemeColors.surfaceColor),
        ),
        backgroundColor: primaryColor,
        foregroundColor: LightThemeColors.surfaceColor,
        shape: Border.all(color: primaryColor, width: 0),
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
                  icon: const Icon(Icons.more_vert,
                      color: LightThemeColors.surfaceColor, size: 30),
                ),
              ]
            : null,
        centerTitle: false,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Logo & name section
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 15,
                          children: [
                            THelperFunction.getCircleAvatar(
                              url: teamState.team.logoUrl,
                              isTeam: true,
                              radius: 50,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: teamState.team.name,
                                          style: MyTextStyle(context)
                                              .titleLarge
                                              .copyWith(
                                                color: LightThemeColors
                                                    .surfaceColor,
                                              ),
                                        ),
                                        TextSpan(
                                          text:
                                              '  (${teamState.team.shortName})',
                                          style: MyTextStyle(context)
                                              .titleMedium
                                              .copyWith(
                                                color: LightThemeColors
                                                    .backgroundColor,
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
                                          color: DarkThemeColors.primaryText,
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
                              labelColor: DarkThemeColors.primaryText,
                              numColor: LightThemeColors.surfaceColor,
                            ),
                            StatsData(
                              number: teamState.team.rank,
                              label: 'Ranking',
                              labelColor: DarkThemeColors.primaryText,
                              numColor: LightThemeColors.surfaceColor,
                            ),
                            StatsData(
                              number: teamState.team.over20.matchesPlayed,
                              label: 'Achievements',
                              labelColor: DarkThemeColors.primaryText,
                              numColor: LightThemeColors.surfaceColor,
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
                                          teamState.team.id, player.id, false),
                                      text: 'Unfollow',
                                      backgroundColor:
                                          LightThemeColors.surfaceColor,
                                      borderColor: primaryVariant,
                                      textStyle: MyTextStyle(context)
                                          .mediumButtonText
                                          .copyWith(color: primaryColor),
                                    )
                                  : CustomButton.primary(
                                      isLoading: isFollowing,
                                      onPressed: () => _followTeam(
                                          teamState.team.id, player.id, true),
                                      text: 'Follow',
                                      backgroundColor: primaryVariant,
                                      textStyle: MyTextStyle(context)
                                          .mediumButtonText
                                          .copyWith(color: onPrimary),
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
                                            shortName: teamState.team.shortName,
                                            captainId: teamState.team.captainId,
                                            wicketkeeperId:
                                                teamState.team.wicketkeeperId,
                                          ),
                                        ),
                                        text: 'Challenge',
                                        backgroundColor: primaryVariant,
                                        textStyle: MyTextStyle(context)
                                            .mediumButtonText
                                            .copyWith(color: onPrimary),
                                      )
                                    : CustomButton.secondary(
                                        text: 'Challenged',
                                        onPressed: null,
                                        backgroundColor:
                                            LightThemeColors.surfaceColor,
                                        textStyle: MyTextStyle(context)
                                            .mediumButtonText
                                            .copyWith(color: onPrimary),
                                      ),
                              ),
                            if (!isChallengeVisible)
                              const Expanded(child: SizedBox()),
                          ],
                        )
                      ],
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
                                    color: primaryColor,
                                  ),
                        ),
                        const SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatsData(
                              number: teamState.team.over20.matchesPlayed,
                              label: 'Matches',
                              numColor: primaryColor,
                            ),
                            StatsData(
                              number: teamState.team.over20.wins,
                              label: 'Wins',
                              numColor: primaryColor,
                            ),
                            StatsData(
                              number: teamState.team.over20.losses,
                              label: 'Losses',
                              numColor: Colors.red[700]!,
                            ),
                            StatsData(
                              number: teamState.team.over20.tie,
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
