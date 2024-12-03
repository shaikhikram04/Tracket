import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/provider/auth_screen_size.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/authentication/verification_screen.dart';
import 'package:tracket/widgets/my_text_field.dart';

class UserAuth extends ConsumerStatefulWidget {
  const UserAuth({super.key});

  @override
  ConsumerState<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends ConsumerState<UserAuth> {
  var _isLogin = true;
  var _isPasswordHidden = true;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendVerificationEmail() async {
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    _showVerificationDialog();
    try {
      final user =
          await FirebaseAuthMethods.sendVerificationEmail(email, password);

      ref.read(verificationStepProvider.notifier).updateStep(1);

      // Start listening for email verification
      if (!mounted) return;
      FirebaseAuthMethods.checkEmailVerification(
        user: user!,
        username: _usernameController.text.trim(),
        ref: ref,
        context: context,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'Email-is-already-in-use-as-user') {
        ref.read(verificationStepProvider.notifier).updateStep(-2);
      } else if (error.code == 'Email-is-already-in-use-as-player') {
        ref.read(verificationStepProvider.notifier).updateStep(-3);
      } else {
        ref.read(verificationStepProvider.notifier).updateStep(-1);
      }
    }
  }

  void _showVerificationDialog() {
    final String email = _emailController.text.trim();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return VerificationScreen(email);
      },
    );
  }

  Future<void> _userLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        await FirebaseAuthMethods.loginUser(
          email: email,
          password: password,
        );
      } catch (e) {}
    }
  }

  void _toggleUser() {
    ref.read(authScreenSizeProvider.notifier).changeScreen(
        _isLogin ? AuthScreenType.userSignup : AuthScreenType.userLogin);
    setState(() {
      _isLogin = !_isLogin;
      _isPasswordHidden = true;
      _formKey.currentState!.reset();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                textController: _usernameController,
                label: 'Username',
              ),
            if (!_isLogin) const SizedBox(height: 30),
            MyTextField(
              textController: _emailController,
              isEmail: true,
              label: 'Email',
            ),
            const SizedBox(height: 30),
            MyTextField(
              textController: _passwordController,
              label: 'Password',
              isPassword: true,
              isPasswordHidden: _isPasswordHidden,
              onPressed: () {
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
                onPressed: _isLogin ? _userLogin : _sendVerificationEmail,
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
                  textButton(
                    'Forget password?',
                    true,
                    () {},
                  ),
                const Spacer(),
                textButton(
                  _isLogin ? 'Sign Up?' : 'Login?',
                  false,
                  _toggleUser,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textButton(String text, bool isUnderlined, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              decoration: isUnderlined ? TextDecoration.underline : null,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}
