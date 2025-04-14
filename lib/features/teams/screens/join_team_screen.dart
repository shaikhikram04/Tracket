import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/features/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/common/widgets/custom_widgets/action_button.dart';
import 'package:tracket/common/widgets/custom_widgets/enhanced_list_tile.dart';
import 'package:tracket/common/widgets/no_data_found.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen(this.player, {super.key});

  final Player player;

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isPrivateOnly = false;
  bool _hasCapacityOnly = false;

  List<String> get playerTeamsId => [
        '',
        ...widget.player.playerCricketDetails!.teams
            .map((team) => team.id)
            .toList()
      ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: grassGreen,
        foregroundColor: LightThemeColors.surfaceColor,
        title: const Text(
          'Join Team',
          style: TextStyle(
            color: LightThemeColors.surfaceColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search teams...',
                    filled: true,
                    fillColor: LightThemeColors.surfaceColor,
                    prefixIcon: const Icon(Icons.search, color: grassGreen),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    FilterChip(
                      selected: _isPrivateOnly,
                      label: const Text('Private Teams'),
                      onSelected: (value) =>
                          setState(() => _isPrivateOnly = value),
                      backgroundColor: LightThemeColors.surfaceColor,
                      selectedColor: primaryMedium,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _hasCapacityOnly,
                      label: const Text('Has Capacity'),
                      onSelected: (value) =>
                          setState(() => _hasCapacityOnly = value),
                      backgroundColor: LightThemeColors.surfaceColor,
                      selectedColor: primaryMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .where('id', whereNotIn: playerTeamsId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: grassGreen,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const NoDataFound(
              title: 'No Teams Available',
              message: 'All teams are already joined or no teams exist yet.',
                iconData: AppIconData.groupOff,
            );
          }

          final teams = snapshot.data!.docs;
          final filteredTeams = teams.where((team) {
            final teamData = team.data() as Map<String, dynamic>;
            final teamObj = Team.fromJson(teamData, null);

            bool matchesSearch = teamObj.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                teamObj.shortName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());

            bool matchesFilters = true;
            if (_isPrivateOnly)
              matchesFilters = matchesFilters && teamObj.isPrivate;
            if (_hasCapacityOnly)
              matchesFilters = matchesFilters && teamObj.hasCapacity;

            return matchesSearch && matchesFilters;
          }).toList();

          if (filteredTeams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 64, color: LightThemeColors.secondaryText),
                  const SizedBox(height: 16),
                  Text(
                    'No teams found matching your criteria',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredTeams.length,
            itemBuilder: (context, index) {
              return buildTeamCard(
                  filteredTeams[index].data() as Map<String, dynamic>);
            },
          );
        },
      ),
    );
  }

  Widget buildTeamCard(Map<String, dynamic> teamData) {
    final team = Team.fromJson(teamData, null);
    final teamInfo = TeamDetails(
      id: team.id,
      logoUrl: team.logoUrl,
      name: team.name,
      shortName: team.shortName,
      role: TeamRole.player,
    );

    final playerInfo = PlayerDetails(
      cricketRole: widget.player.playerCricketDetails!.cricketRole,
      id: widget.player.id,
      imageUrl: widget.player.profileImageUrl,
      name: widget.player.name,
      role: TeamRole.player,
      longCricketRole: widget.player.playerCricketDetails!.detailedCricketRole,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          EnhancedListTile(
            imageUrl: team.logoUrl,
            title: team.name,
            subtitle: team.shortName,
            onTap: () =>
                THelperFunction.pushScreen(context, TeamProfileScreen(teamData: teamData)),
            trailing: null,
            isPlayer: false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      team.isPrivate ? Icons.lock : Icons.lock_open,
                      size: 16,
                      color: LightThemeColors.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      team.isPrivate ? 'Private' : 'Public',
                      style: const TextStyle(color: LightThemeColors.secondaryText),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      team.hasCapacity ? Icons.people : Icons.group_off,
                      size: 16,
                      color: LightThemeColors.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      team.hasCapacity ? 'Has Capacity' : 'Full',
                      style: const TextStyle(color: LightThemeColors.secondaryText),
                    ),
                  ],
                ),
                ActionButton(
                  idsList: playerTeamsId,
                  isPrivate: team.isPrivate,
                  buttonType: ActionButtonType.joinTeam,
                  teamInfo: teamInfo,
                  playerInfo: playerInfo,
                  isTeamHasCapacity: team.hasCapacity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
