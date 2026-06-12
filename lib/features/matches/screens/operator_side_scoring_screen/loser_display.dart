import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class LossStatusWidget extends StatelessWidget {
  final String losingTeam;
  final String losingMargin;
  final String animationPath;

  const LossStatusWidget({
    super.key,
    required this.losingTeam,
    required this.losingMargin,
    required this.animationPath,
  });

  @override
  Widget build(BuildContext context) {
    // Define dark theme colors for gradient
    const Color darkBlue = Color(0xFF1A237E);
    const Color darkPurple = Color(0xFF303F9F);

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Animate(
        effects: const [
          FadeEffect(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          ),
        ],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                darkBlue,
                darkPurple,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Losing team name with shake effect
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 200),
                      ),
                      ScaleEffect(
                        begin: Offset(0.8, 0.8),
                        end: Offset(1, 1),
                        duration: Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                      ),
                    ],
                    child: Text(
                      losingTeam,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 400),
                      ),
                    ],
                    child: const Text(
                      "💔",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Losing margin with shake effect
              Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 600),
                  ),
                  ScaleEffect(
                    begin: Offset(0.8, 0.8),
                    end: Offset(1, 1),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    delay: Duration(milliseconds: 200),
                  ),
                ],
                child: Text(
                  losingMargin,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Lottie animation
              Expanded(
                child: Animate(
                  effects: const [
                    FadeEffect(
                      duration: Duration(milliseconds: 1200),
                      delay: Duration(milliseconds: 900),
                    ),
                  ],
                  child: Lottie.asset(
                    animationPath,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
