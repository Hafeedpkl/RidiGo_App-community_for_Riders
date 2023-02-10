import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:ridigo/views/signup/authentication_page.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});
  final List<Introduction> list = [
    Introduction(
      imageUrl: 'assets/images/a-guy-ride-scooter.png',
      title: 'Welcome',
      subTitle: 'Let\'s Go',
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
      subTitleTextStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
    ),
    Introduction(
      imageUrl: 'assets/images/community-image.png',
      title: 'Community Support',
      subTitle: 'We can connect together ',
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
      subTitleTextStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
    ),
    Introduction(
      imageUrl: 'assets/images/road-side-assistance.png',
      title: 'Roadside Assistance',
      subTitle: 'Don\'t worry about getting stuck, We are with you',
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
      subTitleTextStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
    ),
    Introduction(
      imageUrl: 'assets/images/logo-big.png',
      title: 'Let\'s Gets Started',
      subTitle: '',
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      subTitleTextStyle: GoogleFonts.poppins(fontSize: 12),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Colors.blue,
      foregroundColor: Colors.greenAccent,
      skipTextStyle: GoogleFonts.poppins(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      introductionList: list,
      onTapSkipButton: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          )),
    );
  }
}
