import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingPage extends StatelessWidget {
  final String bookingId;

  const OrderTrackingPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Tracking"), backgroundColor: Colors.green.shade600),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('medicine_bookings').doc(bookingId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          var booking = snapshot.data!.data() as Map<String, dynamic>;
          String status = booking['status'] ?? "Pending";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Order Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Stepper(
                  currentStep: _getCurrentStep(status),
                  steps: [
                    _buildStep("Pending", "Order placed", status),
                    _buildStep("Shipped", "On the way", status),
                    _buildStep("Delivered", "Arrived", status),
                  ],
                  controlsBuilder: (context, details) => const SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _getCurrentStep(String status) {
    switch (status) {
      case "Pending": return 0;
      case "Shipped": return 1;
      case "Delivered": return 2;
      default: return 0;
    }
  }

  Step _buildStep(String title, String subtitle, String currentStatus) {
    bool isActive = _getCurrentStep(currentStatus) >= _getCurrentStep(title);
    return Step(
      title: Text(title, style: TextStyle(color: isActive ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      content: const SizedBox(),
      isActive: isActive,
      state: isActive ? StepState.complete : StepState.indexed,
    );
  }
}
