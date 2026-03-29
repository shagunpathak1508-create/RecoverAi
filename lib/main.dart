import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/patient_dashboard.dart';
import 'screens/caregiver_dashboard.dart';
import 'screens/doctor_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
