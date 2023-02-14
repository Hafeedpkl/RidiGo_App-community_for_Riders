import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/authentication/authentication.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/new-logo.png',
          scale: 6,
        ),
      ),
    );
  }
}
