import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/features/authentication/providers/auth_state_provider.dart';
import 'package:tracket/features/authentication/widgets/auth_form.dart';
import 'package:tracket/features/authentication/widgets/auth_submit_button.dart';
import 'package:tracket/features/authentication/widgets/authentication_toggle.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/validator/validator.dart';

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
            userAuthState.isLogin
                ? TTextStrings.loginAsUser
                : TTextStrings.signupAsUser,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: TSizes.defaultSpace),
          if (!userAuthState.isLogin)
            MyTextField(
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(playerName: value),
              hintText: TTextStrings.username,
              validator: TValidator.usernameValidator,
              prefixIcon: AppIconData.person,
            ),
          if (!userAuthState.isLogin)
            const SizedBox(height: TSizes.defaultSpace),
          MyTextField(
            onSave: (value) =>
                ref.read(playerAuthProvider.notifier).updateField(email: value),
            hintText: TTextStrings.email,
            validator: TValidator.emailValidator,
            prefixIcon: AppIconData.email,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          MyTextField(
            onSave: (value) => ref
                .read(playerAuthProvider.notifier)
                .updateField(password: value),
            hintText: TTextStrings.password,
            isPasswordHidden: userAuthState.isPasswordHidden,
            changeVisibility:
                ref.read(playerAuthProvider.notifier).togglePasswordVisibility,
            validator: (value) => TValidator.passwordValidator(
                value, userAuthState.isLogin),
            prefixIcon: AppIconData.lock,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          AuthSubmitButton(
              isLoading: userAuthState.isLoading,
              onSubmit: () => _onSubmit(userAuthState.isLogin),
              isLogin: userAuthState.isLogin),
          const SizedBox(height: TSizes.spaceBtwItems),
          AuthenticationToggle(
            isLogin: userAuthState.isLogin,
            toggleAuth: _toggleUser,
          )
        ],
      ),
    );
  }
}
