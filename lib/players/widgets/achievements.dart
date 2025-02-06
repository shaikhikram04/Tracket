import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key, required this.achievements});

  final List achievements;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(children: [
      Text(
        'No Achievements Yet',
        style: MyTextStyle(context).headlineSmall,
      ),
      Text(
        'Complete tasks and challenges to earn your first achievement badge!',
        textAlign: TextAlign.center,
        style: MyTextStyle(context).emphasisHigh,
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
          style: MyTextStyle(context).bodyMedium.copyWith(color: whiteColor),
        ),
      ),
    ]);

    if (achievements.isNotEmpty) {
      content = Wrap(
        children: List.generate(
          achievements.length,
          (index) => HighlightedLabel(
            text: achievements[index],
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
