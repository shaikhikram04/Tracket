import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class BaseSelectionSheet extends StatelessWidget {
  final String title;
  final String instructions;
  final Widget content;
  final bool showCancelButton;
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final bool confirmEnabled;

  const BaseSelectionSheet({
    Key? key,
    required this.title,
    required this.instructions,
    required this.content,
    required this.onCancel,
    this.showCancelButton = true,
    this.onConfirm,
    this.confirmEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  instructions,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: content),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Row(
              children: [
                if (showCancelButton)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: confirmEnabled ? onConfirm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: grassGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
