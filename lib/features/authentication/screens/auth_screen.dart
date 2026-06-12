import 'dart:async';
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
              const SizedBox(height: 40),
              const AppLogo(),
              const SizedBox(height: 36),
              const _IntroSlides(),
              const Spacer(),
              _AuthActionButton(
                icon: Image.asset(TImages.googleLogo, height: 24),
                label: 'Continue with Google',
                onPressed: _handleGoogleSignIn,
                isLoading: _isGoogleLoading,
              ),
              const SizedBox(height: 16),
              Text(
                'By continuing, you agree to the Fair Play terms.',
                style: textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.45)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const _kSlides = [
  _SlideData(
    icon: Icons.group_add_rounded,
    title: 'Create Your Team',
    subtitle: 'Build a squad and invite your players to join.',
  ),
  _SlideData(
    icon: Icons.sports_cricket_rounded,
    title: 'Challenge Rivals',
    subtitle: 'Send match challenges to any team in the app.',
  ),
  _SlideData(
    icon: Icons.bar_chart_rounded,
    title: 'Track Your Stats',
    subtitle: 'Scores and stats update automatically after every ball.',
  ),
];

class _IntroSlides extends StatefulWidget {
  const _IntroSlides();

  @override
  State<_IntroSlides> createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<_IntroSlides> {
  final _controller = PageController();
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (_current + 1) % _kSlides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _controller,
            itemCount: _kSlides.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              final slide = _kSlides[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: primaryMedium.withValues(alpha: 0.4)),
                      ),
                      child: Icon(slide.icon, color: primaryLight, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      slide.title,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      slide.subtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.55),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _kSlides.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _current == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _current == i
                    ? primaryMedium
                    : Colors.white.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ],
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
