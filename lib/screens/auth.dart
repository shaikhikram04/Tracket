import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/Tracket_logo.png',
                  width: 250,
                  fit: BoxFit.cover,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  color: Theme.of(context).cardColor,
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email'),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Password'),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
