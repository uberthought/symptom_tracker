import 'package:flutter/material.dart';
import 'package:symptom_tracker/main.dart';

class RecordsViewPage extends StatefulWidget {
  const RecordsViewPage({super.key});

  @override
  State<RecordsViewPage> createState() => _RecordsViewPageState();
}

class _RecordsViewPageState extends State<RecordsViewPage> {
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteRecord(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Record'),
          content: const Text('Are you sure you want to delete this symptom record?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
          ],
        );
      },
    );

    if (confirmed == true) {
      symptomState.deleteSymptomRecord(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = symptomState.symptomRecords;

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('Symptom Records')),
      body: records.isEmpty
          ? const Center(child: Text('No symptom records found.', style: TextStyle(fontSize: 16)))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services, color: Colors.red),
                    title: Text(record.symptom, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_formatDateTime(record.timestamp)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRecord(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
