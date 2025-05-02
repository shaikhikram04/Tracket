import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/common/widgets/stats_widget/stat_basic_card.dart';
import 'package:tracket/common/widgets/stats_widget/stat_data.dart';
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
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

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

        final teamAllStatsSnap = await FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .doc(widget.teamData!['id'])
            .collection(FirestoreCollections.stats)
            .get();

        final teamAllStatsDoc = teamAllStatsSnap.docs;
        final teamAllFormatStats = <String, dynamic>{};
        for (final stats in teamAllStatsDoc) {
          teamAllFormatStats.addAll({stats.id: stats.data()});
        }

        final teamObject = Team.fromJson(
          widget.teamData!,
          teamPlayer,
          teamAllFormatStats
        );
        ref.read(teamProvider.notifier).updateTeam(teamObject);
      } else {
        final team = await FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .doc(widget.teamId)
            .get();

        if (!mounted) return;

        final teamAllStatsSnap = await FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .doc(widget.teamId)
            .collection(FirestoreCollections.stats)
            .get();

        final teamAllStatsDoc = teamAllStatsSnap.docs;
        final teamAllFormatStats = <String, dynamic>{};
        for (final stats in teamAllStatsDoc) {
          teamAllFormatStats.addAll({stats.id: stats.data()});
        }

        final teamPlayer =
            await TeamsServices.getTeamPlayersFromId(widget.teamId!, context);
        final teamObject = Team.fromJson(team.data()!, teamPlayer, teamAllFormatStats);
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

  Map<String, Map<String, int>> _getStatsForFormat(Team teamData) {
    return {
      'T5': {
        'matches': teamData.teamAllFormatStats.over5.matchesPlayed,
        'wins': teamData.teamAllFormatStats.over5.wins,
        'losses': teamData.teamAllFormatStats.over5.losses,
        'ties': teamData.teamAllFormatStats.over5.tie,
      },
      'T10': {
        'matches': teamData.teamAllFormatStats.over10.matchesPlayed,
        'wins': teamData.teamAllFormatStats.over10.wins,
        'losses': teamData.teamAllFormatStats.over10.losses,
        'ties': teamData.teamAllFormatStats.over10.tie,
      },
      'T20': {
        'matches': teamData.teamAllFormatStats.over20.matchesPlayed,
        'wins': teamData.teamAllFormatStats.over20.wins,
        'losses': teamData.teamAllFormatStats.over20.losses,
        'ties': teamData.teamAllFormatStats.over20.tie,
      },
      'ODI': {
        'matches': teamData.teamAllFormatStats.over50.matchesPlayed,
        'wins': teamData.teamAllFormatStats.over50.wins,
        'losses': teamData.teamAllFormatStats.over50.losses,
        'ties': teamData.teamAllFormatStats.over50.tie,
      },
      'Test': {
        'matches': teamData.teamAllFormatStats.test.matchesPlayed,
        'wins': teamData.teamAllFormatStats.test.wins,
        'losses': teamData.teamAllFormatStats.test.losses,
        'ties': teamData.teamAllFormatStats.test.tie,
      },
    };
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
          TTextStrings.teamDetails,
          style: TextStyle(color: onPrimary),
        ),
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        shape: Border.all(color: primaryColor, width: 0),
        actions: isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(TSizes.borderRadiusXxl)),
                      ),
                      builder: (context) => TeamOptions(
                        isOwner: teamState.team.createdBy ==
                            FirebaseAuthMethods().currentUserId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert,
                      color: onPrimary, size: TSizes.iconAppBar),
                ),
                const SizedBox(width: TSizes.sm),
              ]
            : null,
      ),
      body: _isLoading
          ? const CircularLoadingIndicator()
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
                    padding: TPadding.profileHeader,
                    child: Column(
                      spacing: TSizes.sm,
                      children: [
                        Row(
                          spacing: TSizes.spaceBtwItems,
                          children: [
                            ImageCircleAvatar(
                              url: teamState.team.logoUrl,
                              isTeam: true,
                              radius: TSizes.circleAvatarLg,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: TSizes.sm,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: teamState.team.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                color: onPrimary,
                                                fontSize: TSizes.fontSizeXl,
                                                letterSpacing: 0.7,
                                              ),
                                        ),
                                        TextSpan(
                                          text:
                                              '  (${teamState.team.shortName})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
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
                              label: TTextStrings.followers,
                              labelColor: DarkThemeColors.primaryText,
                              numColor: LightThemeColors.surfaceColor,
                              labelStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            StatsData(
                              number: teamState.team.rank,
                              label: TTextStrings.ranking,
                              labelColor: DarkThemeColors.primaryText,
                              numColor: LightThemeColors.surfaceColor,
                              labelStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            StatsData(
                              number: teamState
                                  .team.teamAllFormatStats.totalMatchPlayed,
                              label: TTextStrings.achievements,
                              labelColor: DarkThemeColors.primaryText,
                              numColor: LightThemeColors.surfaceColor,
                              labelStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Row(
                          spacing: TSizes.sm,
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
                                      text: TTextStrings.unfollowButton,
                                      backgroundColor:
                                          LightThemeColors.surfaceColor,
                                      borderColor: darkGrassGreen,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: darkGrassGreen,
                                              fontWeight: FontWeight.w600),
                                    )
                                  : CustomButton.primary(
                                      isLoading: isFollowing,
                                      onPressed: () => _followTeam(
                                          teamState.team.id, player.id, true),
                                      text: TTextStrings.followButton,
                                      backgroundColor: darkGrassGreen,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: onPrimary,
                                              fontWeight: FontWeight.w600),
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
                                        text: TTextStrings.challengeButton,
                                        backgroundColor: darkGrassGreen,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color:
                                                  LightThemeColors.surfaceColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      )
                                    : CustomButton.secondary(
                                        text: TTextStrings.challenged,
                                        onPressed: null,
                                        backgroundColor:
                                            LightThemeColors.surfaceColor,
                                        borderColor: darkGrassGreen,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: darkGrassGreen),
                                      ),
                              ),
                            if (!isChallengeVisible)
                              const Expanded(child: SizedBox()),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.xl),

                  //! Team Stats section
                  StatBasicCard(statsData: _getStatsForFormat(teamState.team)),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Players Detail section
                  const MyCard(child: Squad(isEdit: false)),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
    );
  }
}
