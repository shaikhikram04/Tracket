import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  const MyDropdownMenu({
    super.key,
    required this.options,
    required this.label,
    required this.onSelect,
    this.initialSelection,
  });

  final List<String> options;
  final String label;
  final void Function(String? value) onSelect;
  final String? initialSelection;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DropdownMenu(
      initialSelection: initialSelection,
      onSelected: onSelect,
      width: width * 0.8,
      label: Text(label),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surface,
        ),
      ),
      dropdownMenuEntries: Iterable.generate(
        options.length,
        (index) => DropdownMenuEntry(
          value: options[index],
          label: options[index].toUpperCase(),
        ),
      ).toList(),
    );
  }
}
