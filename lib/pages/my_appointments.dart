import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Appointments"), backgroundColor: Colors.green.shade600),
        body: const Center(child: Text("You must be logged in to view appointments.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments"), backgroundColor: Colors.green.shade600),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('appointments').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var appointments = snapshot.data!.docs;
          if (appointments.isEmpty) {
            return const Center(child: Text("No appointments found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index].data() as Map<String, dynamic>;
              String doctorName = appointment['doctorName'] ?? 'Unknown';
              String specialty = appointment['specialty'] ?? 'N/A';
              String hospitalName = appointment['hospitalName'] ?? 'N/A';
              String date = appointment['appointmentDate'] ?? 'N/A';
              String time = appointment['appointmentTime'] ?? 'N/A';
              String status = appointment['status'] ?? 'Pending';
              String appointmentId = appointments[index].id; // Get the appointment ID

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                specialty,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              ),
                              Text(
                                hospitalName,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(fontWeight: FontWeight.bold, color: _getStatusColor(status)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Show the Cancel button only if status is not 'Completed' or 'Cancelled'
                      if (status != 'Completed' && status != 'Cancelled')
                        ElevatedButton(
                          onPressed: () {
                            _showCancelDialog(context, appointmentId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Button background color
                          ),
                          child: const Text('Cancel Appointment', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to show confirmation dialog
  void _showCancelDialog(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: const Text('Are you sure you want to cancel this appointment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _cancelAppointment(appointmentId);
                Navigator.of(context).pop(); // Close the dialog after canceling
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Cancel the appointment in Firestore
  void _cancelAppointment(String appointmentId) {
    FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({
      'status': 'Cancelled',
    }).then((_) {
      print('Appointment status updated to Cancelled');
    }).catchError((error) {
      print('Error updating appointment: $error');
    });
  }

  // Get status color based on the status
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Scheduled':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
