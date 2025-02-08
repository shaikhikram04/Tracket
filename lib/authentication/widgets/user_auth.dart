import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/providers/auth_state_provider.dart';
import 'package:tracket/authentication/widgets/authentication_toggle.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

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
    final width = MediaQuery.of(context).size.width;
    final userAuthState = ref.watch(playerAuthProvider);

    return Form(
      key: userAuthState.formKey,
      child: Padding(
        padding: const EdgeInsets.all(25),
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
                label: 'Username',
                validator: ValidationServices.usernameValidator,
              ),
            if (!userAuthState.isLogin) const SizedBox(height: 30),
            MyTextField(
              isLogin: userAuthState.isLogin,
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(email: value),
              label: 'Email',
              validator: ValidationServices.emailValidator,
            ),
            const SizedBox(height: 30),
            MyTextField(
              isLogin: userAuthState.isLogin,
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(password: value),
              label: 'Password',
              isPasswordHidden: userAuthState.isPasswordHidden,
              changeVisibility: ref
                  .read(playerAuthProvider.notifier)
                  .togglePasswordVisibility,
              validator: (value) => ValidationServices.passwordValidator(
                  value, userAuthState.isLogin),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: MyElevatedButton.primaryElevatedButton(
                onPressed: userAuthState.isLoading
                    ? null
                    : () => _onSubmit(userAuthState.isLogin),
                text: userAuthState.isLogin ? 'Login' : 'Sign Up',
                isLoading: userAuthState.isLoading,
                textStyle: MyTextStyle(context).cardTitle,
                padding: null,
              ),
            ),
            const SizedBox(height: 15),
            AuthenticationToggle(
              isLogin: userAuthState.isLogin,
              toggleAuth: _toggleUser,
            )
          ],
        ),
      ),
    );
  }
}
