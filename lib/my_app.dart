import 'package:flutter/material.dart';
import 'package:symptom_tracker/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symptom Tracker',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Symptom Tracker'),
      debugShowCheckedModeBanner: false,
    );
  }
}
