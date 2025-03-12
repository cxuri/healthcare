import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcare/services/auth_service.dart';
import 'hospitals_page.dart';
import 'medicines_page.dart';
import 'profile_page.dart';
import 'book_appointment.dart';
import 'my_bookings.dart';
import 'my_appointments.dart';
import 'create_profile.dart'; // Import CreateProfilePage
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MyBookingsPage(),
    MyAppointmentsPage(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        selectedItemColor: Colors.green.shade600,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'My Appointments'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isProfileCreated = false;

  @override
  void initState() {
    super.initState();
    _checkIfProfileExists();
  }

  // Function to check if the user's profile exists
  void _checkIfProfileExists() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    // Fetch user profile from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    // Update the profileCreated flag based on whether the document exists
    setState(() {
      _isProfileCreated = snapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.green.shade600,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: const Text('Please login first'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.email ?? "Guest"}!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green.shade600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
                children: [
                  _buildMenuItem(context, 'Hospitals', Icons.local_hospital, HospitalsPage()),
                  _buildMenuItem(context, 'Medicines', Icons.local_pharmacy, MedicinesPage()),
                  _buildMenuItem(
                    context,
                    'Book Appointment',
                    Icons.calendar_today,
                    BookAppointmentPage(userId: user?.uid ?? ''),
                  ),
                  _buildMenuItem(context, 'Profile', Icons.account_circle, ProfilePage()),
                  // Only show 'Create Profile' if the profile doesn't exist
                  if (!_isProfileCreated)
                    _buildMenuItem(context, 'Create Profile', Icons.person_add, CreateProfilePage()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                child: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green.shade600),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
