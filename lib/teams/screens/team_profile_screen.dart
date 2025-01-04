import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/widgets/squad.dart';
import 'package:tracket/teams/widgets/team_options.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/stats_data.dart';

class TeamProfileScreen extends ConsumerStatefulWidget {
  const TeamProfileScreen({
    super.key,
    required this.teamData,
    required this.isAdmin,
  }) : teamId = null;

  const TeamProfileScreen.fromId({
    super.key,
    required this.teamId,
    required this.isAdmin,
  }) : teamData = null;

  final String? teamId;
  final Map<String, dynamic>? teamData;
  final bool isAdmin;

  @override
  ConsumerState<TeamProfileScreen> createState() => _TeamProfileScreenState();
}

class _TeamProfileScreenState extends ConsumerState<TeamProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _loadTeam();
    super.initState();
  }

  Future<void> _loadTeam() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.teamData != null) {
      final teamPlayer = await FirestoreMethods.getTeamPlayersFromId(
        widget.teamData!['id'],
        context,
      );
      final teamObject = Team.formSeed(widget.teamData!, teamPlayer);
      ref.read(teamProvider.notifier).updateTeam(teamObject);
    } else {
      final team = await FirebaseFirestore.instance
          .collection(FirestoreCollections.teams)
          .doc(widget.teamId)
          .get();

      if (!mounted) return;

      final teamPlayer =
          await FirestoreMethods.getTeamPlayersFromId(widget.teamId!, context);
      final teamObject = Team.formSeed(team.data()!, teamPlayer);
      ref.read(teamProvider.notifier).updateTeam(teamObject);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final teamData = ref.watch(teamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
        backgroundColor: greenColor,
        actions: widget.isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const TeamOptions(),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: blackColor,
                    size: 30,
                  ),
                ),
              ]
            : null,
        centerTitle: false,
        shape: Border.all(color: greenColor, width: 0),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
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
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: teamData.logoUrl.isNotEmpty
                              ? NetworkImage(teamData.logoUrl)
                              : const AssetImage('assets/images/team_logo.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          teamData.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          teamData.shortName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //! Team Stats
                  MyCard(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatsData(
                              number: teamData.matchesPlayed,
                              label: 'Matches',
                              numColor: const Color.fromARGB(255, 29, 130, 212),
                            ),
                            StatsData(
                              number: teamData.wins,
                              label: 'Wins',
                              numColor: const Color.fromARGB(255, 39, 141, 42),
                            ),
                            StatsData(
                              number: teamData.losses,
                              label: 'Losses',
                              numColor: Colors.red,
                            ),
                            StatsData(
                              number: teamData.tieCount,
                              label: 'Ties',
                              numColor: Colors.amber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  //! Players Detail
                  const MyCard(child: Squad(isEdit: false)),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
