import 'package:flutter/material.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/authentication/widgets/app_logo.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

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

  static const double _verticalSpacing = 20.0;
  static const double _borderRadius = 15.0;
  static const EdgeInsets _cardPadding = EdgeInsets.all(20);
  static const EdgeInsets _cardMargin = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 20,
  );

  String get _messageText => _isResetEmailSend
      ? 'Reset email link has been send to ${_email!.trim()}. Check your inbox if you registered!'
      : 'Enter the register email. We will send the reset email on provided email.';

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

      final result = await FirebaseAuthMethods.resetPassword(_email!);

      if (!mounted) return;

      if (result == 'success') {
        setState(() {
          _isResetEmailSend = true;
        });
      } else {
        showSnackBar(result, context);
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar('An error occurred: $e', context);
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
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const AppLogo(),
                    Text(
                      'Forget Password?',
                      style: MyTextStyle(context).titleLarge,
                    ),
                    Card(
                      margin: _cardMargin,
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: _cardPadding,
                        child: Column(
                          spacing: _verticalSpacing,
                          children: [
                            Text(
                              _messageText,
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            if (!_isResetEmailSend) _buildEmailForm(),
                            _buildActionButtons()
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: blackColor,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                        iconSize: 30,
                      ),
                      label: const Text('Back to login'),
                      icon: const Icon(Icons.arrow_back),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isSendingEmail)
          Container(
            color: Colors.black26,
            child: Center(
              child: getCircleLoadingIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return MyTextField(
      isLogin: true,
      onSave: (value) => _email = value,
      label: 'Email',
      borderRadius: _borderRadius,
      validator: emailValidator,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_isResetEmailSend)
          MyTextButton(
            text: 'Edit email',
            onPressed: _onEditEmail,
          ),
        const Spacer(),
        // if (_isSendingEmail)
        //   Padding(
        //     padding: const EdgeInsets.only(right: 8.0),
        //     child: SizedBox.square(
        //       dimension: 20,
        //       child: getCircleLoadingIndicator(strokeWidth: 2),
        //     ),
        //   ),
        MyTextButton(
          text: _isResetEmailSend ? 'Resend' : 'Send reset email',
          onPressed: _isSendingEmail ? null : _sendResetEmail,
        ),
      ],
    );
  }
}
