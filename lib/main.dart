import 'package:flutter/material.dart';
import 'package:nita_auto/register.dart';
import 'firebase_functions.dart';
import 'login.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shared Auto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthCheck(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();

  @override
  Widget build(BuildContext context) {
    if (_firebaseFunctions.getCurrentUser() != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
