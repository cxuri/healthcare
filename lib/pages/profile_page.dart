import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'update_profile.dart';  // Import the update profile page

class ProfilePage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green.shade600,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data found.'));
          }

          var profileData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                ProfileItem(
                  title: 'Full Name',
                  content: profileData['fullName'] ?? 'N/A',
                ),
                const SizedBox(height: 10),

                // Age
                ProfileItem(
                  title: 'Age',
                  content: profileData['age']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 10),

                // Gender
                ProfileItem(
                  title: 'Gender',
                  content: profileData['gender'] ?? 'N/A',
                ),
                const SizedBox(height: 10),

                // Medical History
                ProfileItem(
                  title: 'Medical History',
                  content: profileData['medicalHistory'] ?? 'No medical history available.',
                ),
                const SizedBox(height: 20),

                // Update Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the profile edit page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfilePage(), // Navigate to UpdateProfilePage
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600, // Background color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String content;

  const ProfileItem({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
