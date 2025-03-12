import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  _MedicinesPageState createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  void _bookMedicine(BuildContext context, String medicineId, String name, int availableStock, String userId) {
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Book $name"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Available stock: $availableStock"),
              const SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Enter quantity"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter a valid quantity!")),
                  );
                  return;
                }
                if (quantity > availableStock) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Only $availableStock in stock!")),
                  );
                  return;
                }

                // Generate booking ID
                String bookingId = FirebaseFirestore.instance.collection("medicine_bookings").doc().id;

                // Store booking in Firestore
                await FirebaseFirestore.instance.collection("medicine_bookings").doc(bookingId).set({
                  "bookingId": bookingId,
                  "userId": userId,
                  "medicineId": medicineId,
                  "name": name,
                  "quantity": quantity,
                  "status": "Pending",
                  "timestamp": FieldValue.serverTimestamp(),
                });

                // Update stock
                await FirebaseFirestore.instance.collection('medications').doc(medicineId).update({
                  "stock": availableStock - quantity,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Medicine booked successfully!"), backgroundColor: Colors.green),
                );

                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("Please log in to book medicines"),
        ),
      );
    }

    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
        backgroundColor: Colors.green.shade600,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search medicines...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() => searchQuery = query.toLowerCase());
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('medications').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var medicines = snapshot.data!.docs
              .where((doc) => (doc['name'] as String).toLowerCase().contains(searchQuery))
              .toList();

          if (medicines.isEmpty) {
            return const Center(
              child: Text("No medicines found", style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              var medicine = medicines[index].data();
              var medicineId = medicines[index].id;
              int stock = medicine['stock'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Brand: ${medicine['brand']}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Price: \$${medicine['price']}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Stock: $stock available',
                              style: TextStyle(
                                fontSize: 14,
                                color: stock > 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: stock > 0
                            ? () => _bookMedicine(context, medicineId, medicine['name'], stock, userId)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: stock > 0 ? Colors.green.shade600 : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Book"),
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
}
