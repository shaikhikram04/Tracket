import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class PlayerCapacitySelector extends StatelessWidget {
  const PlayerCapacitySelector({
    super.key,
    required this.maxPlayersCapacity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int maxPlayersCapacity;
  final void Function() onIncrement;
  final void Function() onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(
          'Max Players Capacity:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            if (maxPlayersCapacity > 11) {
              onDecrement();
            } else {
              showSnackBar(
                  'Max players capacity cannot be less than 11', context);
            }
          },
          icon: const Icon(Icons.remove_circle),
          iconSize: 30,
          color: darkGreenColor,
        ),
        Text(
          '$maxPlayersCapacity',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
          onPressed: () {
            if (maxPlayersCapacity < 30) {
              onIncrement();
            } else {
              showSnackBar('Max players capacity cannot exceed 30', context);
            }
          },
          icon: const Icon(Icons.add_circle),
          iconSize: 30,
          color: darkGreenColor,
        ),
      ],
    );
  }
}
