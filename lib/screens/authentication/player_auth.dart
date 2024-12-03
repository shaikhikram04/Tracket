import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/provider/auth_screen_size.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/my_text_field.dart';

class PlayerAuth extends ConsumerStatefulWidget {
  const PlayerAuth({super.key});

  @override
  ConsumerState<PlayerAuth> createState() => _PlayerAuthState();
}

class _PlayerAuthState extends ConsumerState<PlayerAuth> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _playerNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isPasswordHidden = true;
  bool _isLogin = true;
  bool _isBowler = false;
  String _cricketRole = '';
  String _battingPosition = '';
  String _bowlingStyle = '';
  String _bowlingArm = '';

  @override
  void initState() {
    super.initState();
    _playerNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void onSelectRole(String? role) {
    _cricketRole = role!;
  }

  void onSelectBattingPosition(String? position) {
    _battingPosition = position!;
  }

  void onSelectBowlingStyle(String? style) {
    _bowlingStyle = style!;
    if (style != 'none' && _isBowler == false) {
      setState(() {
        ref.read(authScreenSizeProvider.notifier).incrementSize(86);
        _isBowler = true;
      });
    } else if (_isBowler == true) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(-86);
      setState(() {
        _isBowler = false;
      });
    }
  }

  void onSelectBowlingArm(String? arm) {
    _bowlingArm = arm!;
  }

  void _togglePlayerAuth() {
    ref.read(authScreenSizeProvider.notifier).changeScreen(
        _isLogin ? AuthScreenType.playerSignup : AuthScreenType.playerLogin);
    setState(() {
      _isLogin = !_isLogin;
      _isPasswordHidden = true;
      _formKey.currentState!.reset();
    });
  }

  Future<void> _playerSignup() async {
    if (!_formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(36);
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    showVerificationDialog(context, email);
    try {
      final user =
          await FirebaseAuthMethods.sendVerificationEmail(email, password);

      ref.read(verificationStepProvider.notifier).updateStep(1);

      // Start listening for email verification
      if (!mounted) return;
      FirebaseAuthMethods.checkEmailVerification(
        user: user!,
        username: _playerNameController.text.trim(),
        ref: ref,
        context: context,
        role: 'player',
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

  @override
  void dispose() {
    _playerNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> signUpField = [
      MyDropdownMenu(
        options: CricketRole.values,
        hintText: 'Select Cricket Role',
        onSelect: onSelectRole,
      ),
      const SizedBox(height: 30),
      MyDropdownMenu(
        options: Position.values,
        hintText: 'Select Batting Position',
        onSelect: onSelectBattingPosition,
      ),
      const SizedBox(height: 30),
      MyDropdownMenu(
        options: BowingStyle.values,
        hintText: 'Select Bowling Style',
        onSelect: onSelectBowlingStyle,
      ),
      const SizedBox(height: 30),
      if (_isBowler)
        MyDropdownMenu(
          options: Position.values,
          hintText: 'Select Bowling Arm',
          onSelect: onSelectBowlingArm,
        ),
      if (_isBowler) const SizedBox(height: 30),
    ];

    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              _isLogin ? 'Login as Player' : 'Signup as Player',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            if (!_isLogin)
              MyTextField(
                textController: _playerNameController,
                label: 'Player Name',
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
            if (!_isLogin) ...signUpField,
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLogin ? () {} : _playerSignup,
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
                  _togglePlayerAuth,
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
