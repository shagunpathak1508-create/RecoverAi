import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../widgets/section_card.dart';
import '../mock_data.dart';

/// AI-based Recovery Visualization widget.
///
/// Shows a line chart comparing ideal vs actual recovery progress,
/// and displays a rule-based AI insight below the graph.
class RecoveryGraphWidget extends StatelessWidget {
  final String patientId;
  const RecoveryGraphWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patientData = MockData.getPatient(patientId);
    if (patientData == null || patientData.isEmpty) {
      return const SizedBox.shrink();
    }

    final int expectedDays =
        (patientData['expected_recovery_days'] as num?)?.toInt() ?? 30;
    final logs = MockData.getRecoveryLogsByPatient(patientId);

    if (logs.isEmpty) {
      return const SectionCard(
        title: 'Recovery Analysis',
        icon: Icons.auto_graph_rounded,
        child: Text('No recovery data available yet.',
            style: TextStyle(fontSize: 16)),
      );
    }

    // ── Actual recovery data points ──────────────────────────────────
    List<FlSpot> actualSpots = logs.map((data) {
      return FlSpot(
        (data['day_number'] as num).toDouble(),
        (data['recovery_score'] as num).toDouble(),
      );
    }).toList();

    // ── Ideal recovery line (linear from 0→100 over expectedDays) ───
    // Also generate intermediate ideal points matching actual day numbers
    List<FlSpot> idealSpots = [
      const FlSpot(0, 0),
      FlSpot(expectedDays.toDouble(), 100),
    ];

    // ── AI Insight Logic (rule-based) ───────────────────────────────
    final latestActual = actualSpots.last;
    final double latestDay = latestActual.x;
    final double latestScore = latestActual.y;

    // Ideal score at the same day
    final double idealScoreAtDay = (latestDay / expectedDays) * 100;

    // Tolerance: ±10% is "on track"
    final double diff = latestScore - idealScoreAtDay;
    String insightEmoji;
    String insightText;
    Color insightColor;

    if (diff < -10) {
      insightEmoji = '⚠️';
      insightText = 'Recovery slower than expected';
      insightColor = kWarning;
    } else if (diff > 10) {
      insightEmoji = '🚀';
      insightText = 'Faster recovery detected!';
      insightColor = kSuccess;
    } else {
      insightEmoji = '✅';
      insightText = 'Recovery on track';
      insightColor = kSuccess;
    }

    return SectionCard(
      title: 'Recovery Analysis',
      icon: Icons.auto_graph_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Row(
            children: [
              _legendDot(kPrimary),
              const SizedBox(width: 6),
              const Text('Actual Progress',
                  style: TextStyle(fontSize: 13, color: kTextSecondary)),
              const SizedBox(width: 16),
              _legendDot(Colors.grey),
              const SizedBox(width: 6),
              const Text('Ideal Timeline',
                  style: TextStyle(fontSize: 13, color: kTextSecondary)),
            ],
          ),
          const SizedBox(height: 24),

          // ── Line Chart ─────────────────────────────────────────────
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: expectedDays.toDouble(),
                minY: 0,
                maxY: 100,
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (expectedDays / 5).ceilToDouble(),
                      getTitlesWidget: (v, m) => Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text('D${v.toInt()}',
                            style: const TextStyle(
                                fontSize: 11, color: kTextSecondary)),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 36,
                      getTitlesWidget: (v, m) => Text('${v.toInt()}%',
                          style: const TextStyle(
                              fontSize: 10, color: kTextSecondary)),
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Actual progress line (solid, blue)
                  LineChartBarData(
                    spots: actualSpots,
                    isCurved: true,
                    color: kPrimary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 5,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: kPrimary,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: kPrimary.withOpacity(0.08),
                    ),
                  ),
                  // Ideal timeline line (dashed, grey)
                  LineChartBarData(
                    spots: idealSpots,
                    isCurved: false,
                    color: Colors.grey,
                    barWidth: 2,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── AI Insight Banner ───────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: insightColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: insightColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Text(insightEmoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI Recovery Insight',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kTextSecondary)),
                      const SizedBox(height: 2),
                      Text(
                        insightText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: insightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.psychology_rounded,
                    color: insightColor.withOpacity(0.6), size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
