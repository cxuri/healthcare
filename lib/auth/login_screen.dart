import 'package:flutter/material.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/pages/home_page.dart'; // Import HomeScreen

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Clean white background for a hospital feel
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome back text
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800, // Hospital blue
                fontFamily: 'Roboto', // Clean, modern font
              ),
            ),
            SizedBox(height: 20),

            // Username (Email) field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Username (Email)',
                labelStyle: TextStyle(
                  color: Colors.green.shade600,
                ), // Label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green.shade600, // Border color on focus
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.green.shade600,
                ), // Label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green.shade600, // Border color on focus
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Sign In button (non-outlined, with border radius and enough size)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 55, // Set enough height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green.shade600, // Hospital green background
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Adds shadow for floating effect
                  textStyle: TextStyle(
                    fontSize: 18,
                  ), // Font size for button text
                ),
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  final userCredential = await _authService
                      .signInWithEmailPassword(email, password);

                  if (userCredential != null) {
                    print('Logged in as: ${userCredential.user?.email}');
                    // Navigate to the Home screen after login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    print('Login failed');
                    // Show error to the user
                    _showErrorDialog(context, 'Login failed');
                  }
                },
                child: Text('Sign In'),
              ),
            ),
            SizedBox(height: 20),

            // Google Sign In button (outlined, with border radius and enough size)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 55, // Set enough height
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.green.shade600,
                  ), // Green border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ), // Font size for button text
                ),
                onPressed: () async {
                  final userCredential = await _authService.signInWithGoogle();

                  if (userCredential != null) {
                    print('Logged in as: ${userCredential.user?.email}');
                    // Navigate to the Home screen after Google login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    print('Google sign-in failed');
                    // Show error to the user
                    _showErrorDialog(context, 'Google sign-in failed');
                  }
                },
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(
                    color: Colors.green.shade600,
                  ), // Green text for consistency
                ),
              ),
            ),
            SizedBox(height: 20),

            // Back to Home screen button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Back to Home',
                style: TextStyle(color: Colors.green.shade600), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to show error messages in a dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
