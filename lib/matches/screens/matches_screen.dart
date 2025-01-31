import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_card.dart';
import 'package:tracket/utils/colors.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 241, 186),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Completed'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 107, 220, 111),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: blackColor)),
                  child: Text('Live'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 241, 186),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Upcomming'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return const MatchCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
