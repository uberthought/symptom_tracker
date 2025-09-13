import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:symptom_tracker/symptom_record.dart';

class SymptomState {
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

  void addSymptomRecord() {
    _symptomRecords.add(SymptomRecord(symptom: "Nausea", timestamp: DateTime.now()));
    _saveSymptomRecords();
  }

  void addSymptomRecordWithDateTime(String symptom, DateTime timestamp) {
    _symptomRecords.add(SymptomRecord(symptom: symptom, timestamp: timestamp));
    _saveSymptomRecords();
  }

  void deleteSymptomRecord(int index) {
    if (index >= 0 && index < _symptomRecords.length) {
      _symptomRecords.removeAt(index);
      _saveSymptomRecords();
    }
  }

  void editSymptomRecord(int index, String symptom, DateTime timestamp) {
    if (index >= 0 && index < _symptomRecords.length) {
      _symptomRecords[index] = SymptomRecord(symptom: symptom, timestamp: timestamp);
      _saveSymptomRecords();
    }
  }
}
