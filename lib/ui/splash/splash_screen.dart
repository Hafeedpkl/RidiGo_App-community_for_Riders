import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ridigo/core/controller/constants.dart';
import 'package:ridigo/ui/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Image.asset('assets/images/logo-big.png'),
      ),
    );
  }
}
