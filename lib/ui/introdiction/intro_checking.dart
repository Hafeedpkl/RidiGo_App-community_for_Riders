import 'package:flutter/material.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/introdiction/intro_screen.dart';
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
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ));
    } else {
      await prefs.setBool('seen', true);

      Navigator.push(
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
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
