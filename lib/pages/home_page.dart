import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcare/services/auth_service.dart'; // Import AuthService for sign-out

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService(); // Instance of AuthService

  @override
  Widget build(BuildContext context) {
    final User? user =
        FirebaseAuth.instance.currentUser; // Get the current user

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.green.shade600, // Use a healthcare green color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, // Center the content
          children: [
            // Welcome message
            Text(
              'Welcome, ${user?.email ?? "Guest"}!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color:
                    Colors
                        .green
                        .shade600, // Use a professional hospital green color
                fontFamily: 'Roboto', // Use a modern, clean font (Roboto)
              ),
            ),
            SizedBox(height: 40),

            // Description text (optional)
            Text(
              'Welcome to Healthcare, solution for healthcare',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // Subtle dark color for the description
              ),
              textAlign: TextAlign.center, // Center align the text
            ),
            SizedBox(height: 40),

            // Cards section
            Expanded(
              child: ListView(
                children: [
                  // Consult a doctor card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.medical_services,
                        color: Colors.green.shade600,
                      ),
                      title: Text('Consult a doctor'),
                      onTap: () {
                        // Add navigation logic for consulting a doctor
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // My medical history card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Colors.green.shade600,
                      ),
                      title: Text('My medical history'),
                      onTap: () {
                        // Add navigation logic for medical history
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // My profile card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.green.shade600,
                      ),
                      title: Text('My profile'),
                      onTap: () {
                        // Add navigation logic for profile
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Buy Medicines card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_pharmacy,
                        color: Colors.green.shade600,
                      ),
                      title: Text('Buy Medicines'),
                      onTap: () {
                        // Add navigation logic for buying medicines
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Logout button (non-outlined, with border radius and enough size)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 55, // Set enough height for button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green.shade600, // Green button background
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Adds a floating effect
                  textStyle: TextStyle(
                    fontSize: 18,
                  ), // Font size for button text
                ),
                onPressed: () async {
                  // Sign out using the AuthService
                  await _authService.signOut();
                  // After signing out, navigate to the login screen or auth home
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white, // White text for contrast
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Optional additional buttons or content can be added here, if needed
          ],
        ),
      ),
    );
  }
}
