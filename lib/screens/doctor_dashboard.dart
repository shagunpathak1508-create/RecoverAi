import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/section_card.dart';

// ── Static dummy data ─────────────────────────────────────────────────────────
const _patientName = 'John Smith';
const _diagnosis = 'Post-knee replacement recovery';
const _recoveryStatus = 'Moderate — On Track';
const _lastVisit = '15 Mar 2026';
const _nextVisit = '01 Apr 2026';

final _criticalAlerts = [
  _CriticalAlert(
      text: 'Pain level 8/10 logged on 25 Mar — Monitoring recommended',
      icon: Icons.warning_rounded,
      color: kError),
  _CriticalAlert(
      text: 'Missed 3 consecutive exercise sessions this week',
      icon: Icons.fitness_center_rounded,
      color: kWarning),
];

class _CriticalAlert {
  final String text;
  final IconData icon;
  final Color color;
  const _CriticalAlert(
      {required this.text, required this.icon, required this.color});
}

// ── Trend chart data (weekly pain levels) ─────────────────────────────────────
const _trendData = [7.0, 6.5, 8.0, 6.0, 5.5, 5.0, 4.5]; // Mon–Sun
const _trendDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

// ═════════════════════════════════════════════════════════════════════════════
class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  bool _followupSent = false;

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
          // ── Doctor Banner ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF283593), Color(0xFF3949AB)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.medical_services_rounded,
                    color: Colors.white, size: 36),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr. Sharma',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text('Orthopedic Specialist',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFC5CAE9))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Patient Summary ────────────────────────────────────────────
          SectionCard(
            title: 'Patient Summary',
            icon: Icons.summarize_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.person_rounded, 'Patient', _patientName),
                const Divider(height: 20),
                _infoRow(
                    Icons.healing_rounded, 'Diagnosis', _diagnosis),
                const Divider(height: 20),
                _infoRow(Icons.trending_up_rounded, 'Recovery Status',
                    _recoveryStatus,
                    valueColor: kAccent),
                const Divider(height: 20),
                _infoRow(Icons.event_rounded, 'Last Visit', _lastVisit),
                const Divider(height: 20),
                _infoRow(
                    Icons.event_available_rounded, 'Next Visit', _nextVisit),
              ],
            ),
          ),

          // ── Recovery Trend ────────────────────────────────────────────
          SectionCard(
            title: 'Recovery Trend — Pain (This Week)',
            icon: Icons.show_chart_rounded,
            iconColor: kPrimaryLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lower is better  •  Scale 1–10',
                    style: TextStyle(fontSize: 14, color: kTextSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 130,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_trendData.length, (i) {
                      final h = (_trendData[i] / 10.0) * 110;
                      final isHigh = _trendData[i] >= 7;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _trendData[i].toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isHigh ? kError : kAccent),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            width: 32,
                            height: h,
                            decoration: BoxDecoration(
                              color: isHigh
                                  ? kError.withValues(alpha: 0.75)
                                  : kPrimaryLight.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(_trendDays[i],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kTextSecondary)),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: kAccent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    children: [
                      Icon(Icons.trending_down_rounded,
                          color: kSuccess, size: 22),
                      SizedBox(width: 8),
                      Text('Pain showing a downward trend — Good progress!',
                          style: TextStyle(
                              fontSize: 15,
                              color: kSuccess,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Critical Alerts ────────────────────────────────────────────
          SectionCard(
            title: 'Critical Alerts',
            icon: Icons.report_problem_rounded,
            iconColor: kError,
            child: Column(
              children: _criticalAlerts.map((a) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: a.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: a.color.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(a.icon, color: a.color, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(a.text,
                            style: TextStyle(
                                fontSize: 15,
                                color: a.color,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Suggest Follow-Up Button ───────────────────────────────────
          const SizedBox(height: 4),
          SizedBox(
            height: 62,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _followupSent
                    ? kSuccess
                    : const Color(0xFF283593),
                foregroundColor: Colors.white,
              ),
              icon: Icon(
                  _followupSent
                      ? Icons.check_circle_outline_rounded
                      : Icons.calendar_today_rounded,
                  size: 26),
              label: Text(
                  _followupSent
                      ? 'Follow-up Suggested!'
                      : 'Suggest Follow-up',
                  style: const TextStyle(fontSize: 20)),
              onPressed: () => setState(() => _followupSent = true),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: kPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14, color: kTextSecondary)),
              Text(value,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? kTextPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}
