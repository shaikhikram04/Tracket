import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tracket/matches/screens/create_match_screen.dart';
import 'package:tracket/matches/widgets/match_card.dart';
import 'package:tracket/utils/utils.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return const MatchCard();
        },
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.45,
        overlayColor: Colors.black,
        animationDuration: const Duration(milliseconds: 280),
        animationCurve: Curves.easeInOut,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.schedule),
            label: 'Schedule Match',
            onTap: () {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.create),
            label: 'Create Match',
            onTap: () {
              pushScreen(context, const CreateMatchScreen());
            },
          ),
        ],
      ),
    );
  }
}
