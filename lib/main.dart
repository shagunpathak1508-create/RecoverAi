import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/patient_dashboard.dart';
import 'screens/caregiver_dashboard.dart';
import 'screens/doctor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize Firebase ─────────────────────────────────────────────
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully!');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }

  runApp(const RecoverAIApp());
}

class RecoverAIApp extends StatelessWidget {
  const RecoverAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecoverAI',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/patient': (context) => const PatientDashboard(),
        '/caregiver': (context) => const CaregiverDashboard(),
        '/doctor': (context) => const DoctorDashboard(),
      },
    );
  }
}
