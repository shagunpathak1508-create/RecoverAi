import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../widgets/section_card.dart';
import '../mock_data.dart';
import '../widgets/reminder_widgets.dart';

// Using a hardcoded patient (p1) for this hackathon prototype
const String kDemoPatientId = 'p1';

class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
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
        title: const Text('Caregiver Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // ── Patient Selector (Simulator Placeholder) ─────────────────
          _buildSelector(),
          const SizedBox(height: 16),

          // ── Caregiver Banner ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kAccent, Color(0xFF26A69A)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 36),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, Caregiver', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Monitoring Patient Recovery", style: TextStyle(fontSize: 15, color: Color(0xFFB2DFDB))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Send Reminder ─────────────────────────────────────────
          ReminderButton(patientId: _selectedPatientId),
          const SizedBox(height: 16),

          // ── 1. Adherence & 2. Missed Tasks ───────────────────────────
          _AdherenceAndTasksWidget(patientId: _selectedPatientId),

          // ── 3. Weekly Symptom Graph ──────────────────────────────────
          _GraphWidget(patientId: _selectedPatientId),

          // ── 4. Backup Contact ────────────────────────────────────────
          _BackupContactWidget(patientId: _selectedPatientId),
        ],
      ),
    );
  }

  Widget _buildSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: kAccent.withOpacity(0.3))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPatientId,
          isExpanded: true,
          icon: const Icon(Icons.swap_horiz_rounded, color: kAccent),
          style: const TextStyle(fontSize: 18, color: kAccent, fontWeight: FontWeight.bold),
          items: const [
            DropdownMenuItem(value: 'p1', child: Text('Simulate: John Smith (Knee)')),
            DropdownMenuItem(value: 'p2', child: Text('Simulate: Alice Johnson (Fever)')),
            DropdownMenuItem(value: 'p3', child: Text('Simulate: Robert Davis (Heart)')),
          ],
          onChanged: _onPatientChanged,
        ),
      ),
    );
  }
}

// ── 1 & 2: Adherence & Missed Tasks using Mock Data
class _AdherenceAndTasksWidget extends StatelessWidget {
  final String patientId;
  const _AdherenceAndTasksWidget({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final tasks = MockData.getTasksByPatient(patientId);
    int totalTasks = tasks.length;
    
    List<String> missedTasks = [];
    int completedTasks = 0;

    for (var data in tasks) {
      if (data['status'] == 'completed') {
        completedTasks++;
      } else if (data['status'] == 'missed') {
        missedTasks.add(data['task_name'] ?? 'Unknown Task');
      }
    }

    // Calculate Adherence Percentage
    double adherence = totalTasks == 0 ? 0 : (completedTasks / totalTasks) * 100;
    
    // 3. Visual Color Indicator
    Color adherenceColor = kError; // Red (< 60%)
    if (adherence > 80) {
      adherenceColor = kSuccess; // Green
    } else if (adherence >= 60) {
      adherenceColor = kWarning; // Orange
    }

    return SectionCard(
      title: 'Daily Care Plan',
      icon: Icons.checklist_rounded,
      iconColor: adherenceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adherence Display
          Row(
            children: [
              SizedBox(
                width: 70, height: 70,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: totalTasks == 0 ? 0 : (completedTasks / totalTasks),
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(adherenceColor),
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Text(
                        '${adherence.toInt()}%',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: adherenceColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Adherence: ${adherence.toInt()}%',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: adherenceColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Missed Tasks List
          const Text('Missed Tasks:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (missedTasks.isEmpty)
            const Text('No missed tasks! Keep it up.', style: TextStyle(color: kSuccess, fontSize: 16))
          else
            ...missedTasks.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.close_rounded, color: kError, size: 22),
                  const SizedBox(width: 8),
                  Text(t, style: const TextStyle(fontSize: 17)),
                ],
              ),
            )),

          // Patient Needs Attention Alert
          if (missedTasks.length > 2) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kError),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: kError, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '⚠️ Patient needs attention', 
                      style: TextStyle(color: kError, fontWeight: FontWeight.bold, fontSize: 17)
                    ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

// ── 3: Weekly Symptom Line Graph using Mock Data
class _GraphWidget extends StatelessWidget {
  final String patientId;
  const _GraphWidget({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final docs = MockData.getSymptomsByPatient(patientId);
    List<FlSpot> spots = [];
    
    int xIndex = 0;
    for (var data in docs) {
      final severityMap = data['severity_map'] as Map<String, dynamic>?;
      
      double avgSeverity = 0;
      if (severityMap != null && severityMap.isNotEmpty) {
        double sum = 0;
        severityMap.forEach((key, value) {
          sum += (value as num).toDouble();
        });
        avgSeverity = sum / severityMap.length;
      }
      
      spots.add(FlSpot(xIndex.toDouble(), avgSeverity));
      xIndex++;
    }

    if (spots.isEmpty) {
      return const SectionCard(
        title: 'Weekly Symptom Trend',
        icon: Icons.trending_up_rounded,
        child: Text('No symptom data available yet.', style: TextStyle(fontSize: 16)),
      );
    }

    return SectionCard(
      title: 'Weekly Symptom Trend (Last 7 Days)',
      icon: Icons.show_chart_rounded,
      iconColor: const Color(0xFF283593),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Average severity tracked over timeline (Scale 0-10).', style: TextStyle(color: kTextSecondary, fontSize: 15)),
          const SizedBox(height: 30),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 10,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Day ${value.toInt() + 1}', style: const TextStyle(fontSize: 12, color: kTextSecondary, fontWeight: FontWeight.bold)),
                      ),
                      interval: 1,
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF283593),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF283593).withOpacity(0.15),
                    ),
                    dotData: const FlDotData(show: true),
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

// ── 4: Backup Contact & Inactivity Alert using Mock Data
class _BackupContactWidget extends StatelessWidget {
  final String patientId;
  const _BackupContactWidget({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final data = MockData.getPatient(patientId);
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    final backupContact = data['backup_contact'] ?? 'Not provided';
    final lastUpdatedStr = data['last_updated']; 
    
    bool isInactive = false;
    
    if (lastUpdatedStr != null) {
      try {
        final lastUpdated = DateTime.parse(lastUpdatedStr);
        final difference = DateTime.now().difference(lastUpdated);
        if (difference.inDays >= 2) {
          isInactive = true;
        }
      } catch(e) {
         // Silently handle invalid dates
      }
    }

    return SectionCard(
      title: 'Emergency Contact',
      icon: Icons.contact_emergency_rounded,
      iconColor: Colors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_rounded, color: kTextSecondary, size: 24),
              const SizedBox(width: 12),
              Text('Backup: $backupContact', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          
          if (isInactive)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kError),
              ),
              child: const Row(
                children: [
                  Icon(Icons.timer_off_rounded, color: kError, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '⚠️ Patient inactive for 2+ days. Contact backup right away.',
                      style: TextStyle(color: kError, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
            )
          else
            const Text('Patient app connection is active.', style: TextStyle(color: kSuccess, fontSize: 16)),
        ],
      ),
    );
  }
}
