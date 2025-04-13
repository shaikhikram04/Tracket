import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({
    super.key,
    required this.isTeamPrivate,
    required this.onSwitchChanged,
  });

  final bool isTeamPrivate;
  final void Function(bool) onSwitchChanged;

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  late bool isSwitchedOn;

  @override
  void initState() {
    isSwitchedOn = widget.isTeamPrivate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 16),
      child: SwitchListTile(
        value: isSwitchedOn,
        title: Text(
          'Make team private',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black, fontSize: 17),
        ),
        subtitle: const Text(
          'When your team is private, only admins can add new members.',
        ),
        activeColor: InteractiveColors.focused,
        onChanged: (value) {
          setState(() {
            isSwitchedOn = value;
          });
          widget.onSwitchChanged(value);
        },
      ),
    );
  }
}
