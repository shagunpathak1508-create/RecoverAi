import 'package:flutter/material.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
const Color kPrimary = Color(0xFF1565C0);      // deep blue
const Color kPrimaryLight = Color(0xFF1E88E5);
const Color kAccent = Color(0xFF00897B);       // teal accent
const Color kBackground = Color(0xFFF4F6FB);
const Color kSurface = Colors.white;
const Color kError = Color(0xFFD32F2F);
const Color kWarning = Color(0xFFF57C00);
const Color kSuccess = Color(0xFF2E7D32);
const Color kTextPrimary = Color(0xFF1A1A2E);
const Color kTextSecondary = Color(0xFF546E7A);

// ── Theme ─────────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      brightness: Brightness.light,
      surface: kBackground,
    ),
    scaffoldBackgroundColor: kBackground,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kTextPrimary),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextPrimary),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: kTextPrimary),
      bodyLarge: TextStyle(fontSize: 18, color: kTextPrimary),
      bodyMedium: TextStyle(fontSize: 16, color: kTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        elevation: 3,
      ),
    ),
    cardTheme: CardThemeData(
      color: kSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? kAccent : Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: kPrimary,
      thumbColor: kPrimary,
      overlayColor: Color(0x291565C0),
      inactiveTrackColor: Color(0xFFBBDEFB),
      trackHeight: 6,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
    ),
  );
}
