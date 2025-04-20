import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/enhanced_list_tile.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/features/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

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
    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: grassGreen,
        foregroundColor: onPrimary,
        title: const Text(
          TTextStrings.exploreTeams,
          style: TextStyle(
            color: LightThemeColors.surfaceColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(TSizes.appBarHeight),
          child: Padding(
            padding: TPadding.xs,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: TTextStrings.searchTeams,
                filled: true,
                fillColor: isDark
                    ? DarkThemeColors.surfaceColor
                    : LightThemeColors.surfaceColor,
                prefixIcon: Icon(Icons.search,
                    color: isDark ? lightGrassGreen : grassGreen),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: TPadding.hPaddingMd,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .orderBy(TTextStrings.followersKey, descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: isDark ? lightGrassGreen : grassGreen,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: TSizes.xxl, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    '${TTextStrings.error} ${snapshot.error}',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const NoDataFound(
              title: TTextStrings.noTeamAvailable,
              message: TTextStrings.noTeamAvailableMessage,
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
            return NoDataFound(
              title: '${TTextStrings.noTeamFoundMatchingSearch} "$_searchQuery"',
              message: '',
              iconData: Icons.search_off,
            );
          }

          return ListView.builder(
            padding: TPadding.xs,
            itemCount: filteredTeams.length,
            itemBuilder: (BuildContext context, int index) {
              final teamData =
                  filteredTeams[index].data() as Map<String, dynamic>;

              return EnhancedListTile(
                imageUrl: teamData['logoUrl'],
                title: teamData['teamName'],
                subtitle:
                    '${teamData['shortName']} • ${(teamData['followers'] as List<dynamic>).length} ${TTextStrings.followersKey}',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: TSizes.iconSm,
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
