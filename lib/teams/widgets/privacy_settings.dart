import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool isSwitchedOn = true;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        children: [
          getTitleText('Privacy Settings', context),
          const SizedBox(height: 10),
          SwitchListTile(
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
            activeColor: enableSwitchColor,
            onChanged: (value) {
              setState(() {
                isSwitchedOn = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
