import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';

class ReminderButton extends StatelessWidget {
  final String patientId;

  const ReminderButton({super.key, required this.patientId});

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReminderDialog(patientId: patientId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showReminderDialog(context),
        icon: const Icon(Icons.notifications_active_rounded),
        label: const Text(
          'Send Reminder',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}

class ReminderDialog extends StatelessWidget {
  final String patientId;

  const ReminderDialog({super.key, required this.patientId});

  Future<void> _sendReminder(BuildContext context, String reminderType) async {
    // 1. Show confirmation instantly
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '📩 $reminderType reminder sent successfully! Patient will be notified.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: kSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Close the dialog immediately
    Navigator.pop(context);

    // 2. Save reminder in Firestore (try-catch)
    try {
      await FirebaseFirestore.instance.collection('reminders').add({
        'patient_id': patientId,
        'caregiver_id': 'c1', // Hardcoded caregiver ID for demo
        'reminder_type': reminderType,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Reminder saved to Firestore.");
    } catch (e) {
      // Ignore if Firestore is not fully configured, as requested
      debugPrint("Error saving reminder to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.send_rounded, color: kPrimary),
          SizedBox(width: 10),
          Text('Send Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select the type of reminder to send to the patient:',
            style: TextStyle(color: kTextSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildOption(context, 'Medicine', Icons.medication_rounded, Colors.blue),
          const SizedBox(height: 12),
          _buildOption(context, 'Exercise', Icons.directions_run_rounded, Colors.orange),
          const SizedBox(height: 12),
          _buildOption(context, 'Symptom Logging', Icons.edit_note_rounded, Colors.purple),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: kTextSecondary, fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon, Color color) {
    return InkWell(
      onTap: () => _sendReminder(context, title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
