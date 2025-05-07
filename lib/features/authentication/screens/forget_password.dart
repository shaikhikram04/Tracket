import 'package:flutter/material.dart';
import 'package:tracket/common/screens/safe_area_scrollable_screen.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/common/widgets/text/background_text.dart';
import 'package:tracket/common/widgets/text/title_text.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/authentication/widgets/app_logo.dart';
import 'package:tracket/features/authentication/widgets/back_to_login_button.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_containers.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/validator/validator.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

//* Screen that handles the password reset flow
class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  bool _isResetEmailSent = false;
  bool _isSendingEmail = false;

  //* Validates email format and sends password reset link
  Future<void> _sendResetEmail() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    setState(() => _isSendingEmail = true);
    THelperFunction.showLoadingDialog(context);

    try {
      final result = await FirebaseAuthMethods().resetPassword(_email!);

      if (!mounted) return;

      if (result == TTextStrings.success) {
        setState(() => _isResetEmailSent = true);
      } else {
        THelperFunction.showSuccessSnackBar(result, context);
      }
    } catch (e) {
      if (mounted) {
        THelperFunction.showErrorSnackBar('${TTextStrings.unexpectedError} $e', context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSendingEmail = false);
        Navigator.pop(context); // Dismiss loading dialog
      }
    }
  }

  void _onEditEmail() => setState(() => _isResetEmailSent = false);

  @override
  void dispose() {
    // Ensure form state is properly disposed
    if (_formKey.currentState != null) {
      _formKey.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return SafeAreaScrollableScreen(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: TSizes.defaultSpace,
          children: [
            const AppLogo(),
            TitleText(context).titleText1,
            AppContainers.classicContainer(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: TSizes.verticalSpacingMd,
                children: [
                  BackgroundText(
                    text:
                        _isResetEmailSent ? TTextStrings.resetEmailSentMsg(_email!) : TTextStrings.resetPasswordMessage,
                  ),
                  const SizedBox(height: TSizes.verticalSpacingXl),
                  if (!_isResetEmailSent) ..._buildEmailForm(),
                  _buildActionButtons(isDark),
                ],
              ),
            ),
            const BackToLoginButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmailForm() {
    return [
      MyTextField(
        onSave: (value) => _email = value,
        hintText: TTextStrings.enterEmail,
        prefixIcon: AppIconData.email,
        validator: TValidator.emailValidator,
      ),
      const SizedBox(height: TSizes.verticalSpacingXl)
    ];
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_isResetEmailSent)
          TextButton(
            onPressed: _onEditEmail,
            child: Text(
              TTextStrings.editEmail,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isDark ? lightGrassGreen : grassGreen,
                  ),
            ),
          ),
        const Spacer(),
        CustomButton.primary(
          onPressed: _isSendingEmail ? null : _sendResetEmail,
          text: _isResetEmailSent ? TTextStrings.resendEmail : TTextStrings.resetPassword,
          backgroundColor: isDark ? primaryLight : primaryColor,
          borderRadius: TSizes.borderRadiusLg,
        ),
      ],
    );
  }
}
