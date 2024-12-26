import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/provider/auth_screen_size.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/authentication/screens/forget_password.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/custom_widgets/my_elevated_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

class PlayerAuth extends ConsumerStatefulWidget {
  const PlayerAuth({super.key});

  @override
  ConsumerState<PlayerAuth> createState() => _PlayerAuthState();
}

class _PlayerAuthState extends ConsumerState<PlayerAuth> {
  late GlobalKey<FormState> _formKey;
  String? _playerName;
  String? _email;
  String? _password;
  bool _isPasswordHidden = true;
  bool _isLogin = true;
  bool _isBowler = false;
  CricketRole? _cricketRole;
  Position? _battingPosition;
  BowlingStyle? _bowlingStyle;
  Position? _bowlingArm;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  void onSelectRole(String? role) {
    _cricketRole = CricketRole.values.firstWhere(
      (value) => value.name == role,
    );
    if ((_cricketRole == CricketRole.bowler ||
            _cricketRole == CricketRole.allRounder) &&
        !_isBowler) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(86);
      setState(() {
        _isBowler = true;
      });
    } else if ((_cricketRole == CricketRole.batsman ||
            _cricketRole == CricketRole.wicketKeeper) &&
        _isBowler) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(-86);
      setState(() {
        _isBowler = false;
      });
    }
  }

  void onSelectBattingPosition(String? position) {
    _battingPosition = Position.values.firstWhere(
      (element) => element.name == position,
    );
  }

  void onSelectBowlingStyle(String? style) {
    _bowlingStyle = BowlingStyle.values.firstWhere(
      (element) => element.name == style,
    );
    if (_bowlingStyle != BowlingStyle.none && _isBowler == false) {
      setState(() {
        ref.read(authScreenSizeProvider.notifier).incrementSize(86);
        _isBowler = true;
      });
    } else if (_bowlingStyle == BowlingStyle.none && _isBowler == true) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(-86);
      setState(() {
        _isBowler = false;
      });
    }
  }

  void onSelectBowlingArm(String? arm) {
    _bowlingArm = Position.values.firstWhere(
      (element) => element.name == arm,
    );
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

  bool _isDropdownSelected(String? dropdown, String label) {
    if (dropdown == null) {
      if (label == 'Bowling Arm' && _bowlingStyle == BowlingStyle.none) {
        return true;
      }
      showSnackBar('Please select $label', context);
      return false;
    }
    return true;
  }

  Future<void> _playerSignup() async {
    if (!_formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).hasError();
      return;
    }
    if (!_isDropdownSelected(_cricketRole?.name, 'Cricket Role')) {
      return;
    }
    if (!_isDropdownSelected(_battingPosition?.name, 'Batting Position')) {
      return;
    }
    if (!_isDropdownSelected(_bowlingStyle?.name, 'Bowling Style')) {
      return;
    }
    if (!_isDropdownSelected(_bowlingArm?.name, 'Bowling Arm')) {
      return;
    }

    _formKey.currentState!.save();

    String email = _email!.trim();
    String password = _password!.trim();
    String playerName = _playerName!.trim();

    showVerificationDialog(context, email);
    try {
      final user =
          await FirebaseAuthMethods.sendVerificationEmail(email, password);

      ref.read(verificationStepProvider.notifier).updateStep(1);

      // Start listening for email verification
      if (!mounted) return;
      FirebaseAuthMethods.checkEmailVerification(
        user: user!,
        username: playerName,
        ref: ref,
        context: context,
        role: 'player',
        battingPosition: _battingPosition,
        bowlingArm: _bowlingArm,
        bowlingStyle: _bowlingStyle,
        cricketRole: _cricketRole,
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

  Future<void> _playerLogin() async {
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
      await FirebaseAuthMethods.loginPlayer(
        email: email,
        password: password,
        context: context,
        ref: ref,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      return;
    }
  }

  void _onForgetPassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ForgetPassword(),
    ));
  }

  @override
  void dispose() {
    _formKey.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> signUpField = [
      MyDropdownMenu(
        options: enumToString(CricketRole.values),
        label: 'Select Cricket Role',
        onSelect: onSelectRole,
      ),
      const SizedBox(height: 30),
      MyDropdownMenu(
        options: enumToString(Position.values),
        label: 'Select Batting Position',
        onSelect: onSelectBattingPosition,
      ),
      const SizedBox(height: 30),
      MyDropdownMenu(
        options: _isBowler
            ? enumToString(BowlingStyle.values.sublist(1))
            : enumToString(BowlingStyle.values),
        label: 'Select Bowling Style',
        onSelect: onSelectBowlingStyle,
      ),
      const SizedBox(height: 30),
      if (_isBowler)
        MyDropdownMenu(
          options: enumToString(Position.values),
          label: 'Select Bowling Arm',
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
                isLogin: _isLogin,
                onSave: (value) => _playerName = value,
                label: 'Player Name',
              ),
            if (!_isLogin) const SizedBox(height: 30),
            MyTextField(
              isLogin: _isLogin,
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
              isLogin: _isLogin,
            ),
            const SizedBox(height: 30),
            if (!_isLogin) ...signUpField,
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: MyElevatedButton(
                onPressed: _isLogin ? _playerLogin : _playerSignup,
                text: _isLogin ? 'Login' : 'Sign Up',
                isLoading: _isLoading,
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
                  onPressed: _togglePlayerAuth,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
