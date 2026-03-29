import 'package:flutter/material.dart';
import 'dart:math';
import '../theme.dart';
import '../mock_data.dart';

class LivePatientsScreen extends StatefulWidget {
  const LivePatientsScreen({super.key});

  @override
  State<LivePatientsScreen> createState() => _LivePatientsScreenState();
}

class _LivePatientsScreenState extends State<LivePatientsScreen> {
  bool _isAdding = false;

  void _addPatient() {
    setState(() => _isAdding = true);
    
    final random = Random();
    final names = ['Alice Brown', 'Robert Doe', 'Mary Smith', 'James Wilson', 'Emma Watson', 'John Carter'];
    final conditions = ['knee_recovery', 'fever', 'heart'];
    
    final id = 'p${MockData.patients.length + 1}';
    final name = names[random.nextInt(names.length)];
    final condition = conditions[random.nextInt(conditions.length)];

    // Add to local mock data
    MockData.patients.add({
      'id': id,
      'name': name,
      'condition': condition,
      'pain_level': random.nextInt(10) + 1,
      'adherence': random.nextInt(40) + 60,
      'start_date': DateTime.now().toIso8601String().split('T')[0],
      'expected_recovery_days': 30,
      'backup_contact': '+1 555-0${random.nextInt(999)}',
    });

    setState(() {
      _isAdding = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient added locally!'), backgroundColor: kSuccess),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docs = MockData.patients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registry (Mock)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: _isAdding 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.person_add_rounded, size: 26),
                label: Text(
                  _isAdding ? 'Adding Patient...' : 'Add Patient',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _isAdding ? null : _addPatient,
              ),
            ),
          ),

          Expanded(
            child: docs.isEmpty 
              ? const Center(
                  child: Text(
                    'No patients found.\nClick "Add Patient" to start.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: kTextSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    
                    final name = data['name'] ?? 'Unknown';
                    final painLevel = data['pain_level'] ?? 0;
                    final adherence = data['adherence'] ?? 0;

                    final bool highPain = painLevel >= 8;
                    final bool lowAdherence = adherence <= 70;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: kPrimaryLight.withOpacity(0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: kPrimaryLight.withOpacity(0.15),
                              child: const Icon(Icons.person_rounded, color: kPrimary, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _MetricChip(
                                        icon: Icons.personal_injury_rounded,
                                        label: 'Pain: $painLevel/10',
                                        color: highPain ? kError : kAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      _MetricChip(
                                        icon: Icons.check_circle_rounded,
                                        label: '$adherence%',
                                        color: lowAdherence ? kWarning : kSuccess,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetricChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
