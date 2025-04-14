import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/features/authentication/screens/forget_password.dart';
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
            text: 'Forget password?',
            onPressed: onForgetPassword,
            isUnderlined: true,
          ),
        const Spacer(),
        MyTextButton(
          text: isLogin ? 'Sign Up?' : 'Login?',
          onPressed: toggleAuth,
        ),
      ],
    );
  }
}
