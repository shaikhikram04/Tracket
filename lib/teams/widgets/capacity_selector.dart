import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class CapacitySelector extends StatelessWidget {
  const CapacitySelector({
    super.key,
    required this.maxPlayersCapacity,
    required this.onIncrement,
    required this.onDecrement,
    required this.label,
  });

  final int maxPlayersCapacity;
  final void Function() onIncrement;
  final void Function() onDecrement;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(
          '$label:',
          style: MyTextStyle(context).bodyLarge,
        ),
        const Spacer(),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle),
          iconSize: 30,
          color: darkGreenColor,
        ),
        Text(
          '$maxPlayersCapacity',
          style: MyTextStyle(context).bodyLarge,
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle),
          iconSize: 30,
          color: darkGreenColor,
        ),
      ],
    );
  }
}
