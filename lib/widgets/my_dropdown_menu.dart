import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  const MyDropdownMenu({
    super.key,
    required this.options,
    required this.label,
    required this.onSelect,
  });

  final List<String> options;
  final String label;
  final void Function(String? value) onSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      onSelected: onSelect,
      width: 337,
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
