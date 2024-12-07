import 'package:flutter/material.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/my_text_button.dart';
import 'package:tracket/widgets/my_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  late bool _isResetEmailSend;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _isResetEmailSend = false;
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final result = await FirebaseAuthMethods.resetPassword(email);
      if (result == 'success') {
        setState(() {
          _isResetEmailSend = true;
        });
      } else {
        if (!mounted) return;
        showSnackBar('Some error occur. Please try again!', context);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/Tracket_logo.png',
                  height: height * 0.25,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                Text(
                  'Forget Password?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Enter the register email. We will send the reset email on provided email.',
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          textController: _emailController,
                          label: 'Email',
                          borderRadius: 15,
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MyTextButton(
                            text: 'Send reset email',
                            onPressed: _sendResetEmail,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back),
                    MyTextButton(
                      text: 'Back to login',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
