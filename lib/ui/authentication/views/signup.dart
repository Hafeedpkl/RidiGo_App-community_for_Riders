import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/profile/provider/user_data_provider.dart';
import 'package:ridigo/main.dart';
import 'package:ridigo/ui/authentication/views/login.dart';

import '../../../core/constants/constants.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({
    super.key,
  });

  final formkey = GlobalKey<FormState>();

  final namecontroller = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

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
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                height: size.height * 0.65,
                width: size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.width * 0.03),
                    Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width * 0.1),
                    SizedBox(
                        // color: Colors.amber,
                        width: size.width * 0.8,
                        height: size.width * 0.6,
                        child: Form(
                          key: formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextFormField(
                                controller: namecontroller,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value == null ? 'Enter Name' : null,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      CupertinoIcons.profile_circled,
                                      color: Colors.black,
                                    ),
                                    labelText: 'Username',
                                    labelStyle: GoogleFonts.poppins(
                                        color: Colors.black),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 5),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 5,
                                            style: BorderStyle.none))),
                              ),
                              TextFormField(
                                controller: emailController,
                                validator: (email) => email != null &&
                                        !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      CupertinoIcons.at,
                                      color: Colors.black,
                                    ),
                                    labelText: 'Email',
                                    labelStyle: GoogleFonts.poppins(
                                        color: Colors.black),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 5),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 2,
                                        ))),
                              ),
                              TextFormField(
                                controller: passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value != null && value.length < 6
                                        ? 'Enter min 6 character'
                                        : null,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      CupertinoIcons.padlock,
                                      color: Colors.black,
                                    ),
                                    labelText: 'Password',
                                    labelStyle: GoogleFonts.poppins(
                                        color: Colors.black),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 5),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 2,
                                        ))),
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: size.width * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue,
                      ),
                      width: size.width * 0.8,
                      height: 55,
                      child: MaterialButton(
                        onPressed: () => signUp(context: context),
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an Account?',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogInScreen()));
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signUp({context}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isvalid = formkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Provider.of<UserDataProvider>(context, listen: false).userName =
        namecontroller.text.trim();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      var snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
