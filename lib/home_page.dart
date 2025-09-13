import 'package:flutter/material.dart';
import 'package:symptom_tracker/main.dart';
import 'package:symptom_tracker/symptom_record.dart';
import 'package:symptom_tracker/symptom_stats_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    symptomState.loadSymptomRecords().then((_) => setState(() {}));
  }

  void _showSymptomDialog() async {
    String? selectedSymptom = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select a symptom'),
          children: symptomState.symptoms.map((symptom) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, symptom);
              },
              child: Text(symptom),
            );
          }).toList(),
        );
      },
    );

    if (selectedSymptom != null) {
      symptomState.addSymptomRecord(SymptomRecord(symptom: selectedSymptom, timestamp: DateTime.now()));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Symptom Counts:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SymptomStatsWidget(symptomState: symptomState),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showSymptomDialog, tooltip: 'Add Symptom', child: const Icon(Icons.add)),
    );
  }
}
