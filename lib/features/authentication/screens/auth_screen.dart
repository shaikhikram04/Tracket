import 'package:flutter/material.dart';
import 'package:tracket/features/authentication/widgets/app_logo.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/auth_body.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/devices/devices_utility.dart';

//* Authentication screen that provides tabs for Player and User authentication
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight = TDeviceUtils.getSafeAreaHeight(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeAreaHeight),
            child: const Padding(
              padding: TPadding.hPaddingMd,
              child: Column(
                children: [
                  SizedBox(height: TSizes.verticalSpacingMd),
                  AppLogo(),
                  SizedBox(height: TSizes.verticalSpacingMd),
                  AuthBody(),
                  SizedBox(height: TSizes.verticalSpacingMd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
