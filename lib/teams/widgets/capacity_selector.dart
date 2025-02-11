import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class CapacitySelector extends StatelessWidget {
  const CapacitySelector({
    super.key,
    required this.capacity,
    required this.onIncrement,
    required this.onDecrement,
    required this.label,
    this.labelColor,
  });

  final int capacity;
  final void Function() onIncrement;
  final void Function() onDecrement;
  final String label;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(
          '$label:',
          style: MyTextStyle(context).bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
        ),
        SizedBox(width: 20),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle),
          iconSize: 30,
          color: darkGreenColor,
        ),
        SizedBox(width: 10),
        Text(
          '$capacity',
          style: MyTextStyle(context).bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(width: 10),
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
