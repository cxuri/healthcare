import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalsPage extends StatelessWidget {
  const HospitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals'),
        backgroundColor: Colors.green.shade600,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('hospitals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var hospitals = snapshot.data!.docs;

          return RefreshIndicator(
            onRefresh: () async {
              // Implement logic to refresh the hospitals list
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                var hospital = hospitals[index].data();
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: Colors.green.shade600,
                    ),
                    title: Text(
                      hospital['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location: ${hospital['location']}'),
                          const SizedBox(height: 4),
                          Text('Capacity: ${hospital['capacity']}'),
                        ],
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green.shade600,
                    ),
                    onTap: () {
                      // Handle tap, like showing more details of the hospital
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
