import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/highlighted_label.dart';
import 'package:tracket/utils/constants/colors.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key, required this.achievements});

  final List achievements;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(children: [
      Text(
        'No Achievements Yet',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      Text(
        'Complete tasks and challenges to earn your first achievement badge!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
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
                color: LightThemeColors.surfaceColor,
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
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange.shade900,
                ),
            color: Colors.deepOrange.shade100,
          ),
        ),
      );
    }

    return Card(
      color: LightThemeColors.surfaceColor,
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
