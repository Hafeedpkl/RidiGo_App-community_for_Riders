import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/provider/user_data.dart';
import 'package:ridigo/ui/authentication/views/signup.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/home/provider/event_provider.dart';
import 'package:ridigo/ui/home/provider/rides_provider.dart';
import 'package:ridigo/ui/home/views/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EventProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RidesProvider(),
        )
      ],
      child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            primarySwatch: Colors.blue,
          ),
          home: StreamBuilder<User?>(
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
                  return const BottomNavScreen();
                } else {
                  return SignupScreen();
                }
              })),
    );
  }
}
