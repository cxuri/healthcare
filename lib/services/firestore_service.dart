import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all hospitals
  Future<List<Map<String, dynamic>>> fetchHospitals() async {
    final snapshot = await _db.collection("hospitals").get();
    return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
  }

  // Fetch all doctors
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final snapshot = await _db.collection("doctors").get();
    return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
  }

  // Fetch all medicines
  Future<List<Map<String, dynamic>>> fetchMedicines() async {
    final snapshot = await _db.collection("medications").get();
    return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
  }

  // Create a user profile with health records
  Future<void> createUserProfile(String userId, Map<String, dynamic> profileData) async {
    await _db.collection("users").doc(userId).set(profileData, SetOptions(merge: true));
  }

  // Fetch user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final doc = await _db.collection("users").doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  // Book an appointment
  Future<void> bookAppointment(String userId, String doctorId, String hospitalId, DateTime dateTime) async {
    await _db.collection("appointments").add({
      "userId": userId,
      "doctorId": doctorId,
      "hospitalId": hospitalId,
      "dateTime": dateTime.toIso8601String(),
      "status": "booked"
    });
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    await _db.collection("appointments").doc(appointmentId).delete();
  }
}
