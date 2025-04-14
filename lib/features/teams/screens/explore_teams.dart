import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/features/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/common/widgets/custom_widgets/enhanced_list_tile.dart';
import 'package:tracket/common/widgets/no_data_found.dart';

class ExploreTeams extends StatefulWidget {
  const ExploreTeams({super.key});

  @override
  State<ExploreTeams> createState() => _ExploreTeamsState();
}

class _ExploreTeamsState extends State<ExploreTeams> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: grassGreen,
        foregroundColor: LightThemeColors.surfaceColor,
        title: const Text(
          'Explore Teams',
          style: TextStyle(
            color: LightThemeColors.surfaceColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .orderBy('followers', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: grassGreen,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const NoDataFound(
              title: 'No Teams Available',
              message: 'Be the first to create a team!',
                iconData: AppIconData.groupOff,
            );
          }

          final teams = snapshot.data!.docs;
          final filteredTeams = teams.where((team) {
            final teamData = team.data() as Map<String, dynamic>;
            final teamName = teamData['teamName'].toString().toLowerCase();
            final shortName = teamData['shortName'].toString().toLowerCase();
            final searchLower = _searchQuery.toLowerCase();
            return teamName.contains(searchLower) ||
                shortName.contains(searchLower);
          }).toList();

          if (filteredTeams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No teams found matching "$_searchQuery"',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredTeams.length,
            itemBuilder: (BuildContext context, int index) {
              final teamData =
                  filteredTeams[index].data() as Map<String, dynamic>;

              return EnhancedListTile(
                imageUrl: teamData['logoUrl'],
                title: teamData['teamName'],
                subtitle:
                    '${teamData['shortName']} • ${(teamData['followers'] as List<dynamic>).length} followers',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: grassGreen,
                ),
                onTap: () => THelperFunction.pushScreen(
                  context,
                  TeamProfileScreen(teamData: teamData),
                ),
                isPlayer: false,
              );
            },
          );
        },
      ),
    );
  }
}
