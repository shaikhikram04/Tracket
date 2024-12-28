import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/utils/colors.dart';

class AddPlayerScreen extends ConsumerStatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  ConsumerState<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends ConsumerState<AddPlayerScreen> {
  late Team _team;
  bool _adding = false;

  @override
  void initState() {
    _team = ref.read(teamProvider);
    super.initState();
  }

  void addPlayer(
    String playerId,
    String playername,
    String cricketRole,
    String? profileImageUrl,
  ) async {
    setState(() {
      _adding = true;
    });
    final playerInfo = {
      'id': playerId,
      'name': playername,
      'cricketRole': cricketRole,
      'imageUrl': profileImageUrl,
      'role': 'player',
    };
    final teamInfo = {
      'id': _team.id,
      'name': _team.name,
      'shortName': _team.shortName,
      'logoUrl': _team.logoUrl,
      'role': 'player',
    };
    await FirestoreMethods.addPlayerToTeam(
      playerInfo: playerInfo,
      teamInfo: teamInfo,
      ref: ref,
      context: context,
    );
    setState(() {
      _adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _team = ref.watch(teamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Player'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('players')
            .where('role', isEqualTo: 'player')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong. Please try again later.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Players Found'),
            );
          }
          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              final playerData = snap[index].data();
              final List teamsId = playerData['teams']
                  .map((team) => team['id'].toString())
                  .toList();
              final isAdded = teamsId.contains(_team.id);
              final bool allowDirectTeamAdd = playerData['allowDirectTeamAdd'];
              final bottonText = isAdded
                  ? 'Added'
                  : allowDirectTeamAdd
                      ? 'Add'
                      : 'Offer';
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: playerData['profileImageUrl'] != null
                      ? CachedNetworkImageProvider(
                          playerData['profileImageUrl'])
                      : const AssetImage('assets/images/Default_user_pfp.jpg'),
                  radius: 30,
                ),
                title: Text(playerData['playerName']),
                subtitle: Text(playerData['cricketRole']),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PlayerProfileScreen(player: Player.fromSeed(playerData)),
                )),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdded ? Colors.grey : buttonBgColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    // fixedSize: const Size(90, 30),
                  ),
                  onPressed: isAdded
                      ? null
                      : () => addPlayer(
                            playerData['playerId'],
                            playerData['playerName'],
                            playerData['cricketRole'],
                            playerData['profileImageUrl'],
                          ),
                  child: _adding
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeAlign: 0,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          bottonText,
                          style: const TextStyle(
                            color: blackColor,
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
