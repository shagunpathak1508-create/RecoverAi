import 'package:flutter/material.dart';

class MockData {
  // ── 1. PATIENTS ──────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> patients = [
    { 
      "patient_id": "p1", "name": "John Smith", "age": 68, "condition": "knee_recovery", 
      "doctor_id": "doc_101", "caregiver_id": "care_201", "start_date": "2026-03-22", 
      "expected_recovery_days": 45, "last_updated": "2026-03-29", "backup_contact": "+1-555-0101"
    },
    { 
      "patient_id": "p2", "name": "Alice Johnson", "age": 45, "condition": "fever", 
      "doctor_id": "doc_101", "caregiver_id": "care_202", "start_date": "2026-03-22", 
      "expected_recovery_days": 7, "last_updated": "2026-03-29", "backup_contact": "+1-555-0202"
    },
    { 
      "patient_id": "p3", "name": "Robert Davis", "age": 72, "condition": "heart", 
      "doctor_id": "doc_102", "caregiver_id": "care_203", "start_date": "2026-03-22", 
      "expected_recovery_days": 90, "last_updated": "2026-03-29", "backup_contact": "+1-555-0303"
    }
  ];

  // ── 2. TASKS ─────────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> tasks = [
    { "task_id": "t1", "patient_id": "p1", "task_name": "Morning Meds (Ibuprofen)", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t2", "patient_id": "p1", "task_name": "15-Min Leg Raises", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t3", "patient_id": "p1", "task_name": "Afternoon Walk", "status": "missed", "date": "2026-03-28" },
    { "task_id": "t4", "patient_id": "p1", "task_name": "Ice Pack Application", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t5", "patient_id": "p1", "task_name": "Log Symptoms", "status": "missed", "date": "2026-03-28" },

    { "task_id": "t6", "patient_id": "p2", "task_name": "Check Temperature", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t7", "patient_id": "p2", "task_name": "Paracetamol 500mg", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t8", "patient_id": "p2", "task_name": "Drink 1L Water", "status": "missed", "date": "2026-03-28" },
    { "task_id": "t9", "patient_id": "p2", "task_name": "Rest for 2 hours", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t10", "patient_id": "p2", "task_name": "Check Temperature", "status": "completed", "date": "2026-03-28" },

    { "task_id": "t11", "patient_id": "p3", "task_name": "Morning Aspirin", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t12", "patient_id": "p3", "task_name": "Check Blood Pressure", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t13", "patient_id": "p3", "task_name": "Low Sodium Lunch", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t14", "patient_id": "p3", "task_name": "10-Min Paced Walk", "status": "missed", "date": "2026-03-28" },
    { "task_id": "t15", "patient_id": "p3", "task_name": "Evening Meds", "status": "missed", "date": "2026-03-28" }
  ];

  // ── 3. SYMPTOMS ──────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> symptoms = [
    { "patient_id": "p1", "date": "2026-03-22", "selected_symptoms": ["Knee Pain", "Swelling"], "severity_map": { "Knee Pain": 8.0, "Swelling": 7.0 } },
    { "patient_id": "p1", "date": "2026-03-24", "selected_symptoms": ["Knee Pain", "Swelling"], "severity_map": { "Knee Pain": 6.0, "Swelling": 5.0 } },
    { "patient_id": "p1", "date": "2026-03-26", "selected_symptoms": ["Knee Pain"], "severity_map": { "Knee Pain": 4.0 } },
    { "patient_id": "p1", "date": "2026-03-28", "selected_symptoms": ["Knee Pain"], "severity_map": { "Knee Pain": 2.0 } },

    { "patient_id": "p2", "date": "2026-03-22", "selected_symptoms": ["High Temperature", "Headache", "Fatigue"], "severity_map": { "High Temperature": 9.0, "Headache": 7.0, "Fatigue": 8.0 } },
    { "patient_id": "p2", "date": "2026-03-24", "selected_symptoms": ["High Temperature", "Fatigue"], "severity_map": { "High Temperature": 6.0, "Fatigue": 6.0 } },
    { "patient_id": "p2", "date": "2026-03-26", "selected_symptoms": ["Fatigue"], "severity_map": { "Fatigue": 4.0 } },
    { "patient_id": "p2", "date": "2026-03-28", "selected_symptoms": [], "severity_map": {} },

    { "patient_id": "p3", "date": "2026-03-22", "selected_symptoms": ["Chest Pain", "Shortness of Breath"], "severity_map": { "Chest Pain": 7.0, "Shortness of Breath": 6.0 } },
    { "patient_id": "p3", "date": "2026-03-24", "selected_symptoms": ["Chest Pain", "Shortness of Breath", "Dizziness"], "severity_map": { "Chest Pain": 6.0, "Shortness of Breath": 5.0, "Dizziness": 4.0 } },
    { "patient_id": "p3", "date": "2026-03-26", "selected_symptoms": ["Chest Pain"], "severity_map": { "Chest Pain": 4.0 } },
    { "patient_id": "p3", "date": "2026-03-28", "selected_symptoms": ["Chest Pain", "Shortness of Breath"], "severity_map": { "Chest Pain": 3.0, "Shortness of Breath": 2.0 } }
  ];

  // ── 4. RECOVERY LOGS ─────────────────────────────────────────────────────
  static List<Map<String, dynamic>> recoveryLogs = [
    { "patient_id": "p1", "day_number": 1, "recovery_score": 30.0 },
    { "patient_id": "p1", "day_number": 3, "recovery_score": 42.0 },
    { "patient_id": "p1", "day_number": 5, "recovery_score": 58.0 },
    { "patient_id": "p1", "day_number": 7, "recovery_score": 70.0 },

    { "patient_id": "p2", "day_number": 1, "recovery_score": 10.0 },
    { "patient_id": "p2", "day_number": 3, "recovery_score": 40.0 },
    { "patient_id": "p2", "day_number": 5, "recovery_score": 85.0 },
    { "patient_id": "p2", "day_number": 7, "recovery_score": 100.0 },

    { "patient_id": "p3", "day_number": 1, "recovery_score": 40.0 },
    { "patient_id": "p3", "day_number": 3, "recovery_score": 45.0 },
    { "patient_id": "p3", "day_number": 5, "recovery_score": 55.0 },
    { "patient_id": "p3", "day_number": 7, "recovery_score": 65.0 }
  ];

  static Map<String, dynamic>? getPatient(String id) {
    return patients.firstWhere((p) => p['patient_id'] == id, orElse: () => {});
  }

  static List<Map<String, dynamic>> getTasksByPatient(String patientId) {
    return tasks.where((t) => t['patient_id'] == patientId).toList();
  }

  static List<Map<String, dynamic>> getSymptomsByPatient(String patientId) {
    return symptoms.where((s) => s['patient_id'] == patientId).toList();
  }

  static List<Map<String, dynamic>> getRecoveryLogsByPatient(String patientId) {
    return recoveryLogs.where((r) => r['patient_id'] == patientId).toList();
  }
}
