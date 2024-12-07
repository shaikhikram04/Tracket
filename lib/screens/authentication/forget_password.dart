import 'package:flutter/material.dart';
import 'package:tracket/widgets/my_text_button.dart';
import 'package:tracket/widgets/my_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
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
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MyTextButton(
                            text: 'Send reset email',
                            onPressed: () {},
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
