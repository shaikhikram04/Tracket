import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
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
      height: 50,
      elevation: 10,
      onPressed: onSubmit,
      text: isLogin ? 'Login' : 'Sign Up',
      isLoading: isLoading,
      backgroundColor: primaryColor,
      foregroundColor: LightThemeColors.surfaceColor,
      borderRadius: 10,
      textStyle:
          Theme.of(context).textTheme.titleMedium!.copyWith(color: onPrimary),
    );
  }
}
