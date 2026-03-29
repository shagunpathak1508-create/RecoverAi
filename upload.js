const admin = require('firebase-admin');

// 1. Load the service account key you downloaded
const serviceAccount = require('./serviceAccountKey.json');

// 2. Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// 3. The exact dummy dataset
const dataset = {
  "patients": [
    { "patient_id": "p1", "name": "John Smith", "age": 68, "condition": "knee_recovery", "doctor_id": "doc_101", "caregiver_id": "care_201", "start_date": "2026-03-22T08:00:00Z", "expected_recovery_days": 45, "last_updated": "2026-03-28T09:30:00Z", "backup_contact": "+1-555-0101" },
    { "patient_id": "p2", "name": "Alice Johnson", "age": 45, "condition": "fever", "doctor_id": "doc_101", "caregiver_id": "care_202", "start_date": "2026-03-22T10:15:00Z", "expected_recovery_days": 7, "last_updated": "2026-03-28T14:20:00Z", "backup_contact": "+1-555-0202" },
    { "patient_id": "p3", "name": "Robert Davis", "age": 72, "condition": "heart", "doctor_id": "doc_102", "caregiver_id": "care_203", "start_date": "2026-03-22T07:45:00Z", "expected_recovery_days": 90, "last_updated": "2026-03-28T11:00:00Z", "backup_contact": "+1-555-0303" }
  ],
  "tasks": [
    { "task_id": "t1", "patient_id": "p1", "task_name": "Morning Meds", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t2", "patient_id": "p1", "task_name": "Leg Raises", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t3", "patient_id": "p1", "task_name": "Walk", "status": "missed", "date": "2026-03-28" },
    { "task_id": "t6", "patient_id": "p2", "task_name": "Check Temp", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t8", "patient_id": "p2", "task_name": "Drink Water", "status": "missed", "date": "2026-03-28" },
    { "task_id": "t11", "patient_id": "p3", "task_name": "Aspirin", "status": "completed", "date": "2026-03-28" },
    { "task_id": "t14", "patient_id": "p3", "task_name": "Paced Walk", "status": "missed", "date": "2026-03-28" }
  ],
  "symptoms": [
    { "patient_id": "p1", "date": "2026-03-28", "selected_symptoms": ["Knee Pain", "Swelling"], "severity": { "Knee Pain": 6, "Swelling": 4 } },
    { "patient_id": "p2", "date": "2026-03-28", "selected_symptoms": ["High Temperature", "Fatigue"], "severity": { "High Temperature": 8, "Fatigue": 7 } },
    { "patient_id": "p3", "date": "2026-03-28", "selected_symptoms": ["Chest Pain", "Shortness of Breath"], "severity": { "Chest Pain": 5, "Shortness of Breath": 5 } }
  ],
  "recovery_logs": [
    { "patient_id": "p1", "date": "2026-03-26", "day_number": 5, "recovery_score": 58 },
    { "patient_id": "p1", "date": "2026-03-28", "day_number": 7, "recovery_score": 70 },
    { "patient_id": "p2", "date": "2026-03-26", "day_number": 5, "recovery_score": 85 },
    { "patient_id": "p2", "date": "2026-03-28", "day_number": 7, "recovery_score": 100 },
    { "patient_id": "p3", "date": "2026-03-26", "day_number": 5, "recovery_score": 55 },
    { "patient_id": "p3", "date": "2026-03-28", "day_number": 7, "recovery_score": 65 }
  ],
  "appointments": [
    { "patient_id": "p1", "doctor_id": "doc_101", "scheduled_date": "2026-04-05T10:00:00Z", "is_urgent": false, "note": "Post-op physical evaluation" },
    { "patient_id": "p2", "doctor_id": "doc_101", "scheduled_date": "2026-03-30T14:30:00Z", "is_urgent": true, "note": "Follow-up blood test results" },
    { "patient_id": "p3", "doctor_id": "doc_102", "scheduled_date": "2026-04-02T08:30:00Z", "is_urgent": false, "note": "Monthly ECG & Vitals Check" }
  ]
};

async function uploadData() {
  console.log("Starting Firebase upload...");
  const batch = db.batch();

  // Patients
  dataset.patients.forEach(p => {
    const ref = db.collection('patients').doc(p.patient_id);
    batch.set(ref, p);
  });

  // Tasks
  dataset.tasks.forEach(t => {
    const ref = db.collection('tasks').doc(t.task_id);
    batch.set(ref, t);
  });

  // Symptoms
  dataset.symptoms.forEach(s => {
    const ref = db.collection('symptoms').doc();
    batch.set(ref, s);
  });

  // Recovery Logs
  dataset.recovery_logs.forEach(r => {
    const ref = db.collection('recovery_logs').doc();
    batch.set(ref, r);
  });

  // Appointments
  dataset.appointments.forEach(a => {
    const ref = db.collection('appointments').doc();
    batch.set(ref, a);
  });

  // Execute batch
  try {
    await batch.commit();
    console.log("✅ BOOM! Your entire hackathon dataset has been uploaded to Firestore successfully.");
    process.exit(0);
  } catch (err) {
    console.error("❌ Error uploading:", err);
    process.exit(1);
  }
}

uploadData();
