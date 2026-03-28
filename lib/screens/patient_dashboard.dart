import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/section_card.dart';

// ── Static dummy data ─────────────────────────────────────────────────────────
const _patientName = 'John';
final _medicines = ['Metformin 500mg', 'Lisinopril 10mg', 'Vitamin D3'];
const _exercises = ['15-min Morning Walk'];
const _diet = 'Low-sodium diet. Avoid fried foods. Drink 8 glasses of water.';
final _reminders = [
  _Reminder(time: '8:00 AM', text: 'Morning medicines', icon: Icons.medication_rounded),
  _Reminder(time: '1:00 PM', text: 'Lunch & afternoon walk', icon: Icons.directions_walk_rounded),
  _Reminder(time: '8:00 PM', text: 'Evening medicines', icon: Icons.medication_rounded),
  _Reminder(time: '9:00 PM', text: 'Log symptoms before bed', icon: Icons.edit_note_rounded),
];

class _Reminder {
  final String time, text;
  final IconData icon;
  const _Reminder({required this.time, required this.text, required this.icon});
}

// ═════════════════════════════════════════════════════════════════════════════
class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final List<bool> _medChecks = List.filled(_medicines.length, false);
  bool _exerciseDone = false;
  double _painLevel = 3;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                _patientName[0],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // ── Greeting ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [kPrimary, kPrimaryLight]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, $_patientName 👋',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                const Text("Let's have a great recovery day!",
                    style: TextStyle(fontSize: 16, color: Color(0xFFBBDEFB))),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Medicines ──────────────────────────────────────────────────
          SectionCard(
            title: "Today's Medicines",
            icon: Icons.medication_liquid_rounded,
            child: Column(
              children: List.generate(_medicines.length, (i) {
                return CheckboxListTile(
                  title: Text(_medicines[i],
                      style: const TextStyle(fontSize: 18)),
                  value: _medChecks[i],
                  onChanged: (v) => setState(() => _medChecks[i] = v!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: kAccent,
                );
              }),
            ),
          ),

          // ── Exercise ───────────────────────────────────────────────────
          SectionCard(
            title: "Today's Exercise",
            icon: Icons.directions_run_rounded,
            iconColor: kAccent,
            child: CheckboxListTile(
              title: Text(_exercises[0],
                  style: const TextStyle(fontSize: 18)),
              value: _exerciseDone,
              onChanged: (v) => setState(() => _exerciseDone = v!),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: kAccent,
            ),
          ),

          // ── Diet ───────────────────────────────────────────────────────
          SectionCard(
            title: "Today's Diet",
            icon: Icons.restaurant_rounded,
            iconColor: kWarning,
            child: Text(_diet,
                style: const TextStyle(
                    fontSize: 17, height: 1.5, color: kTextPrimary)),
          ),

          // ── Symptom Logger ─────────────────────────────────────────────
          SectionCard(
            title: 'Symptom Logger',
            icon: Icons.monitor_heart_rounded,
            iconColor: kError,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pain Level',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    const Text('1', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 10,
                        divisions: 9,
                        value: _painLevel,
                        label: _painLevel.toStringAsFixed(0),
                        onChanged: (v) =>
                            setState(() {
                              _painLevel = v;
                              _saved = false;
                            }),
                      ),
                    ),
                    const Text('10', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _painLevelColor(_painLevel).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Level: ${_painLevel.toStringAsFixed(0)} — ${_painLabel(_painLevel)}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _painLevelColor(_painLevel)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _saved ? kSuccess : kPrimary,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(
                        _saved
                            ? Icons.check_circle_outline_rounded
                            : Icons.save_rounded,
                        size: 24),
                    label: Text(
                        _saved ? 'Saved!' : 'Save Symptoms',
                        style: const TextStyle(fontSize: 19)),
                    onPressed: () => setState(() => _saved = true),
                  ),
                ),
              ],
            ),
          ),

          // ── Reminders ──────────────────────────────────────────────────
          SectionCard(
            title: 'Reminders',
            icon: Icons.notifications_active_rounded,
            iconColor: kWarning,
            child: Column(
              children: _reminders
                  .map((r) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kPrimary.withValues(alpha: 0.12),
                          child: Icon(r.icon, color: kPrimary, size: 22),
                        ),
                        title: Text(r.text,
                            style: const TextStyle(fontSize: 17)),
                        trailing: Text(r.time,
                            style: const TextStyle(
                                fontSize: 15,
                                color: kTextSecondary,
                                fontWeight: FontWeight.w500)),
                        contentPadding: EdgeInsets.zero,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Color _painLevelColor(double v) {
    if (v <= 3) return kSuccess;
    if (v <= 6) return kWarning;
    return kError;
  }

  String _painLabel(double v) {
    if (v <= 3) return 'Mild';
    if (v <= 6) return 'Moderate';
    return 'Severe';
  }
}
