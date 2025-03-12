import 'package:flutter/material.dart';
import 'package:healthcare/auth/login_screen.dart'; // Ensure the path is correct
import 'package:healthcare/auth/register_screen.dart'; // Ensure the path is correct

class AuthHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Clean white background for a hospital feel
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with a hospital-like color
            Text(
              'Welcome to Healthcare App',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800, // Trustworthy hospital blue
                fontFamily:
                    'Roboto', // Clean, modern font often used in healthcare
              ),
            ),
            SizedBox(height: 20),

            // Description Text with soft, healthcare-inspired colors
            Text(
              'Your Go to solution for all your needs.\nSign in or register to get started.',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                color:
                    Colors
                        .grey
                        .shade700, // Subtle dark gray for easy readability
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 100),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                height: 55, // Slightly taller button for better tap area
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors
                            .green
                            .shade600, // Hospital green for a calm feeling
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                    elevation: 5, // Adds a shadow for a floating effect
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Login'),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Register Button (outlined with clean border)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.green.shade600,
                    ), // Green border for consistency
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.green.shade600,
                    ), // Green text for consistency
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
