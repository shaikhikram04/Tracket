import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/provider/auth_screen_size.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/authentication/forget_password.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/my_text_button.dart';
import 'package:tracket/widgets/my_text_field.dart';

class UserAuth extends ConsumerStatefulWidget {
  const UserAuth({super.key});

  @override
  ConsumerState<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends ConsumerState<UserAuth> {
  var _isLogin = true;
  var _isPasswordHidden = true;

  late GlobalKey<FormState> _formKey;
  String? _username;
  String? _email;
  String? _password;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Future<void> _userSignup() async {
    if (!_formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(36);
      return;
    }

    _formKey.currentState!.save();

    String email = _email!.trim();
    String password = _password!.trim();
    String username = _username!.trim();

    showVerificationDialog(context, email);
    try {
      final user =
          await FirebaseAuthMethods.sendVerificationEmail(email, password);

      ref.read(verificationStepProvider.notifier).updateStep(1);

      // Start listening for email verification
      if (!mounted) return;
      FirebaseAuthMethods.checkEmailVerification(
        user: user!,
        username: username,
        ref: ref,
        context: context,
        role: 'user',
      );
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      ref.read(verificationStepProvider.notifier).updateStep(0);
      String title;
      String message;

      if (error.code == 'Email-is-already-in-use-as-user') {
        title = 'Email is already in use';
        message =
            'This email is already in use. Try another email or login as user with this email.';
      } else if (error.code == 'Email-is-already-in-use-as-player') {
        title = 'Email is already in use';
        message =
            'This email is already in use. Try another email or login as player with this email.';
      } else {
        title = 'Some Error!';
        message = 'Some error occurred. Please try again.';
      }
      showAlertDialog(
        context,
        title,
        message,
      );
    }
  }

  Future<void> _userLogin() async {
    if (!_formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(35);
      return;
    }

    final email = _email!.trim();
    final password = _password!.trim();

    try {
      await FirebaseAuthMethods.loginUser(
        email: email,
        password: password,
        context: context,
        ref: ref,
      );
    } catch (e) {
      return;
    }
  }

  void _toggleUser() {
    ref.read(authScreenSizeProvider.notifier).changeScreen(
          _isLogin ? AuthScreenType.userSignup : AuthScreenType.userLogin,
        );
    setState(() {
      _isLogin = !_isLogin;
      _isPasswordHidden = true;
      _formKey.currentState!.reset();
    });
  }

  void _onForgetPassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ForgetPassword(),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Login as User' : 'Signup as user',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            if (!_isLogin)
              MyTextField(
                onSave: (value) => _username = value,
                label: 'Username',
              ),
            if (!_isLogin) const SizedBox(height: 30),
            MyTextField(
                onSave: (value) => _email = value,
              label: 'Email',
            ),
            const SizedBox(height: 30),
            MyTextField(
                onSave: (value) => _password = value,
              label: 'Password',
              isPasswordHidden: _isPasswordHidden,
              changeVisibility: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLogin ? _userLogin : _userSignup,
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  _isLogin ? 'Login' : 'Sign Up',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                if (_isLogin)
                  MyTextButton(
                    text: 'Forget password?',
                    onPressed: _onForgetPassword,
                    isUnderlined: true,
                  ),
                const Spacer(),
                MyTextButton(
                  text: _isLogin ? 'Sign Up?' : 'Login?',
                  onPressed: _toggleUser,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
