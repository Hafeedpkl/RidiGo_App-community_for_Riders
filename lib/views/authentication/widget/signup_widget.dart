import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/controller/user_data.dart';
import 'package:ridigo/main.dart';
import 'package:ridigo/views/authentication/authentication_page.dart';

class SignupWidget extends StatefulWidget {
  SignupWidget({super.key, required this.size});
  final Size size;

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final formkey = GlobalKey<FormState>();

  final namecontroller = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      height: widget.size.height * 0.7,
      width: widget.size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: widget.size.width * 0.03),
          Text(
            'Sign Up',
            style:
                GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: widget.size.width * 0.1),
          SizedBox(
              // color: Colors.amber,
              width: widget.size.width * 0.8,
              height: widget.size.width * 0.7,
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: namecontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null ? 'Enter Name' : null,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: GoogleFonts.poppins(),
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
                                  width: 5, style: BorderStyle.none))),
                    ),
                    SizedBox(
                      height: widget.size.width * 0.05,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: GoogleFonts.poppins(),
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
                    SizedBox(
                      height: widget.size.width * 0.05,
                    ),
                    TextFormField(
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? 'Enter min 6 character'
                          : null,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: GoogleFonts.poppins(),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue,
            ),
            width: widget.size.width * 0.8,
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
                          builder: (context) => const AuthScreen(
                            isLogin: true,
                          ),
                        ));
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
    );
  }

  Future signUp({context}) async {
    final isvalid = formkey.currentState!.validate();
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
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
