import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/providers/auth_state_provider.dart';
import 'package:tracket/features/authentication/widgets/auth_form.dart';
import 'package:tracket/features/authentication/widgets/auth_submit_button.dart';
import 'package:tracket/features/authentication/widgets/authentication_toggle.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';

class UserAuth extends ConsumerStatefulWidget {
  const UserAuth({super.key});

  @override
  ConsumerState<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends ConsumerState<UserAuth> {
  @override
  void initState() {
    super.initState();
  }

  void _onSubmit(bool isLogin) {
    isLogin
        ? ref.read(playerAuthProvider.notifier).login(context, false)
        : ref.read(playerAuthProvider.notifier).signup(context, false);
  }

  void _toggleUser() {
    ref.read(playerAuthProvider.notifier).toggleUserAuth();
  }

  @override
  Widget build(BuildContext context) {
    final userAuthState = ref.watch(playerAuthProvider);

    return AuthForm(
      formKey: userAuthState.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userAuthState.isLogin ? 'Login as User' : 'Signup as user',
            semanticsLabel: userAuthState.isLogin
                ? 'Login form for users'
                : 'Signup form for users',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 30),
          if (!userAuthState.isLogin)
            MyTextField(
              isLogin: userAuthState.isLogin,
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(playerName: value),
              hintText: 'Username',
              validator: ValidationServices.usernameValidator,
              fillColor: LightThemeColors.backgroundColor,
              prefixIcon: AppIconData.person,
            ),
          if (!userAuthState.isLogin) const SizedBox(height: 30),
          MyTextField(
            isLogin: userAuthState.isLogin,
            onSave: (value) =>
                ref.read(playerAuthProvider.notifier).updateField(email: value),
            hintText: 'Email',
            validator: ValidationServices.emailValidator,
            fillColor: LightThemeColors.backgroundColor,
            prefixIcon: AppIconData.email,
          ),
          const SizedBox(height: 30),
          MyTextField(
            isLogin: userAuthState.isLogin,
            onSave: (value) => ref
                .read(playerAuthProvider.notifier)
                .updateField(password: value),
            hintText: 'Password',
            isPasswordHidden: userAuthState.isPasswordHidden,
            changeVisibility:
                ref.read(playerAuthProvider.notifier).togglePasswordVisibility,
            validator: (value) => ValidationServices.passwordValidator(
                value, userAuthState.isLogin),
            fillColor: LightThemeColors.backgroundColor,
            prefixIcon: AppIconData.lock,
          ),
          const SizedBox(height: 30),
          AuthSubmitButton(
              isLoading: userAuthState.isLoading,
              onSubmit: () => _onSubmit(userAuthState.isLogin),
              isLogin: userAuthState.isLogin),
          const SizedBox(height: 15),
          AuthenticationToggle(
            isLogin: userAuthState.isLogin,
            toggleAuth: _toggleUser,
          )
        ],
      ),
    );
  }
}
