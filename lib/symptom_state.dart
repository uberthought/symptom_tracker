import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:symptom_tracker/symptom_record.dart';

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
