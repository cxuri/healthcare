import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  final String userId;

  BookAppointmentPage({required this.userId});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedHospitalId, _selectedHospitalName;
  String? _selectedSpecialty, _selectedDoctorId, _selectedDoctorName;
  DateTime? _selectedDate;
  String? _selectedTimeSlot, _description;
  bool _shareHealthRecords = false;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final List<String> _timeSlots = [
    "09:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM"
  ];

  List<Map<String, dynamic>> _doctors = [];
  List<String> _specialties = [];

  @override
  void initState() {
    super.initState();
    fetchSpecialties();
  }

  Future<void> fetchSpecialties() async {
    final snapshot = await FirebaseFirestore.instance.collection("doctors").get();
    final specialties = snapshot.docs.map((doc) => doc["specialty"] as String).toSet().toList();
    setState(() {
      _specialties = specialties;
    });
  }

  Future<List<Map<String, dynamic>>> fetchHospitals() async {
    final snapshot = await FirebaseFirestore.instance.collection("hospitals").get();
    return snapshot.docs.map((doc) => {"id": doc.id, "name": doc["name"]}).toList();
  }

  Future<void> fetchDoctorsBySpecialty(String specialty) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("doctors")
        .where("specialty", isEqualTo: specialty)
        .get();

    setState(() {
      _doctors = snapshot.docs.map((doc) => {
        "id": doc.id,
        "name": doc["name"],
      }).toList();
      _selectedDoctorId = null;  // Reset doctor selection
      _selectedDoctorName = null;
    });
  }

  Future<void> bookAppointment() async {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTimeSlot != null) {
      // Get user's profile details if they opt to share health records
      Map<String, dynamic> userProfile = {};
      if (_shareHealthRecords) {
        // Fetch user's profile data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(widget.userId).get();
        if (userDoc.exists) {
          userProfile = {
            "fullName": userDoc["fullName"],
            "age": userDoc["age"],
            "gender": userDoc["gender"],
            "medicalHistory": userDoc["medicalHistory"],
          };
        }
      }

      // Format the date for the appointment
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      String appointmentId = FirebaseFirestore.instance.collection("appointments").doc().id;

      // Save the appointment to Firestore
      await FirebaseFirestore.instance.collection("appointments").doc(appointmentId).set({
        "appointmentId": appointmentId,
        "userId": widget.userId,
        "hospitalId": _selectedHospitalId,
        "hospitalName": _selectedHospitalName,
        "specialty": _selectedSpecialty,
        "doctorId": _selectedDoctorId,
        "doctorName": _selectedDoctorName,
        "appointmentDate": formattedDate,
        "appointmentTime": _selectedTimeSlot,
        "shareHealthRecords": _shareHealthRecords,
        "description": _descriptionController.text,
        "status": "Scheduled",
      });

      // Store the profile data in a sub-collection if health records are shared
      if (_shareHealthRecords) {
        await FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointmentId)
            .collection("profileData")
            .doc(widget.userId) // Using the user ID as the document ID
            .set(userProfile);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Appointment booked successfully!"), backgroundColor: Colors.green),
      );

      Navigator.pop(context);
    }
  }



  Widget buildDropdown(
    String hint, String? value, List<Map<String, dynamic>> items, String displayKey, Function(String?, String?) onChanged
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
      onChanged: (selectedId) {
        final selectedItem = items.firstWhere((item) => item["id"] == selectedId);
        onChanged(selectedItem["id"], selectedItem[displayKey]);
      },
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item["id"],
          child: Text(item[displayKey]),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment"), backgroundColor: Colors.green.shade600),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FutureBuilder(
                future: fetchHospitals(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return buildDropdown(
                    "Select Hospital",
                    _selectedHospitalId,
                    snapshot.data as List<Map<String, dynamic>>,
                    "name",
                    (id, name) => setState(() {
                      _selectedHospitalId = id;
                      _selectedHospitalName = name;
                    }),
                  );
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                hint: Text("Select Specialty", style: TextStyle(color: Colors.grey[600])),
                onChanged: (specialty) {
                  setState(() {
                    _selectedSpecialty = specialty;
                    fetchDoctorsBySpecialty(specialty!);
                  });
                },
                items: _specialties.map((specialty) {
                  return DropdownMenuItem<String>(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              buildDropdown(
                "Select Doctor",
                _selectedDoctorId,
                _doctors,
                "name",
                (id, name) => setState(() {
                  _selectedDoctorId = id;
                  _selectedDoctorName = name;
                }),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Date",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              buildDropdown(
                "Select Time Slot",
                _selectedTimeSlot,
                _timeSlots.map((slot) => {"id": slot, "name": slot}).toList(),
                "name",
                (id, name) => setState(() => _selectedTimeSlot = id),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description (Optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Share Health Records?", style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _shareHealthRecords,
                    onChanged: (value) {
                      setState(() {
                        _shareHealthRecords = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: bookAppointment,
                child: const Text("Book Appointment", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
