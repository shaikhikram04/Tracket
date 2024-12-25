import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tracket/screens/teams/add_player_screen.dart';
import 'package:tracket/widgets/player_tile.dart';

class Squad extends StatelessWidget {
  const Squad({
    super.key,
    required this.playersList,
    required this.captainId,
    required this.wicketKeeperId,
    required this.teamId,
  });

  final List playersList;
  final String? captainId;
  final String? wicketKeeperId;
  final String teamId;

  @override
  Widget build(BuildContext context) {
    void addPlayer() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddPlayerScreen(
          teamId: teamId,
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Squad',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 23),
              ),
              const Spacer(),
              IconButton(
                onPressed: addPlayer,
                iconSize: 30,
                icon: const Icon(Icons.group_add),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        playersList.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No Player joined yet!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tap the button above to request player to join.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ZoomIn(
                      child: Icon(
                        Icons.arrow_outward,
                        size: 50,
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: List.generate(
                playersList.length,
                (index) {
                  final playerDetail = playersList[index];
                  final playerId = playerDetail['id'];
                  final isCaptain =
                      captainId == null ? false : captainId == playerId;
                  final isWicketKeeper = wicketKeeperId == null
                      ? false
                      : wicketKeeperId == playerId;
                  return PlayerTile(
                    isCaptain: isCaptain,
                    isWicketKeeper: isWicketKeeper,
                    playerName: playerDetail['name'],
                    cricketRole: playerDetail['cricketRole'],
                  );
                },
              )),
      ],
    );
  }
}
