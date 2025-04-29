import 'package:flutter/material.dart';
import 'package:tracket/common/screens/safe_area_scrollable_screen.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/common/widgets/text/title_text.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/authentication/widgets/app_logo.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
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
  String? _email;
  late GlobalKey<FormState> _formKey;
  late bool _isResetEmailSend;
  late bool _isSendingEmail;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _isResetEmailSend = false;
    _isSendingEmail = false;
  }

  //* Validates email format and sends password reset link
  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isSendingEmail = true);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const CircularLoadingIndicator(
                color: primaryColor,
                strokeWidth: 3.0,
              ));
      _formKey.currentState!.save();

      final result = await FirebaseAuthMethods().resetPassword(_email!);

      if (!mounted) return;

      if (result == TTextStrings.success) {
        setState(() {
          _isResetEmailSend = true;
        });
      } else {
        THelperFunction.showSnackBar(result, context);
      }
    } catch (e) {
      if (!mounted) return;
      THelperFunction.showSnackBar(
          '${TTextStrings.unexpectedError} $e', context);
    } finally {
      setState(() => _isSendingEmail = false);
      Navigator.pop(context);
    }
  }

  void _onEditEmail() {
    setState(() {
      _isResetEmailSend = false;
    });
  }

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
          children: [
            const AppLogo(),
            const SizedBox(height: TSizes.verticalSpacingXl),
            TitleText(context).titleText1,
            const SizedBox(height: TSizes.verticalSpacingMd),
            AppContainers.classicContainer(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: TSizes.verticalSpacingMd,
                children: [
                  Container(
                    padding: TPadding.sm,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(
                        alpha: isDark ? 0.4 : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(
                        TSizes.borderRadiusLg,
                      ),
                    ),
                    child: Text(
                      _isResetEmailSend
                          ? TTextStrings.resetEmailSentMsg(_email!)
                          : TTextStrings.resetPasswordMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: TSizes.verticalSpacingXl),
                  if (!_isResetEmailSend) ..._buildEmailForm(),
                  _buildActionButtons(isDark),
                ],
              ),
            ),
            const SizedBox(height: TSizes.verticalSpacingXl),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? lightGrassGreen : grassGreen,
              ),
              label: Text(
                TTextStrings.backToLogin,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: isDark ? lightGrassGreen : grassGreen,
                    ),
              ),
            ),
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
        if (_isResetEmailSend)
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
          text: _isResetEmailSend
              ? TTextStrings.resendEmail
              : TTextStrings.resetPassword,
          backgroundColor: primaryColor,
          borderRadius: TSizes.borderRadiusLg,
        ),
      ],
    );
  }
}
