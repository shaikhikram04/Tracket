import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.isLogin,
  });

  final bool isLoading;
  final VoidCallback onSubmit;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CustomButton.primary(
      width: width * 0.8,
      height: TSizes.buttonHeight,
      onPressed: onSubmit,
      text: isLogin ? TTextStrings.login : TTextStrings.signup,
      isLoading: isLoading,
    );
  }
}
