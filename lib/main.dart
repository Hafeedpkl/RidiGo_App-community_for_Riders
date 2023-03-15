import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/community_chat/provider/chat_provider.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';
import 'package:ridigo/ui/map/provider/map_provider.dart';
import 'package:ridigo/ui/profile/provider/user_provider.dart';
import 'package:ridigo/ui/bottom_navigation/provider/bottom_nav_provider.dart';
import 'package:ridigo/ui/splash/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        ),
      ],
      child: MaterialApp(
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            primarySwatch: Colors.blue,
            useMaterial3: true),
        home: const SplashScreen(),
        routes: {'/splashScreen': (context) => const SplashScreen()},
      ),
    );
  }
}
