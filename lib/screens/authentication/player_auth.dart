import 'package:flutter/material.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/my_text_field.dart';

class PlayerAuth extends StatefulWidget {
  const PlayerAuth({super.key});

  @override
  State<PlayerAuth> createState() => _PlayerAuthState();
}

class _PlayerAuthState extends State<PlayerAuth> {
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
        _isBowler = true;
      });
    } else if (_isBowler == true) {
      setState(() {
        _isBowler = false;
      });
    }
  }

  void onSelectBowlingArm(String? arm) {
    _bowlingArm = arm!;
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
       MyDropdownMenu(
        options: Position.values,
        hintText: 'Select Bowling Arm',
        onSelect: onSelectBowlingArm,
      ),
      const SizedBox(height: 30),
    ];

    final width = MediaQuery.of(context).size.width;
    return Form(
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
                onPressed: () {},
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
