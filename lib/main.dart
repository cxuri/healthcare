import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthcare/auth/auth_home.dart';
import 'package:healthcare/auth/login_screen.dart';
import 'package:healthcare/auth/register_screen.dart';
import 'package:healthcare/pages/home_page.dart';
import 'package:healthcare/services/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute:
          AuthService().checkLogin()
              ? '/home'
              : '/auth', // Initial screen, could be the AuthHome screen
      routes: {
        '/auth': (context) => AuthHome(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
