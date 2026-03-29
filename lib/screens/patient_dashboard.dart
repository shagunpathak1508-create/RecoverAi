import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/section_card.dart';
import '../mock_data.dart';

// ── Dummy Patient Models (Simulation Only) ──────────────────────────────────
class DummyPatient {
  final String id;
  final String name;
  final String condition;
  const DummyPatient({required this.id, required this.name, required this.condition});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DummyPatient && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const List<DummyPatient> _dummyPatients = [
  DummyPatient(id: 'p1', name: 'John Smith (Knee Recovery)', condition: 'knee_recovery'),
  DummyPatient(id: 'p2', name: 'Alice Johnson (Fever)', condition: 'fever'),
  DummyPatient(id: 'p3', name: 'Robert Davis (Heart)', condition: 'heart'),
];

const Map<String, List<String>> _conditionSymptoms = {
  'knee_recovery': ['Knee Pain', 'Difficulty Walking', 'Swelling'],
  'fever': ['High Temperature', 'Headache', 'Fatigue'],
  'heart': ['Chest Pain', 'Shortness of Breath', 'Dizziness'],
};

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  late DummyPatient _currentPatient;
  final Set<String> _selectedSymptoms = {};
  final Map<String, double> _symptomSeverities = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentPatient = _dummyPatients[0];
  }

  void _onPatientChanged(DummyPatient? patient) {
    if (patient == null) return;
    setState(() {
      _currentPatient = patient;
      _selectedSymptoms.clear();
      _symptomSeverities.clear();
    });
  }

  void _toggleSymptom(String symptom, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedSymptoms.add(symptom);
        _symptomSeverities[symptom] = 0;
      } else {
        _selectedSymptoms.remove(symptom);
        _symptomSeverities.remove(symptom);
      }
    });
  }

  Future<void> _submitSymptoms() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one symptom.')));
      return;
    }
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    
    // In Mock mode, we just add to our local static list
    MockData.symptoms.add({
      'patient_id': _currentPatient.id,
      'condition': _currentPatient.condition,
      'selected_symptoms': _selectedSymptoms.toList(),
      'severity_map': Map<String, double>.from(_symptomSeverities),
      'date': DateTime.now().toIso8601String().split('T')[0],
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Symptoms logged (Local)!'), backgroundColor: kSuccess));
      setState(() { _selectedSymptoms.clear(); _symptomSeverities.clear(); _isSaving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableSymptoms = _conditionSymptoms[_currentPatient.condition] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // ── Simulation Toggle ──────────────────────────────────────────
          _buildSimulationDropdown(),
          const SizedBox(height: 16),

          // ── Greeting Card ─────────────────────────────────────────────
          _buildGreetingCard(),
          const SizedBox(height: 14),

          // ── 1. Dynamic Task List (Mock Sync) ─────────────────────
          _TasksListMock(patientId: _currentPatient.id),

          // ── 2. Symptom Logger ──────────────────────────────────────────
          SectionCard(
            title: 'Daily Symptom Logger',
            icon: Icons.monitor_heart_rounded,
            iconColor: kError,
            child: Column(
              children: [
                ...availableSymptoms.map((symptom) => _buildSymptomCard(symptom)),
                const SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSimulationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimary.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DummyPatient>(
          value: _currentPatient,
          isExpanded: true,
          icon: const Icon(Icons.swap_horiz_rounded, color: kPrimary),
          items: _dummyPatients.map((p) => DropdownMenuItem(value: p, child: Text('Simulate: ${p.name}', style: const TextStyle(fontSize: 18)))).toList(),
          onChanged: _onPatientChanged,
        ),
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hello, ${_currentPatient.name.split(' ')[0]} 👋', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const Text("Ready to track your progress?", style: TextStyle(fontSize: 16, color: Color(0xFFBBDEFB))),
      ]),
    );
  }

  Widget _buildSymptomCard(String symptom) {
    final isSelected = _selectedSymptoms.contains(symptom);
    final severity = _symptomSeverities[symptom] ?? 0;
    final color = _getSeverityColor(severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? color : Colors.grey.withOpacity(0.3), width: isSelected ? 2 : 1),
      ),
      child: Column(children: [
        CheckboxListTile(
          title: Text(symptom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          value: isSelected,
          activeColor: color,
          onChanged: (val) => _toggleSymptom(symptom, val),
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Slider(
              min: 0, max: 10, divisions: 10,
              label: '${severity.toInt()}',
              value: severity,
              activeColor: color,
              onChanged: (v) => setState(() => _symptomSeverities[symptom] = v),
            ),
          ),
      ]),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity, height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        icon: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.cloud_upload_rounded),
        label: Text(_isSaving ? 'Saving...' : 'Submit Symptoms', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: _isSaving ? null : _submitSymptoms,
      ),
    );
  }

  Color _getSeverityColor(double val) {
    if (val <= 3) return kSuccess;
    if (val <= 7) return Colors.orange;
    return kError;
  }
}

// ── 1. Tasks List Mock Widget
class _TasksListMock extends StatefulWidget {
  final String patientId;
  const _TasksListMock({required this.patientId});

  @override
  State<_TasksListMock> createState() => _TasksListMockState();
}

class _TasksListMockState extends State<_TasksListMock> {
  @override
  Widget build(BuildContext context) {
    final taskDocs = MockData.getTasksByPatient(widget.patientId);

    if (taskDocs.isEmpty) {
      return const SectionCard(title: 'Your Care Plan', icon: Icons.playlist_add_check_rounded, child: Text('No tasks assigned for today.'));
    }

    return SectionCard(
      title: 'Your Care Plan',
      icon: Icons.checklist_rtl_rounded,
      iconColor: kAccent,
      child: Column(
        children: taskDocs.map((data) {
          final isComp = data['status'] == 'completed';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CheckboxListTile(
              title: Text(data['task_name'] ?? 'Task', style: TextStyle(fontSize: 18, decoration: isComp ? TextDecoration.lineThrough : null, color: isComp ? kTextSecondary : kTextPrimary)),
              value: isComp,
              activeColor: kAccent,
              onChanged: (val) {
                setState(() {
                   data['status'] = (val == true ? 'completed' : 'missed');
                });
              },
              secondary: Icon(isComp ? Icons.check_circle_rounded : Icons.pending_actions_rounded, color: isComp ? kSuccess : kWarning),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: isComp ? Colors.grey.withOpacity(0.05) : Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}
