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

  Future<void> _addRecord() async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add New Record'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Adding Nausea record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                      if (date != null) {
                        setStateDialog(() {
                          selectedDate = date;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text('${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: selectedTime);
                      if (time != null) {
                        setStateDialog(() {
                          selectedTime = time;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    final dateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                    Navigator.of(context).pop({'symptom': 'Nausea', 'dateTime': dateTime});
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      symptomState.addSymptomRecordWithDateTime(result['symptom'], result['dateTime']);
      setState(() {});
    }
  }

  Future<void> _editRecord(int index) async {
    final record = symptomState.symptomRecords[index];
    DateTime selectedDate = DateTime(record.timestamp.year, record.timestamp.month, record.timestamp.day);
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(record.timestamp);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit Record'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Editing Nausea record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                      if (date != null) {
                        setStateDialog(() {
                          selectedDate = date;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text('${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: selectedTime);
                      if (time != null) {
                        setStateDialog(() {
                          selectedTime = time;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    final dateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                    Navigator.of(context).pop({'symptom': 'Nausea', 'dateTime': dateTime});
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      symptomState.editSymptomRecord(index, result['symptom'], result['dateTime']);
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editRecord(index),
                          tooltip: '',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRecord(index),
                          tooltip: '',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: _addRecord, tooltip: 'Add Record', child: const Icon(Icons.add)),
    );
  }
}
