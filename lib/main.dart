import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/symptom_record.dart';
import 'package:symptom_tracker/symptom_stats_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await symptomState.loadSymptomRecords();
  runApp(const MyApp());
}

SymptomState symptomState = SymptomState();

class SymptomState {
  final List<String> symptoms = ['Headache', 'Fever', 'Cough', 'Fatigue', 'Nausea'];
  final List<SymptomRecord> _symptomRecords = [];

  List<SymptomRecord> get symptomRecords => List.unmodifiable(_symptomRecords);

  Future<void> loadSymptomRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString('symptomRecords');
    if (recordsJson != null) {
      final List<dynamic> decoded = jsonDecode(recordsJson);
      _symptomRecords.clear();
      _symptomRecords.addAll(decoded.map((e) => SymptomRecord(symptom: e['symptom'], timestamp: DateTime.parse(e['timestamp']))));
    }
  }

  Future<void> _saveSymptomRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = jsonEncode(_symptomRecords.map((e) => {'symptom': e.symptom, 'timestamp': e.timestamp.toIso8601String()}).toList());
    await prefs.setString('symptomRecords', recordsJson);
  }

  void addSymptomRecord(SymptomRecord record) {
    _symptomRecords.add(record);
    _saveSymptomRecords();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symptom Tracker',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Symptom Tracker'),
    );
  }
}

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
