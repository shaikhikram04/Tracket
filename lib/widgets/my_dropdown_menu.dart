import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  const MyDropdownMenu({
    super.key,
    required this.options,
    required this.hintText,
  });

  final List options;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 330,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surface,
        ),
      ),
      hintText: hintText,
      dropdownMenuEntries: Iterable.generate(
        options.length,
        (index) => DropdownMenuEntry(
          value: options[index].name,
          label: options[index].name,
        ),
      ).toList(),
    );
  }
}
