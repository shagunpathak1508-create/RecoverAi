import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import 'section_card.dart';

class RelapseRiskWidget extends StatefulWidget {
  final String patientId;
  const RelapseRiskWidget({super.key, required this.patientId});

  @override
  State<RelapseRiskWidget> createState() => _RelapseRiskWidgetState();
}

class _RelapseRiskWidgetState extends State<RelapseRiskWidget> {
  // Method to fetch and calculate the risk based on Firebase data
  Future<Map<String, dynamic>> _fetchRiskData() async {
    final db = FirebaseFirestore.instance;

    // Fetch Symptoms
    final sympSnaps = await db
        .collection('symptoms')
        .where('patient_id', isEqualTo: widget.patientId)
        .get();

    // Fetch Tasks
    final taskSnaps = await db
        .collection('tasks')
        .where('patient_id', isEqualTo: widget.patientId)
        .get();

    // Aggregate Data per Date
    // Date string -> Map
    Map<String, Map<String, dynamic>> dailyData = {};

    for (var doc in sympSnaps.docs) {
      final data = doc.data();
      final String? date = data['date'];
      if (date == null) continue;

      double severitySum = 0;
      int count = 0;
      final severityMap = data['severity_map'] as Map<String, dynamic>?;
      if (severityMap != null && severityMap.isNotEmpty) {
        severityMap.forEach((_, v) {
          severitySum += (v as num).toDouble();
          count++;
        });
      }

      double avgSeverity = count > 0 ? severitySum / count : 0.0;
      dailyData.putIfAbsent(
          date, () => {'severity': 0.0, 'task_total': 0, 'task_completed': 0});
      dailyData[date]!['severity'] = avgSeverity;
    }

    for (var doc in taskSnaps.docs) {
      final data = doc.data();
      final String? date = data['date'];
      final String? status = data['status'];
      if (date == null) continue;

      dailyData.putIfAbsent(
          date, () => {'severity': 0.0, 'task_total': 0, 'task_completed': 0});
      dailyData[date]!['task_total'] =
          (dailyData[date]!['task_total'] as int) + 1;
      if (status == 'completed') {
        dailyData[date]!['task_completed'] =
            (dailyData[date]!['task_completed'] as int) + 1;
      }
    }

    if (dailyData.isEmpty) {
      return {'empty': true};
    }

    // Sort chronologically
    final dates = dailyData.keys.toList()..sort();
    final recentDates =
        dates.length > 7 ? dates.sublist(dates.length - 7) : dates;

    List<double> severities = [];
    List<double> adherences = [];

    for (var d in recentDates) {
      final ds = dailyData[d]!;
      severities.add((ds['severity'] as double));
      int tot = ds['task_total'] as int;
      int comp = ds['task_completed'] as int;
      adherences.add(tot > 0 ? (comp / tot) * 100 : 100.0);
    }

    // Calculate Trends (splitting data into old vs new half)
    int mid = recentDates.length ~/ 2;
    if (mid == 0 && recentDates.isNotEmpty) mid = 1;

    double oldSev = 0, newSev = 0;
    double oldAdh = 0, newAdh = 0;

    if (recentDates.length > 1) {
      oldSev = severities.sublist(0, mid).reduce((a, b) => a + b) / mid;
      newSev = severities.sublist(mid).reduce((a, b) => a + b) /
          (recentDates.length - mid);
      oldAdh = adherences.sublist(0, mid).reduce((a, b) => a + b) / mid;
      newAdh = adherences.sublist(mid).reduce((a, b) => a + b) /
          (recentDates.length - mid);
    } else {
      oldSev = newSev = severities.first;
      oldAdh = newAdh = adherences.first;
    }

    bool severityIncreasing = newSev > oldSev + 0.5; // Slight buffer for noise
    bool adherenceDecreasing = newAdh < oldAdh - 5.0; // 5% drop buffer

    String riskLevel = 'Low Risk';
    Color riskColor = kSuccess;
    IconData riskIcon = Icons.check_circle_rounded;
    String message = 'Patient stable and adherence is strong.';

    if (severityIncreasing && adherenceDecreasing) {
      riskLevel = 'High Risk of Relapse';
      riskColor = kError;
      riskIcon = Icons.warning_rounded;
      message =
          'Symptoms increasing and adherence dropping — intervention required.';
    } else if (severityIncreasing || adherenceDecreasing) {
      riskLevel = 'Moderate Risk';
      riskColor = kWarning;
      riskIcon = Icons.info_rounded;
      if (severityIncreasing) {
        message = 'Symptoms are worsening, monitor closely.';
      } else {
        message = 'Adherence is dropping, follow-up recommended.';
      }
    }

    return {
      'empty': false,
      'riskLevel': riskLevel,
      'riskColor': riskColor,
      'riskIcon': riskIcon,
      'message': message,
      'dates': recentDates,
      'severities': severities,
      'adherences': adherences,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Risk of Relapse Analysis',
      icon: Icons.analytics_rounded,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _fetchRiskData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Error loading relapse analysis.',
                style: TextStyle(color: kError),
              ),
            );
          }

          final data = snapshot.data ?? {};
          if (data['empty'] == true) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Not enough data to analyze relapse risk.',
                style: TextStyle(color: kTextSecondary),
              ),
            );
          }

          final Color riskColor = data['riskColor'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Risk Indicator Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: riskColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(data['riskIcon'], color: riskColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['riskLevel'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: riskColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['message'],
                            style: const TextStyle(
                                fontSize: 14, color: kTextPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Chart Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendItem(const Color(0xFFE53935), 'Symptom Severity'),
                  const SizedBox(width: 20),
                  _legendItem(const Color(0xFF1E88E5), 'Task Adherence %'),
                ],
              ),
              const SizedBox(height: 16),

              // The Trend Graph
              SizedBox(
                height: 160,
                child: _buildRiskChart(
                  data['severities'],
                  data['adherences'],
                  data['dates'],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: kTextSecondary)),
      ],
    );
  }

  Widget _buildRiskChart(
      List<double> severities, List<double> adherences, List<String> dates) {
    final severitySpots = List.generate(
      severities.length,
      (i) => FlSpot(i.toDouble(),
          severities[i] * 10), // Scale 0-10 severity to 0-100 chart
    );

    final adherenceSpots = List.generate(
      adherences.length,
      (i) => FlSpot(i.toDouble(), adherences[i]),
    );

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        minX: 0,
        maxX: (severities.length - 1).toDouble() > 0
            ? (severities.length - 1).toDouble()
            : 1,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  // Show last 3 chars of date (e.g. "22" or "03-22" mapped roughly)
                  final split = dates[index].split('-');
                  String disp =
                      split.length >= 3 ? "${split[1]}/${split[2]}" : dates[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(disp,
                        style: const TextStyle(
                            fontSize: 10, color: kTextSecondary)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}',
                    style: const TextStyle(fontSize: 10, color: kTextSecondary));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: severitySpots,
            isCurved: true,
            color: const Color(0xFFE53935),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: adherenceSpots,
            isCurved: true,
            color: const Color(0xFF1E88E5),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
