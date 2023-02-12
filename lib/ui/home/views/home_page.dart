import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants.dart';
import 'package:ridigo/core/provider/user_data.dart';
import 'package:ridigo/ui/home/views/events.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;
    final username = Provider.of<UserDataProvider>(context).userName;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom:
              TabBar(indicatorColor: Colors.white, indicatorWeight: 3, tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Events',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.two_wheeler_rounded),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Rides',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ]),
          centerTitle: true,
          title: Image.asset(
            'assets/images/Logo.png',
            scale: 1.4,
          ),
          backgroundColor: kBackgroundColor,
        ),
        body: TabBarView(
          children: [
            //events
            EventsScreen(),

            //Rides

            const Center(
              child: Text('hai'),
            )
          ],
        ),
      ),
    );
  }
}
