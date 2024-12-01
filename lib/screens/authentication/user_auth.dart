import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/authentication/verification_screen.dart';
import 'package:tracket/screens/home.dart';
import 'package:tracket/widgets/my_text_field.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  var _isLogin = true;
  var _isPasswordHidden = true;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isVerificationSent = false;
  String _verificationMessage = '';
  int _verificationStep = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendVerificationEmail() async {
    try {
      // Validate email and password
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        setState(() {
          _verificationMessage = 'Please enter both email and password';
        });
        return;
      }

      _showVerificationDialog();

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      setState(() {
        _verificationStep = 1;
        _isVerificationSent = true;
        _verificationMessage =
            'Verification email sent! Please check your inbox.';
      });

      // Start listening for email verification
      _checkEmailVerification(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _verificationMessage = e.message ?? 'An error occurred';
      });
    }
  }

  void _checkEmailVerification(User user) {
    // Periodically check if email is verified
    Stream.periodic(const Duration(seconds: 3))
        .asyncMap((_) async {
          await user.reload();
          return user.emailVerified;
        })
        .takeWhile((isVerified) => !isVerified)
        .listen(
          (isVerified) {
            if (isVerified) {
              setState(() {
                _verificationStep = 2;
              });
              Future.delayed(const Duration(milliseconds: 600));
              setState(() {
                _verificationStep = 3;
              });
              Future.delayed(const Duration(milliseconds: 600));
              // Email is verified, proceed to next screen
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          onDone: () {
            // If user doesn't verify within a certain time, remove the user
            if (!user.emailVerified) {
              user.delete();
              setState(() {
                _verificationMessage = 'Verification failed. Please try again.';
                _isVerificationSent = false;
              });
            }
          },
        );
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return VerificationScreen(
          currentStep: _verificationStep,
        );
      },
    );
  }

  Future<void> _userLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final res = await FirebaseAuthMethods.loginUser(
        email: email,
        password: password,
      );

      if (res != 'success') {
        print(res);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Login as User' : 'Signup as user',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            if (!_isLogin)
              MyTextField(
                textController: _usernameController,
                label: 'Username',
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
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLogin ? _userLogin : _sendVerificationEmail,
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
