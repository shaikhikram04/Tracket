import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/action_button.dart';
import 'package:tracket/widgets/custom_widgets/enhanced_list_tile.dart';
import 'package:tracket/widgets/no_data_found.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key, required this.team});

  final Team team;

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _isLoading = false;
  List<QueryDocumentSnapshot>? _players;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _loadPlayers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<String> get playersId =>
      widget.team.playersList.map((player) => player.id).toList();

  Future<void> _loadPlayers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.players)
          .where('role', isEqualTo: 'player')
          .get();

      setState(() {
        _players = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load players. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<QueryDocumentSnapshot> _getFilteredPlayers() {
    if (_players == null) return [];
    if (_searchQuery.isEmpty) return _players!;

    final query = _searchQuery.toLowerCase();
    return _players!.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = data['playerName']?.toString().toLowerCase() ?? '';
      final role = data['playerCricketDetails']?['cricketRole']
              ?.toString()
              .toLowerCase() ??
          '';
      return name.contains(query) || role.contains(query);
    }).toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search players...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildPlayerList() {
    final filteredPlayers = _getFilteredPlayers();

    if (filteredPlayers.isEmpty && _searchQuery.isNotEmpty) {
      return const Center(
        child: Text('No players found matching your search'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final player = Player.fromSeed(
          filteredPlayers[index].data() as Map<String, dynamic>,
          null,
        );
        return _buildPlayerTile(player);
      },
    );
  }

  Widget _buildPlayerTile(Player player) {
    final isPrivate = player.playerCricketDetails!.isPrivate;
    final playerInfo = PlayerDetails(
      cricketRole: player.playerCricketDetails!.cricketRole,
      id: player.id,
      imageUrl: player.profileImageUrl,
      name: player.name,
      role: TeamRole.player,
      longCricketRole: player.playerCricketDetails!.detailedCricketRole,
    );

    final teamInfo = TeamDetails(
      id: widget.team.id,
      logoUrl: widget.team.logoUrl,
      name: widget.team.name,
      shortName: widget.team.shortName,
      role: TeamRole.player,
    );

    return EnhancedListTile(
      key: ValueKey(player.id),
      imageUrl: player.profileImageUrl,
      title: player.name,
      subtitle: player.playerCricketDetails!.cricketRole.name,
      onTap: () => pushScreen(
        context,
        PlayerProfileScreen(player: player),
      ),
      isPlayer: true,
      trailing: ActionButton(
        idsList: playersId,
        isPrivate: isPrivate,
        buttonType: 'addPlayer',
        playerInfo: playerInfo,
        teamInfo: teamInfo,
        isTeamHasCapacity: widget.team.hasCapacity,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error ?? 'Something went wrong'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPlayers,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Player'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadPlayers,
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _buildErrorWidget()
                      : _players == null || _players!.isEmpty
                          ? const NoDataFound(
                              title: 'No players found',
                              message: 'Wait for players to join',
                            )
                          : _buildPlayerList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerTile(Player player, BuildContext context) {
    final bool isPrivate = player.playerCricketDetails!.isPrivate;
    final playerInfo = PlayerDetails(
      cricketRole: player.playerCricketDetails!.cricketRole,
      id: player.id,
      imageUrl: player.profileImageUrl,
      name: player.name,
      role: TeamRole.player,
      longCricketRole: player.playerCricketDetails!.detailedCricketRole,
    );

    final teamInfo = TeamDetails(
      id: widget.team.id,
      logoUrl: widget.team.logoUrl,
      name: widget.team.name,
      shortName: widget.team.shortName,
      role: TeamRole.player,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: EnhancedListTile(
        imageUrl: player.profileImageUrl,
        title: player.name,
        subtitle: player.playerCricketDetails!.cricketRole.name,
        onTap: () => pushScreen(context, PlayerProfileScreen(player: player)),
        isPlayer: true,
        trailing: ActionButton(
          idsList: playersId,
          isPrivate: isPrivate,
          buttonType: 'addPlayer',
          playerInfo: playerInfo,
          teamInfo: teamInfo,
          isTeamHasCapacity: widget.team.hasCapacity,
        ),
      ),
    );
  }
}
