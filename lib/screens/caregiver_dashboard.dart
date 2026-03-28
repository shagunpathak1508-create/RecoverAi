import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/section_card.dart';

// ── Static dummy data ─────────────────────────────────────────────────────────
const _patientName = 'John Smith';
const _diagnosis = 'Post-knee replacement recovery';
const _adherence = 0.70;
const _recoveryProgress = 0.62;

final _alerts = [
  _Alert(
      message: 'Missed Metformin 500mg at 8:00 AM',
      type: _AlertType.warning,
      icon: Icons.medication_rounded),
  _Alert(
      message: 'High pain level reported: 8/10',
      type: _AlertType.danger,
      icon: Icons.warning_amber_rounded),
  _Alert(
      message: 'Skipped Morning Walk (3rd time this week)',
      type: _AlertType.warning,
      icon: Icons.directions_walk_rounded),
];

enum _AlertType { warning, danger }

class _Alert {
  final String message;
  final _AlertType type;
  final IconData icon;
  const _Alert(
      {required this.message, required this.type, required this.icon});
}

// ═════════════════════════════════════════════════════════════════════════════
class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  bool _reminderSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // ── Caregiver Greeting Banner ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [kAccent, Color(0xFF26A69A)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.volunteer_activism_rounded,
                    color: Colors.white, size: 36),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, Caregiver',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("Managing John's recovery today",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFB2DFDB))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Patient Overview ───────────────────────────────────────────
          SectionCard(
            title: 'Patient Overview',
            icon: Icons.person_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: kPrimary.withValues(alpha: 0.12),
                      child: const Text('JS',
                          style: TextStyle(
                              color: kPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(_patientName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text(_diagnosis,
                            style: TextStyle(
                                fontSize: 15, color: kTextSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text('Recovery Progress',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _recoveryProgress,
                    minHeight: 18,
                    backgroundColor: const Color(0xFFBBDEFB),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(kPrimaryLight),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(_recoveryProgress * 100).toInt()}% Complete',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimary),
                ),
              ],
            ),
          ),

          // ── Adherence ─────────────────────────────────────────────────
          SectionCard(
            title: 'Adherence Rate',
            icon: Icons.bar_chart_rounded,
            iconColor: kAccent,
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: _adherence,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(kAccent),
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Text(
                          '${(_adherence * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'John followed 70% of his care plan this week. Improvement needed.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          // ── Alerts ────────────────────────────────────────────────────
          SectionCard(
            title: 'Active Alerts',
            icon: Icons.notifications_active_rounded,
            iconColor: kError,
            child: Column(
              children: _alerts.map((a) {
                final isWarning = a.type == _AlertType.warning;
                final color = isWarning ? kWarning : kError;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(a.icon, color: color, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(a.message,
                            style: TextStyle(
                                fontSize: 16,
                                color: color,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Send Reminder Button ───────────────────────────────────────
          const SizedBox(height: 4),
          SizedBox(
            height: 62,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _reminderSent ? kSuccess : kAccent,
                foregroundColor: Colors.white,
              ),
              icon: Icon(
                  _reminderSent
                      ? Icons.check_circle_outline_rounded
                      : Icons.send_rounded,
                  size: 26),
              label: Text(
                  _reminderSent
                      ? 'Reminder Sent!'
                      : 'Send Reminder to John',
                  style: const TextStyle(fontSize: 20)),
              onPressed: () => setState(() => _reminderSent = true),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
