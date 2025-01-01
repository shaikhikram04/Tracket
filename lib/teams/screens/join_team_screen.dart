import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_small_elevated_button.dart';

class JoinTeamScreen extends ConsumerStatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  ConsumerState<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends ConsumerState<JoinTeamScreen> {
  late final List<String> playerTeamsId;
  late Player _player;

  @override
  void initState() {
    super.initState();
    _player = ref.read(playerProvider);
    playerTeamsId = _player.teams!.map((e) => e['id'].toString()).toList();
  }

  void toggleJoining(String playerId, bool isAdding) {
    if (isAdding) {
      ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
    }
  }

  void joinTeam(
    String teamId,
    String teamName,
    String teamShortName,
    String? teamLogoUrl,
  ) async {
    Map<String, dynamic> teamInfo = {
      'id': teamId,
      'name': teamName,
      'shortName': teamShortName,
      'logoUrl': teamLogoUrl,
      'role': 'player',
    };
    Map<String, dynamic> playerInfo = {
      'id': _player.id,
      'name': _player.name,
      'cricketRole': _player.cricketRole!.name,
      'imageUrl': _player.profileImageUrl,
      'role': 'player',
    };
    toggleJoining(teamId, true);
    try {
      FirestoreMethods.addPlayerToTeam(
          playerInfo: playerInfo,
          teamInfo: teamInfo,
          ref: ref,
          context: context);
    } catch (e) {
      if (context.mounted) {
        showSnackBar('Failed to join team. Please try again later.', context);
      }
    } finally {
      toggleJoining(teamId, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Team'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No teams available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please check back later or create a new team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final teamData = Team.formSeed(snap[index].data(), null);
              return buildTeamTile(teamData);
            },
          );
        },
      ),
    );
  }

  Widget buildTeamTile(Team team) {
    final bool isTeamPrivate = team.isPrivate;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: team.logoUrl.isNotEmpty
              ? CachedNetworkImageProvider(team.logoUrl)
              : const AssetImage('assets/images/team_logo.png'),
          radius: 30,
        ),
        title: Text(team.name),
        subtitle: Text(team.shortName),
        onTap: () => pushScreen(context, const TeamProfileScreen()),
        trailing: Consumer(
          builder: (context, ref, _) {
            final requestStatus = ref.watch(requestStatusProvider);
            final isRequestInProgress =
                requestStatus.requestInProgress.contains(team.id);
            final isRequestSuccess =
                requestStatus.requestSuccess.contains(team.id);

            final isJoined =
                playerTeamsId.contains(team.id) || isRequestSuccess;
            final buttonText = isJoined
                ? 'Joined'
                : isTeamPrivate
                    ? 'Request'
                    : 'Join';

            return MySmallElevatedButton(
              isAdded: isJoined,
              onPressed: () =>
                  joinTeam(team.id, team.name, team.shortName, team.logoUrl),
              isLoading: isRequestInProgress,
              buttonText: buttonText,
            );
          },
        ),
      ),
    );
  }
}
