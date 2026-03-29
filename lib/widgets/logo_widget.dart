import 'package:flutter/material.dart';

/// Reusable logo widget that displays the RecoverAI custom logo.
/// Use [size] to control the width & height of the logo image.
class LogoWidget extends StatelessWidget {
  final double size;

  const LogoWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      // Graceful fallback if image fails to load
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.local_hospital_rounded,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}
