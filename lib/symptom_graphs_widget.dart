import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/symptom_state.dart';

class SymptomGraphsWidget extends StatelessWidget {
  const SymptomGraphsWidget({super.key, required this.symptomState, required this.symptom});

  final SymptomState symptomState;
  final String symptom;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final symptomRecords = symptomState.symptomRecords;

    // Create a map for daily counts
    Map<int, int> dailyCounts = {};
    for (var record in symptomRecords.where((r) => r.symptom == symptom)) {
      final diffDay = now.difference(DateTime(record.timestamp.year, record.timestamp.month, record.timestamp.day)).inDays;
      dailyCounts.update(diffDay, (value) => value + 1, ifAbsent: () => 1);
    }

    // Create spots for the last 7 days (6 days ago to today), filling with 0 if no data
    List<FlSpot> spots = [];
    for (int day = 6; day >= 0; day--) {
      final count = dailyCounts[day] ?? 0;
      spots.add(FlSpot((6 - day).toDouble(), count.toDouble()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(symptom, style: Theme.of(context).textTheme.headlineSmall),
        Text(
          'Records (last 7 days): ${symptomRecords.where((r) => r.symptom == symptom && now.difference(DateTime(r.timestamp.year, r.timestamp.month, r.timestamp.day)).inDays < 7).length}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text('Total for week: ${spots.map((s) => s.y).reduce((a, b) => a + b).toInt()}', style: Theme.of(context).textTheme.bodySmall),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1,
                lineTouchData: const LineTouchData(enabled: false), // Disable touch interactions and tooltips
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1, // Show a label for every day
                      getTitlesWidget: (value, meta) {
                        final position = value.toInt();
                        if (position < 0 || position > 6) return const Text(''); // Only show labels for valid positions
                        final daysAgo = 6 - position; // Convert position back to days ago
                        if (daysAgo == 0) return const Text('Today');
                        if (daysAgo == 1) return const Text('1d');
                        return Text('${daysAgo}d');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey..withValues(alpha: 0.3))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
