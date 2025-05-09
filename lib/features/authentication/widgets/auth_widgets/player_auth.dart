import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/features/authentication/models/player_auth_state.dart';
import 'package:tracket/features/authentication/providers/auth_state_provider.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/auth_form.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/auth_submit_button.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/authentication_toggle.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/validator/validator.dart';

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
        options: THelperFunction.enumToString(CricketRole.values),
        label: TTextStrings.selectCricketRole,
        onSelect: _onSelectRole,
      ),
      const SizedBox(height: TSizes.defaultSpace),
      MyDropdownMenu(
        options: THelperFunction.enumToString(Position.values),
        label: TTextStrings.selectBattingPosition,
        onSelect: _onSelectBattingPosition,
      ),
      const SizedBox(height: TSizes.defaultSpace),
      MyDropdownMenu(
        options: playerAuthState.shouldBall
            ? THelperFunction.enumToString(BowlingStyle.values.sublist(1))
            : THelperFunction.enumToString(BowlingStyle.values),
        label: TTextStrings.selectBowlingStyle,
        onSelect: _onSelectBowlingStyle,
      ),
      const SizedBox(height: TSizes.defaultSpace),
      if (playerAuthState.isBowler)
        MyDropdownMenu(
          options: THelperFunction.enumToString(Position.values),
          label: TTextStrings.selectBowlingArm,
          onSelect: _onSelectBowlingArm,
        ),
      if (playerAuthState.isBowler) const SizedBox(height: TSizes.defaultSpace),
    ];

    return AuthForm(
      formKey: playerAuthState.formKey,
      child: Column(
        children: [
          Text(
            playerAuthState.isLogin ? TTextStrings.loginAsPlayer : TTextStrings.signupAsPlayer,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: TSizes.defaultSpace),
          if (!playerAuthState.isLogin)
            MyTextField(
              onSave: (value) => ref.read(playerAuthProvider.notifier).updateField(playerName: value),
              hintText: TTextStrings.playerName,
              validator: (value) => TValidator.nameValidator(value, TTextStrings.playerName),
              prefixIcon: AppIconData.person,
            ),
          if (!playerAuthState.isLogin) const SizedBox(height: TSizes.defaultSpace),
          MyTextField(
            onSave: (value) => ref.read(playerAuthProvider.notifier).updateField(email: value),
            hintText: TTextStrings.email,
            validator: TValidator.emailValidator,
            prefixIcon: AppIconData.email,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          MyTextField(
            onSave: (value) => ref.read(playerAuthProvider.notifier).updateField(password: value),
            validator: (value) => TValidator.passwordValidator(value, playerAuthState.isLogin),
            hintText: TTextStrings.password,
            isPasswordHidden: playerAuthState.isPasswordHidden,
            changeVisibility: ref.read(playerAuthProvider.notifier).togglePasswordVisibility,
            prefixIcon: AppIconData.lock,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          if (!playerAuthState.isLogin) ...signUpField,
          AuthSubmitButton(
            isLoading: playerAuthState.isLoading,
            onSubmit: () => _onSubmit(playerAuthState.isLogin),
            isLogin: playerAuthState.isLogin,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          AuthenticationToggle(isLogin: playerAuthState.isLogin, toggleAuth: _togglePlayerAuth),
        ],
      ),
    );
  }
}
