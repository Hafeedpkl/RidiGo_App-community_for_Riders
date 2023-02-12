import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:ridigo/ui/authentication/views/signup.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else if (snapshot.hasData) {
            return BottomNavScreen();
          } else {
            return SignupScreen();
          }
        });
  }
}
