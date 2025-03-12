import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcare/pages/order_tracking.dart'; // Import the tracking page

class MyBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Bookings"), backgroundColor: Colors.green.shade600),
        body: const Center(child: Text("You must be logged in to view bookings.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Medicine Orders"), backgroundColor: Colors.green.shade600),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medicine_bookings') // Query the medicine_bookings collection
            .where('userId', isEqualTo: userId) // Filter by the user_id field
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          // Loop through the documents and extract order data
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String bookingId = snapshot.data!.docs[index].id; // Use the document ID as the bookingId

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderData['name'] ?? "Unknown Medicine",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Roboto', // Customize font
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("Quantity: ${orderData['quantity'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontFamily: 'Roboto', // Customize font
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Status: ${orderData['status'] ?? 'Pending'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(orderData['status']),
                          fontSize: 16,
                          fontFamily: 'Roboto', // Customize font
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.local_shipping, size: 20, color: Colors.white,),
                        label: const Text("Track Order",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,)
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700, // Modern button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          elevation: 5, // Button elevation
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTrackingPage(bookingId: bookingId),
                            ),
                          );
                        },
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

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'Shipped': return Colors.blue;
      case 'Delivered': return Colors.green;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}
