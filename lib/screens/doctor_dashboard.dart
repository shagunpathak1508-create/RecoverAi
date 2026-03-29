import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import '../widgets/section_card.dart';
import '../widgets/logo_widget.dart';
import '../widgets/recovery_graph_widget.dart';
import '../widgets/relapse_risk_widget.dart';
import '../widgets/calendar_widget.dart';
import '../mock_data.dart';
import 'live_patients_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String _selectedPatientId = 'p1';

  void _onPatientChanged(String? patientId) {
    if (patientId == null) return;
    setState(() {
      _selectedPatientId = patientId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoWidget(size: 32),
            const SizedBox(width: 10),
            const Text('Doctor Dashboard'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // ── Patient Selector (Prototype Simulator) ────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kPrimary.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPatientId,
                isExpanded: true,
                icon: const Icon(Icons.swap_horiz_rounded, color: kPrimary),
                style: const TextStyle(fontSize: 18, color: kPrimary, fontWeight: FontWeight.bold),
                items: const [
                  DropdownMenuItem(value: 'p1', child: Text('John (Knee Recovery)')),
                  DropdownMenuItem(value: 'p2', child: Text('Alice (Fever)')),
                  DropdownMenuItem(value: 'p3', child: Text('Robert (Heart)')),
                ],
                onChanged: _onPatientChanged,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Doctor Banner ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF283593), Color(0xFF3949AB)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.medical_services_rounded, color: Colors.white, size: 36),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr. Sharma', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Orthopedic Specialist', style: TextStyle(fontSize: 15, color: Color(0xFFC5CAE9))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Patient Summary Card (Mock) ─────────────────────────────
          _PatientSummaryMock(patientId: _selectedPatientId),

          // ── Recovery Analysis Graph (AI-Based — Actual vs Ideal) ─────
          RecoveryGraphWidget(patientId: _selectedPatientId),

          // ── Risk of Relapse Analysis ──────────────────────────────────
          RelapseRiskWidget(patientId: _selectedPatientId),

          // ── Critical Alerts (Tasks & Symptoms Mock) ───────────────
          _AlertsMock(patientId: _selectedPatientId),

          // ── Follow-Up Calendar ────────────────────────────────────────
          const CalendarWidget(),

          const SizedBox(height: 12),

          // ── Live Patients Navigator ──────────────────────────────────
          SizedBox(
            height: 62,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryLight,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.cloud_sync_rounded, size: 26),
              label: const Text('All Patients Data', style: TextStyle(fontSize: 20)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LivePatientsScreen())),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      // ── Firestore Test FAB ──────────────────────────────────────────
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Upload Dummy Data button
          FloatingActionButton.small(
            heroTag: 'upload_dummy',
            backgroundColor: kAccent,
            onPressed: () => _uploadDummyData(context),
            tooltip: 'Upload Dummy Data to Firestore',
            child: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
          ),
          const SizedBox(height: 10),
          // Test Firestore Write button
          FloatingActionButton(
            heroTag: 'test_firestore',
            backgroundColor: const Color(0xFF283593),
            onPressed: () => _testFirestoreWrite(context),
            tooltip: 'Test Firestore Connection',
            child: const Icon(Icons.science_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ── Firestore Test Write ───────────────────────────────────────────
  Future<void> _testFirestoreWrite(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('test').add({
        'msg': 'hello from RecoverAI',
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'doctor_dashboard',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Firestore write successful!'),
            backgroundColor: kSuccess,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Firestore write error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Firestore error: $e'),
            backgroundColor: kError,
          ),
        );
      }
    }
  }

  // ── Upload All Mock Data to Firestore ───────────────────────────────
  Future<void> _uploadDummyData(BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Upload patients
      for (var patient in MockData.patients) {
        await firestore
            .collection('patients')
            .doc(patient['patient_id'])
            .set(patient);
      }

      // Upload tasks
      for (var task in MockData.tasks) {
        await firestore
            .collection('tasks')
            .doc(task['task_id'])
            .set(task);
      }

      // Upload symptoms
      for (int i = 0; i < MockData.symptoms.length; i++) {
        await firestore
            .collection('symptoms')
            .doc('s$i')
            .set(MockData.symptoms[i]);
      }

      // Upload recovery logs
      for (int i = 0; i < MockData.recoveryLogs.length; i++) {
        await firestore
            .collection('recovery_logs')
            .doc('r$i')
            .set(MockData.recoveryLogs[i]);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ All dummy data uploaded to Firestore!'),
            backgroundColor: kSuccess,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Dummy data upload error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Upload error: $e'),
            backgroundColor: kError,
          ),
        );
      }
    }
  }
}

// ── 1: Patient Summary Sub-Widget (Mock)
class _PatientSummaryMock extends StatelessWidget {
  final String patientId;
  const _PatientSummaryMock({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final data = MockData.getPatient(patientId);
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    return SectionCard(
      title: 'Patient Summary',
      icon: Icons.person_search_rounded,
      child: Column(
        children: [
          _infoRow(Icons.person_rounded, 'Full Name', data['name'] ?? 'Unknown'),
          const Divider(height: 20),
          _infoRow(Icons.healing_rounded, 'Diagnosis / Condition', data['condition']?.replaceAll('_', ' ').toUpperCase() ?? 'None'),
          const Divider(height: 20),
          _infoRow(Icons.history_rounded, 'Start Date', data['start_date'] ?? 'N/A'),
          const Divider(height: 20),
          _infoRow(Icons.repeat_rounded, 'Exp. Recovery', '${data['expected_recovery_days']} Days', valueColor: kAccent),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: kPrimary),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
            Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: valueColor ?? kTextPrimary)),
          ],
        )),
      ],
    );
  }
}

// ── 3: Alerts Mock Integration
class _AlertsMock extends StatelessWidget {
  final String patientId;
  const _AlertsMock({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final symps = MockData.getSymptomsByPatient(patientId);
    final tasks = MockData.getTasksByPatient(patientId);

    // Symptoms Alert (Latest)
    final latestSymptom = symps.isNotEmpty ? symps.last : null;
    bool highSeverity = false;
    if (latestSymptom != null) {
      final severityMap = latestSymptom['severity_map'] as Map<String, dynamic>? ?? {};
      severityMap.forEach((k, v) { if ((v as num) >= 8) highSeverity = true; });
    }

    // Task Adherence Alert
    final missedCount = tasks.where((t) => t['status'] == 'missed').length;

    return Column(
      children: [
        if (highSeverity)
          _alertBanner('High severity symptoms reported. Immediate review recommended.', kError, Icons.warning_rounded),
        if (missedCount >= 2)
          _alertBanner('Patient has missed $missedCount critical tasks this week.', kWarning, Icons.report_problem_rounded),
      ],
    );
  }

  Widget _alertBanner(String text, Color color, IconData icon) {
    return SectionCard(
      title: 'Action Required', icon: icon, iconColor: color,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
