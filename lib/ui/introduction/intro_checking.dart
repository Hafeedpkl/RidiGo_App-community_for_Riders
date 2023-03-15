import 'package:flutter/material.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/introduction/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash/splash_screen.dart';

class IntroChecking extends StatefulWidget {
  const IntroChecking({super.key});

  @override
  State<IntroChecking> createState() => _IntroCheckingState();
}

class _IntroCheckingState extends State<IntroChecking> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ));
    } else {
      await prefs.setBool('seen', true);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntroScreen(),
          ));
    }
  }

  @override
  void initState() {
    checkFirstSeen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
