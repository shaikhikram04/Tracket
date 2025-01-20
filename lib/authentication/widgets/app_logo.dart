import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});
  static const double _maxLogoHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Image.asset(
        'assets/images/Tracket_logo.png',
        height: height * 0.25 > _maxLogoHeight ? _maxLogoHeight : height * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 100),
      ),
    );
  }
}
