import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/highlighted_label.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key, required this.achievements});

  final List achievements;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    Widget content = Column(children: [
      Text(
        'No Achievements Yet',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 10),
      Text(
        'Complete tasks and challenges to earn your first achievement badge!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: 25),
      CustomButton.primary(
        onPressed: () {
          THelperFunction.showAlertDialog(
            context,
            'No Achievements Yet',
            'There are no achievements available yet. New achievements will be added soon.',
          );
        },
        text: 'View Available Achievements',
        size: ButtonSize.medium,
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
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

    return MyCard(
      child: Column(
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 22,
                  color: isDark ? primaryLight : primaryColor,
                ),
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }
}
