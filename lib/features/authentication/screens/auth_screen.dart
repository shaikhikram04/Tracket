import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/authentication/widgets/app_logo.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/image_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isGoogleLoading = false;

  void _authUiLog(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'TracketAuth.UI',
      error: error,
      stackTrace: stackTrace,
    );
    debugPrint('[TracketAuth.UI] $message');
    if (error != null) {
      debugPrint('[TracketAuth.UI][error] $error');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading) return;

    _authUiLog('Google sign-in button tapped');
    setState(() => _isGoogleLoading = true);
    try {
      final credential = await FirebaseAuthMethods().signInWithGoogle();
      _authUiLog(
        'Google sign-in call completed; hasCredential=${credential != null}',
      );
    } on PlatformException catch (error, stackTrace) {
      _authUiLog(
        'PlatformException from Google sign-in; code=${error.code}; message=${error.message}; details=${error.details}',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      THelperFunction.showErrorSnackBar(error.toString(), context);
    } catch (error, stackTrace) {
      _authUiLog(
        'Unhandled exception in Google sign-in handler',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      THelperFunction.showErrorSnackBar(error.toString(), context);
    } finally {
      if (mounted) {
        _authUiLog('Google sign-in handler finished; loading reset');
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF081512),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const AppLogo(),
              const SizedBox(height: 12),
              Text(
                'Your game, quantified.',
                style: textTheme.headlineMedium
                    ?.copyWith(color: DarkThemeColors.secondaryText),
              ),
              const Spacer(flex: 2),
              _AuthActionButton(
                icon: Image.asset(TImages.googleLogo, height: 24),
                label: 'Continue with Google',
                onPressed: _handleGoogleSignIn,
                isLoading: _isGoogleLoading,
              ),
              const SizedBox(height: 72),
              Text(
                'By continuing, you agree to the Fair Play terms.',
                style: textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.45)),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthActionButton extends StatelessWidget {
  const _AuthActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
