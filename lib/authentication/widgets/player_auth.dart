import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/models/player_auth_state.dart';
import 'package:tracket/authentication/providers/auth_state_provider.dart';
import 'package:tracket/authentication/widgets/auth_form.dart';
import 'package:tracket/authentication/widgets/auth_submit_button.dart';
import 'package:tracket/authentication/widgets/authentication_toggle.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
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
  @override
  void initState() {
    super.initState();
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

  void _onSubmit(bool isLogin) {
    isLogin
        ? ref.read(playerAuthProvider.notifier).login(context, true)
        : ref.read(playerAuthProvider.notifier).signup(context, true);
  }

  @override
  Widget build(BuildContext context) {
    PlayerAuthState playerAuthState = ref.watch(playerAuthProvider);

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
        options: playerAuthState.shouldBall
            ? enumToString(BowlingStyle.values.sublist(1))
            : enumToString(BowlingStyle.values),
        label: 'Select Bowling Style',
        onSelect: _onSelectBowlingStyle,
      ),
      const SizedBox(height: 30),
      if (playerAuthState.isBowler)
        MyDropdownMenu(
          options: enumToString(Position.values),
          label: 'Select Bowling Arm',
          onSelect: _onSelectBowlingArm,
        ),
      if (playerAuthState.isBowler) const SizedBox(height: 30),
    ];

    return AuthForm(
      formKey: playerAuthState.formKey,
      child: Column(
        children: [
          Text(
            playerAuthState.isLogin ? 'Login as Player' : 'Signup as Player',
            semanticsLabel: playerAuthState.isLogin
                ? 'Login form for players'
                : 'Signup form for players',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 30),
          if (!playerAuthState.isLogin)
            MyTextField(
              isLogin: playerAuthState.isLogin,
              onSave: (value) => ref
                  .read(playerAuthProvider.notifier)
                  .updateField(playerName: value),
              hintText: 'Player Name',
              validator: (value) =>
                  ValidationServices.nameValidator(value, 'Player name'),
              fillColor: LightThemeColors.backgroundColor,
              prefixIcon: AppIconData.person,
            ),
          if (!playerAuthState.isLogin) const SizedBox(height: 30),
          MyTextField(
            isLogin: playerAuthState.isLogin,
            onSave: (value) =>
                ref.read(playerAuthProvider.notifier).updateField(email: value),
            hintText: 'Email',
            validator: ValidationServices.emailValidator,
            prefixIcon: AppIconData.email,
            fillColor: LightThemeColors.backgroundColor,
          ),
          const SizedBox(height: 30),
          MyTextField(
            onSave: (value) => ref
                .read(playerAuthProvider.notifier)
                .updateField(password: value),
            validator: (value) => ValidationServices.passwordValidator(
                value, playerAuthState.isLogin),
            hintText: 'Password',
            isPasswordHidden: playerAuthState.isPasswordHidden,
            changeVisibility:
                ref.read(playerAuthProvider.notifier).togglePasswordVisibility,
            isLogin: playerAuthState.isLogin,
            fillColor: LightThemeColors.backgroundColor,
            prefixIcon: AppIconData.lock,
          ),
          const SizedBox(height: 30),
          if (!playerAuthState.isLogin) ...signUpField,
          AuthSubmitButton(
            isLoading: playerAuthState.isLoading,
            onSubmit: () => _onSubmit(playerAuthState.isLogin),
            isLogin: playerAuthState.isLogin,
          ),
          const SizedBox(height: 15),
          AuthenticationToggle(
            isLogin: playerAuthState.isLogin,
            toggleAuth: _togglePlayerAuth,
          ),
        ],
      ),
    );
  }
}
