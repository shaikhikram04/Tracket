import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/screens/forget_password.dart';
import 'package:tracket/authentication/providers/auth_screen_size.dart';
import 'package:tracket/authentication/providers/verification_step.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Future<void> _userSignup() async {
    if (!_formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).hasError();
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
        imageUrl: '',
      );
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      ref.read(verificationStepProvider.notifier).updateStep(0);

      showAlertDialog(
        context,
        'Error',
        getErrorMessage(error.code),
      );
    }
  }

  Future<void> _userLogin() async {
    if (!_formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).hasError();
      return;
    }

    _formKey.currentState!.save();

    final email = _email!.trim();
    final password = _password!.trim();

    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuthMethods.loginUser(
        email: email,
        password: password,
        context: context,
        ref: ref,
      );
    } catch (e) {
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleUser() {
    ref.read(authScreenSizeProvider.notifier).changeScreen(
          _isLogin ? AuthScreenType.userSignup : AuthScreenType.userLogin,
        );
    setState(() {
      _isLogin = !_isLogin;
      _isPasswordHidden = true;
      if (_formKey.currentState != null) _formKey.currentState!.reset();
    });
  }

  void _onForgetPassword() {
    pushScreen(context, const ForgetPassword());
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
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
              semanticsLabel:
                  _isLogin ? 'Login form for users' : 'Signup form for users',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            if (!_isLogin)
              MyTextField(
                isLogin: _isLogin,
                onSave: (value) => _username = value,
                label: 'Username',
                validator: usernameValidator,
              ),
            if (!_isLogin) const SizedBox(height: 30),
            MyTextField(
              isLogin: _isLogin,
              onSave: (value) => _email = value,
              label: 'Email',
              validator: emailValidator,
            ),
            const SizedBox(height: 30),
            MyTextField(
              isLogin: _isLogin,
              onSave: (value) => _password = value,
              label: 'Password',
              isPasswordHidden: _isPasswordHidden,
              changeVisibility: _togglePasswordVisibility,
              validator: (value) => passwordValidator(value, _isLogin),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: MyElevatedButton.primaryElevatedButton(
                context,
                onPressed:
                    _isLoading ? null : (_isLogin ? _userLogin : _userSignup),
                text: _isLogin ? 'Login' : 'Sign Up',
                isLoading: _isLoading,
                isSubmit: true,
              ),
            ),
            const SizedBox(height: 15),
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
