import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/main.dart';
import 'package:ridigo/ui/authentication/views/signup.dart';

import '../../../core/constants/constants.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final formkey = GlobalKey<FormState>();

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
                height: size.height * 0.6,
                width: size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.width * 0.03),
                    Text(
                      'Log In',
                      style: GoogleFonts.poppins(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width * 0.1),
                    SizedBox(
                        // color: Colors.amber,
                        width: size.width * 0.8,
                        height: size.width * 0.37,
                        child: Form(
                          key: formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextFormField(
                                controller: emailController,
                                validator: (email) => email != null &&
                                        !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
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
                                validator: (value) =>
                                    value != null && value.length < 6
                                        ? 'Enter min 6 character'
                                        : null,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
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
                    Row(
                      children: [
                        MaterialButton(
                            onPressed: () {
                              resetPassword(context);
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue,
                      ),
                      width: size.width * 0.8,
                      height: 55,
                      child: MaterialButton(
                        onPressed: () => signIn(
                            context: context, navigationkey: navigatorKey),
                        child: Text(
                          'Log in',
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
                    // MaterialButton(
                    //   onPressed: () {
                    //     // signinGoogle(context);
                    //     dbLogin();
                    //   },
                    //   child:
                    //       Image.asset('assets/images/Google_login_button.png'),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an Account?',
                          style: GoogleFonts.sarala(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ));
                            },
                            child: Text(
                              'Sign up',
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

  Future signIn({context, navigationkey}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    String text;

    final isvalid = formkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        text = 'Eneterd email does\'nt Exist';
        final snackBar = SnackBar(content: Text(text));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void resetPassword(context) {
    final size = MediaQuery.of(context).size;
    final formkey1 = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset Password'),
            content: Form(
              key: formkey1,
              child: TextFormField(
                controller: emailController,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(color: Colors.black),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
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
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel',
                    style: GoogleFonts.poppins(color: Colors.black),
                  )),
              TextButton(
                child: Text('Reset Password', style: GoogleFonts.poppins()),
                onPressed: () {
                  final isvalid = formkey1.currentState!.validate();
                  if (!isvalid) return;
                  verifyEmail(context: context, controller: emailController);
                  Navigator.of(context).pop();
                  const snackBar = SnackBar(
                      content:
                          Text('password Reset Link is send to your Email'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              )
            ],
          );
        });
  }

  Future verifyEmail({context, controller}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controller.text.trim());

      Navigator.popUntil(context, (route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Navigator.pop(context);
    }
  }

  // final FirebaseAuth auth = FirebaseAuth.instance;
  // User? user;

  // Future signinGoogle(BuildContext context) async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleSignInAccount =
  //       googleSignIn.signIn() as GoogleSignInAccount?;
  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken);
  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithCredential(credential);
  //       user = userCredential.user;
  //     } on FirebaseAuthException catch (e) {
  //       // if(e.code =='account- dexists-with-different')
  //       print(e);
  //     } catch (e) {
  //       print('catch-$e');
  //     }
  //   }
  // }
}
