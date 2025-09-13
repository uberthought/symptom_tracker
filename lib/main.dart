import 'package:flutter/material.dart';
import 'package:symptom_tracker/my_app.dart';
import 'package:symptom_tracker/symptom_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await symptomState.loadSymptomRecords();
  runApp(const MyApp());
}

SymptomState symptomState = SymptomState();
