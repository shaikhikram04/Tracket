import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  const MyDropdownMenu({
    super.key,
    required this.options,
    required this.onSelect,
    this.initialSelection,
    this.controller,
    this.hintText,
    this.label = '',
    this.leadingIcon,
  });

  final List<String> options;
  final String label;
  final void Function(String? value) onSelect;
  final String? initialSelection;
  final TextEditingController? controller;
  final String? hintText;
  final Icon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DropdownMenu(
      initialSelection: initialSelection,
      controller: controller,
      onSelected: onSelect,
      width: width * 0.8,
      label: label.isEmpty ? null : Text(label),
      hintText: hintText,
      leadingIcon: leadingIcon,
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
