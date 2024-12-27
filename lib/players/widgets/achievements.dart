import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key, required this.achievements});

  final List achievements;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(children: [
      Text(
        'No Achievements Yet',
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 35, 2, 0)),
      ),
      Text(
        'Complete tasks and challenges to earn your first achievement badge!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontFamily: 'Inter',
              color: Colors.black87,
            ),
      ),
      const SizedBox(height: 25),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
        child: Text(
          'View Available Achievements',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    ]);

    if (achievements.isNotEmpty) {
      content = Wrap(
        children: List.generate(
          achievements.length,
          (index) => HighlightedLabel(
            text: achievements[index],
            bgColor: Colors.deepOrange.shade100,
            textColor: Colors.deepOrange.shade900,
          ),
        ),
      );
    }

    return Card(
      color: whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 23),
            ),
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }
}
