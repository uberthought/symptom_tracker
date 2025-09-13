import 'package:flutter/material.dart';
import 'package:symptom_tracker/main.dart';
import 'package:symptom_tracker/symptom_stats_widget.dart';
import 'package:symptom_tracker/symptom_graphs_widget.dart';

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

  void _addPressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Symptom Record'),
          content: const Text('Are you sure you want to add a new symptom record?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add')),
          ],
        );
      },
    );

    if (confirmed == true) {
      symptomState.addSymptomRecord();
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
            const SizedBox(height: 16),
            SymptomGraphsWidget(symptomState: symptomState, symptom: 'Nausea'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addPressed, tooltip: 'Add Symptom', child: const Icon(Icons.add)),
    );
  }
}
