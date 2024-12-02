import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/authentication/verification_screen.dart';
import 'package:tracket/screens/home.dart';
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
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    _showVerificationDialog();
    try {
      final user =
          await FirebaseAuthMethods.sendVerificationEmail(email, password);

      ref.read(verificationStepProvider.notifier).updateStep(1);

      // Start listening for email verification
      _checkEmailVerification(user!);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'Email-is-already-in-use') {
        ref.read(verificationStepProvider.notifier).updateStep(-2);
      } else {
        ref.read(verificationStepProvider.notifier).updateStep(-1);
      }
    }
  }

  void _checkEmailVerification(User user) {
    // Create a timer that can be cancelled
    Timer? verificationTimer;

    verificationTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await user.reload();
      user = FirebaseAuthMethods.currentUser;

      if (user.emailVerified) {
        // Cancel the timer first to stop further checks
        verificationTimer?.cancel();

        // Update verification steps with delays
        ref.read(verificationStepProvider.notifier).updateStep(2);
        await Future.delayed(const Duration(seconds: 1));

        //* Signup user after email verification!
        await FirebaseAuthMethods.signupUser(
          userId: user.uid,
          username: _usernameController.text.trim(),
          email: user.email!,
        );

        ref.read(verificationStepProvider.notifier).updateStep(3);
        await Future.delayed(const Duration(seconds: 1));

        // Navigate to home screen
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });

    // Optional: Set a maximum timeout for verification
    Future.delayed(const Duration(minutes: 3), () {
      verificationTimer?.cancel();
      if (!user.emailVerified) {
        user.delete();
      }
    });
  }

  void _showVerificationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const VerificationScreen();
      },
    );
  }

  Future<void> _userLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final res = await FirebaseAuthMethods.loginUser(
        email: email,
        password: password,
      );

      if (res != 'success') {
        print(res);
      }
    }
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
                  () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _isPasswordHidden = true;
                      _passwordController.clear();
                    });
                  },
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
