import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/authentication/widgets/app_logo.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_containers.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';

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
      _formKey.currentState!.save();

      final result = await FirebaseAuthMethods().resetPassword(_email!);

      if (!mounted) return;

      if (result == 'success') {
        setState(() {
          _isResetEmailSend = true;
        });
      } else {
        THelperFunction.showSnackBar(result, context);
      }
    } catch (e) {
      if (!mounted) return;
      THelperFunction.showSnackBar('An error occurred: $e', context);
    } finally {
      setState(() => _isSendingEmail = false);
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
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: TSizes.verticalSpacingXl),
                    Text(
                      'Forget Password?',
                      style: MyTextStyle(context).headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: grassGreen,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: TSizes.verticalSpacingMd),
                    AppContainers.classicContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: TSizes.verticalSpacingMd,
                        children: [
                          Container(
                            padding: TPadding.sm,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(TSizes.radiusSm),
                            ),
                            child: Text(
                              _isResetEmailSend
                                  ? 'Reset email link has been sent to ${_email!.trim()}. Please check your inbox!'
                                  : 'Enter your registered email address. We\'ll send you a link to reset your password.',
                              style: MyTextStyle(context).cardSubtitle,
                            ),
                          ),
                          const SizedBox(height: TSizes.verticalSpacingXl),
                          if (!_isResetEmailSend) ..._buildEmailForm(),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.verticalSpacingXl),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: grassGreen,
                      ),
                      label: Text(
                        'Back to Login',
                        style: MyTextStyle(context).buttonText.copyWith(
                              color: grassGreen,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isSendingEmail)
            Container(
              color: LightThemeColors.primaryText.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildEmailForm() {
    return [
      MyTextField(
        onSave: (value) => _email = value,
        hintText: 'Enter your email',
        prefixIcon: AppIconData.email,
        borderRadius: TSizes.radiusSm,
        fillColor: LightThemeColors.surfaceColor,
        validator: ValidationServices.emailValidator,
      ),
      const SizedBox(height: TSizes.verticalSpacingXl)
    ];
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_isResetEmailSend)
          TextButton(
            onPressed: _onEditEmail,
            child: Text(
              'Edit email',
              style: MyTextStyle(context).mediumButtonText.copyWith(
                    color: grassGreen,
                  ),
            ),
          ),
        const Spacer(),
        CustomButton.primary(
          onPressed: _isSendingEmail ? null : _sendResetEmail,
          text: _isResetEmailSend ? 'Resend Email' : 'Send Reset Link',
          backgroundColor: primaryColor,
          borderRadius: 12,
        ),
      ],
    );
  }
}
