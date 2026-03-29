import 'package:flutter/material.dart';
import '../theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo / Icon ───────────────────────────────────────────
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      size: 64, color: Colors.white),
                ),
                const SizedBox(height: 24),

                // ── Title ─────────────────────────────────────────────────
                const Text(
                  'RecoverAI',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Recovery Companion',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFBBDEFB),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),

                // ── Login Buttons ─────────────────────────────────────────
                _LoginButton(
                  label: 'Login as Patient',
                  icon: Icons.person_rounded,
                  color: Colors.white,
                  textColor: kPrimary,
                  route: '/patient',
                ),
                const SizedBox(height: 16),
                _LoginButton(
                  label: 'Login as Caregiver',
                  icon: Icons.volunteer_activism_rounded,
                  color: kAccent,
                  textColor: Colors.white,
                  route: '/caregiver',
                ),
                const SizedBox(height: 16),
                _LoginButton(
                  label: 'Login as Doctor',
                  icon: Icons.medical_services_rounded,
                  color: const Color(0xFF283593),
                  textColor: Colors.white,
                  route: '/doctor',
                ),
                const SizedBox(height: 36),

                // ── Footer ────────────────────────────────────────────────
                const Text(
                  'No login required — tap your role to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF90CAF9), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final String route;

  const _LoginButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 4,
        ),
        icon: Icon(icon, size: 28),
        label: Text(label,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        onPressed: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
