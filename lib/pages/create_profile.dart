import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  int age = 0;
  String gender = 'Male';
  String medicalHistory = '';  // Corrected typo here

  // Controller for Age field
  final TextEditingController ageController = TextEditingController();

  // Gender options for dropdown
  List<String> genderOptions = ['Male', 'Female', 'Other'];

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the profile data to save
      Map<String, dynamic> profileData = {
        'fullName': fullName,
        'age': age,
        'gender': gender,
        'medicalHistory': medicalHistory,  // Ensure it's medicalHistory here as well
      };

      try {
        // Save profile data to Firestore under 'users' collection
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(profileData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
        Navigator.pop(context); // Go back to the previous page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Profile"),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Full Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                onSaved: (value) => fullName = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Field
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = int.tryParse(value!) ?? 0,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                onSaved: (value) => gender = value!,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Medical History Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Medical History'),
                onSaved: (value) => medicalHistory = value!,  // Corrected to medicalHistory here
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide your medical history';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Save Profile Button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
