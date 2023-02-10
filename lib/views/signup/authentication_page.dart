import 'package:flutter/material.dart';
import 'package:ridigo/controller/constants.dart';
import 'package:ridigo/views/signup/widget/login_widget.dart';
import 'package:ridigo/views/signup/widget/signup_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.width * 0.3,
              ),
              Image.asset('assets/images/logo-big.png'),
              SizedBox(
                height: size.width * 0.1,
              ),
              // SignupWidget(size: size)
              LogInWidget(size: size)
            ],
          ),
        ),
      ),
    );
  }
}
