import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../widgets/section_card.dart';
import '../mock_data.dart';
import 'live_patients_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String _selectedPatientId = 'p1';
  bool _followupSent = false;

  void _onPatientChanged(String? patientId) {
    if (patientId == null) return;
    setState(() {
      _selectedPatientId = patientId;
      _followupSent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
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

          // ── Recovery Trend Graph (Actual vs Expected) ────────────────
          _RecoveryTrendMock(patientId: _selectedPatientId),

          // ── Critical Alerts (Tasks & Symptoms Mock) ───────────────
          _AlertsMock(patientId: _selectedPatientId),

          // ── Follow-Up Action ─────────────────────────────────────────
          const SizedBox(height: 4),
          SizedBox(
            height: 62,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _followupSent ? kSuccess : const Color(0xFF283593),
                foregroundColor: Colors.white,
              ),
              icon: Icon(_followupSent ? Icons.check_circle_outline_rounded : Icons.calendar_today_rounded, size: 26),
              label: Text(_followupSent ? 'Follow-up Suggested!' : 'Suggest Follow-up', style: const TextStyle(fontSize: 20)),
              onPressed: () => setState(() => _followupSent = true),
            ),
          ),
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
    );
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

// ── 2: Expected vs Actual Recovery Timeline (Mock Graph)
class _RecoveryTrendMock extends StatelessWidget {
  final String patientId;
  const _RecoveryTrendMock({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patientData = MockData.getPatient(patientId);
    if (patientData == null || patientData.isEmpty) return const SizedBox.shrink();

    final int expectedDays = (patientData['expected_recovery_days'] as num?)?.toInt() ?? 30;
    final logs = MockData.getRecoveryLogsByPatient(patientId);

    List<FlSpot> actualSpots = logs.map((data) {
      return FlSpot((data['day_number'] as num).toDouble(), (data['recovery_score'] as num).toDouble());
    }).toList();

    // Expected Trace: Linear line from (0,0) to (expectedDays, 100)
    List<FlSpot> expectedSpots = [
      const FlSpot(0, 0),
      FlSpot(expectedDays.toDouble(), 100),
    ];

    return SectionCard(
      title: 'Recovery Timeline (Actual vs Exp.)',
      icon: Icons.auto_graph_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Solid: Actual Progress  •  Dashed: Expected Path', style: TextStyle(fontSize: 13, color: kTextSecondary)),
          const SizedBox(height: 30),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: 0, maxX: expectedDays.toDouble(),
                minY: 0, maxY: 100,
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 10, getTitlesWidget: (v, m) => Text('D${v.toInt()}', style: const TextStyle(fontSize: 10)))),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 25, getTitlesWidget: (v, m) => Text('${v.toInt()}%', style: const TextStyle(fontSize: 10)))),
                ),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: actualSpots, isCurved: true, color: kPrimary, barWidth: 4, 
                    belowBarData: BarAreaData(show: true, color: kPrimary.withOpacity(0.1)),
                  ),
                  LineChartBarData(
                    spots: expectedSpots, isCurved: false, color: Colors.grey, barWidth: 2, dashArray: [5, 5], dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
