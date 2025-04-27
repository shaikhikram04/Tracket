import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/buttons/my_text_button.dart';
import 'package:tracket/features/authentication/screens/forget_password.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AuthenticationToggle extends StatelessWidget {
  const AuthenticationToggle({
    super.key,
    required this.isLogin,
    required this.toggleAuth,
  });

  final bool isLogin;
  final void Function() toggleAuth;

  @override
  Widget build(BuildContext context) {
    void onForgetPassword() {
      THelperFunction.pushScreen(context, const ForgetPassword());
    }

    return Row(
      children: [
        if (isLogin)
          MyTextButton(
            text: TTextStrings.forgetPassword,
            onPressed: onForgetPassword,
            isUnderlined: true,
          ),
        const Spacer(),
        MyTextButton(
          text: isLogin ? TTextStrings.wantToSignup : TTextStrings.wantToLogin,
          onPressed: toggleAuth,
        ),
      ],
    );
  }
}
