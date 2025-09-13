import 'package:flutter/material.dart';
import 'package:symptom_tracker/main.dart';

class SymptomStatsWidget extends StatelessWidget {
  const SymptomStatsWidget({super.key, required this.symptomState});

  final SymptomState symptomState;

  @override
  Widget build(BuildContext context) {
    // Calculate summary counts
    final now = DateTime.now();

    final symptomRecords = symptomState.symptomRecords;

    List<String> symptoms = symptomRecords.map((r) => r.symptom).toSet().toList();

    List<_SymptomStats> totalCounts = [];

    for (var symptom in symptoms) {
      int today = 0, yesterday = 0, lastWeek = 0, allTime = 0;
      DateTime? lastTimestamp;
      for (var record in symptomRecords.where((r) => r.symptom == symptom)) {
        final diffDay = now.difference(DateTime(record.timestamp.year, record.timestamp.month, record.timestamp.day)).inDays;
        if (diffDay == 0) today++;
        if (diffDay == 1) yesterday++;
        if (diffDay > 7 && diffDay <= 14) lastWeek++;
        allTime++;
        if (lastTimestamp == null || record.timestamp.isAfter(lastTimestamp)) {
          lastTimestamp = record.timestamp;
        }
      }
      String lastOccurrenceString = 'Never';
      if (lastTimestamp != null) {
        final diff = now.difference(lastTimestamp);
        if (diff.inDays >= 1) {
          lastOccurrenceString = '${diff.inDays} days ago and ${diff.inHours % 24} hour${(diff.inHours % 24) > 1 ? 's' : ''} ago';
        } else if (diff.inHours >= 1) {
          lastOccurrenceString =
              '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} and ${diff.inMinutes % 60} minute${(diff.inMinutes % 60) > 1 ? 's' : ''} ago';
        } else if (diff.inMinutes >= 1) {
          lastOccurrenceString = '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
        } else {
          lastOccurrenceString = 'Just now';
        }
      }

      if (allTime == 0) {
        continue;
      }

      totalCounts.add(
        _SymptomStats(
          symptom: symptom,
          allTime: allTime,
          lastTimestamp: lastTimestamp,
          lastOccurrenceString: lastOccurrenceString,
          today: today,
          yesterday: yesterday,
          lastWeek: lastWeek,
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...totalCounts.map(
          (stats) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${stats.symptom}:', style: Theme.of(context).textTheme.bodyLarge),
                if (stats.today > 0) Text('  Today: ${stats.today}', style: Theme.of(context).textTheme.bodySmall),
                if (stats.yesterday > 0) Text('  Yesterday: ${stats.yesterday}', style: Theme.of(context).textTheme.bodySmall),
                if (stats.lastWeek > 0) Text('  Last week: ${stats.lastWeek}', style: Theme.of(context).textTheme.bodySmall),
                if (stats.allTime > 0) Text('  All time: ${stats.allTime}', style: Theme.of(context).textTheme.bodySmall),
                Text('  Last occurrence: ${stats.lastOccurrenceString}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SymptomStats {
  final String symptom;
  final int allTime;
  final DateTime? lastTimestamp;
  final String lastOccurrenceString;
  final int today;
  final int yesterday;
  final int lastWeek;

  _SymptomStats({
    required this.symptom,
    required this.allTime,
    required this.lastTimestamp,
    required this.lastOccurrenceString,
    required this.today,
    required this.yesterday,
    required this.lastWeek,
  });
}
