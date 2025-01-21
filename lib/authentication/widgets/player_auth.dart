import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/models/player_auth_state.dart';
import 'package:tracket/authentication/providers/auth_state_provider.dart';
import 'package:tracket/authentication/widgets/authentication_toggle.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

class PlayerAuth extends ConsumerStatefulWidget {
  const PlayerAuth({super.key});

  @override
  ConsumerState<PlayerAuth> createState() => _PlayerAuthState();
}

class _PlayerAuthState extends ConsumerState<PlayerAuth> {
  late PlayerAuthState _playerAuthState;

  @override
  void initState() {
    super.initState();
    _playerAuthState = PlayerAuthState(
      formKey: GlobalKey<FormState>(),
      isLoading: false,
      isLogin: true,
      isBowler: false,
      isPasswordHidden: true,
    );
  }

  void _onSelectRole(String? role) {
    ref.read(playerAuthProvider.notifier).updateRole(role);
  }

  void _onSelectBattingPosition(String? position) {
    ref.read(playerAuthProvider.notifier).updateField(position: position);
  }

  void _onSelectBowlingStyle(String? style) {
    ref.read(playerAuthProvider.notifier).updateBowlingStyle(style);
  }

  void _onSelectBowlingArm(String? arm) {
    ref.read(playerAuthProvider.notifier).updateField(arm: arm);
  }

  void _togglePlayerAuth() {
    ref.read(playerAuthProvider.notifier).togglePlayerAuth();
  }

  void _onSubmit() {
    (_playerAuthState.isLogin
        ? ref.read(playerAuthProvider.notifier).login(context)
        : ref.read(playerAuthProvider.notifier).signup(context));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> signUpField = [
      MyDropdownMenu(
        options: enumToString(CricketRole.values),
        label: 'Select Cricket Role',
        onSelect: _onSelectRole,
      ),
      const SizedBox(height: 30),
      MyDropdownMenu(
        options: enumToString(Position.values),
        label: 'Select Batting Position',
        onSelect: _onSelectBattingPosition,
      ),
      const SizedBox(height: 30),
      MyDropdownMenu(
        options: _playerAuthState.isBowler
            ? enumToString(BowlingStyle.values.sublist(1))
            : enumToString(BowlingStyle.values),
        label: 'Select Bowling Style',
        onSelect: _onSelectBowlingStyle,
      ),
      const SizedBox(height: 30),
      if (_playerAuthState.isBowler)
        MyDropdownMenu(
          options: enumToString(Position.values),
          label: 'Select Bowling Arm',
          onSelect: _onSelectBowlingArm,
        ),
      if (_playerAuthState.isBowler) const SizedBox(height: 30),
    ];

    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _playerAuthState.formKey,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              _playerAuthState.isLogin ? 'Login as Player' : 'Signup as Player',
              semanticsLabel: _playerAuthState.isLogin
                  ? 'Login form for players'
                  : 'Signup form for players',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            if (!_playerAuthState.isLogin)
              MyTextField(
                  isLogin: _playerAuthState.isLogin,
                  onSave: (value) => ref
                      .read(playerAuthProvider.notifier)
                      .updateField(playerName: value),
                  label: 'Player Name',
                  validator: (value) =>
                      ValidationServices.nameValidator(value, 'Player name')),
            if (!_playerAuthState.isLogin) const SizedBox(height: 30),
            MyTextField(
              isLogin: _playerAuthState.isLogin,
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(email: value),
              label: 'Email',
              validator: ValidationServices.emailValidator,
            ),
            const SizedBox(height: 30),
            MyTextField(
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(password: value),
              validator: (value) => ValidationServices.passwordValidator(
                  value, _playerAuthState.isLogin),
              label: 'Password',
              isPasswordHidden: _playerAuthState.isPasswordHidden,
              changeVisibility: ref
                  .read(playerAuthProvider.notifier)
                  .togglePasswordVisibility,
              isLogin: _playerAuthState.isLogin,
            ),
            const SizedBox(height: 30),
            if (!_playerAuthState.isLogin) ...signUpField,
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: MyElevatedButton.primaryElevatedButton(
                context,
                onPressed: _playerAuthState.isLoading ? null : _onSubmit,
                text: _playerAuthState.isLogin ? 'Login' : 'Sign Up',
                isLoading: _playerAuthState.isLoading,
                isSubmit: true,
              ),
            ),
            const SizedBox(height: 15),
            AuthenticationToggle(
              isLogin: _playerAuthState.isLogin,
              toggleAuth: _togglePlayerAuth,
            )
          ],
        ),
      ),
    );
  }
}
