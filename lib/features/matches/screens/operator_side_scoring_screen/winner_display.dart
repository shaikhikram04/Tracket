import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class WinningStatusWidget extends StatelessWidget {
  final String winningTeam;
  final String winningMargin;
  final String animationPath;

  const WinningStatusWidget({
    super.key,
    required this.winningTeam,
    required this.winningMargin,
    required this.animationPath,
  });

  @override
  Widget build(BuildContext context) {
    // Define green theme colors
    const Color primaryGreen = Color(0xFF2E7D32);
    const Color lightGreen = Color(0xFF4CAF50);

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
                primaryGreen,
                lightGreen,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Winning team name with bounce effect

              const SizedBox(height: 12),
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
                  winningTeam,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Winning margin with bounce effect
              Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 400),
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
                  winningMargin,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

              // Lottie animation
              Flexible(
                child: Animate(
                  effects: const [
                    FadeEffect(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 600),
                    ),
                    ScaleEffect(
                      begin: Offset(0.5, 0.5),
                      end: Offset(1, 1),
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      delay: Duration(milliseconds: 600),
                    ),
                  ],
                  child: Lottie.asset(
                    animationPath,
                    fit: BoxFit.contain,
                    repeat: false,
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
