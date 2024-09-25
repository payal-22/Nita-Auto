import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_functions.dart';

//assets/images/wel.png;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();

  bool _isLoading = false; // To show a loading indicator while authenticating

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Show loading spinner
    });

    try {
      User? user = await _firebaseFunctions.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to sign in. Check your credentials."),
        ));
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors here
      String message = 'An error occurred, please try again.';
      if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        // Prevent overflow on smaller screens
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading // Show loading indicator when signing in
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
