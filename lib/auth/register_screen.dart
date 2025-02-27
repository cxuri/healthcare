import 'package:flutter/material.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/pages/home_page.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
            // Welcome text
            Text(
              'Create a new account!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800, // Professional hospital blue
                fontFamily: 'Roboto', // Clean, modern font
              ),
            ),
            SizedBox(height: 20),

            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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

            // Confirm Password field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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

            // Sign Up button (non-outlined, with border radius and enough size)
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
                  String confirmPassword = _confirmPasswordController.text;

                  if (password != confirmPassword) {
                    // Passwords don't match
                    print('Passwords do not match!');
                    return;
                  }

                  final userCredential = await _authService
                      .signUpWithEmailPassword(email, password);

                  if (userCredential != null) {
                    print('User registered as: ${userCredential.user?.email}');
                    // Navigate to another screen, like the home screen
                  } else {
                    print('Sign up failed');
                    // Show error to the user
                  }
                },
                child: Text('Sign Up'),
              ),
            ),
            SizedBox(height: 20),

            // Google Sign Up button (outlined, with border radius and enough size)
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
                    print(
                      'User signed up with Google: ${userCredential.user?.email}',
                    );
                    // Navigate to the home screen after successful registration
                  } else {
                    print('Google sign-up failed');
                    // Show error to the user
                  }
                },
                child: Text(
                  'Sign Up with Google',
                  style: TextStyle(
                    color: Colors.green.shade600,
                  ), // Green text for consistency
                ),
              ),
            ),
            SizedBox(height: 20),

            // Back to home screen button
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
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
}
