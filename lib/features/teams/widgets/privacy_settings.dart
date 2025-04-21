import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
    final isDark = THelperFunction.isDarkMode(context);

    return Padding(
      padding: TPadding.hPaddingXs.copyWith(bottom: TSizes.lg),
      child: SwitchListTile(
        value: isSwitchedOn,
        title: Text(
          TTextStrings.makeTeamPrivate,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
              fontSize: TSizes.fontSizeLg),
        ),
        subtitle: const Text(
          TTextStrings.makeTeamPublicDescription,
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
