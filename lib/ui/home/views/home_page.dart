import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ridigo/core/constants/constants.dart';

import 'package:ridigo/ui/home/views/events.dart';
import 'package:ridigo/ui/home/views/rides.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: [
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
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
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
            'assets/images/new-logo.png',
            scale: 10,
          ),
          backgroundColor: kBackgroundColor,
        ),
        body: const TabBarView(
          children: [
            //events
            EventsScreen(),

            //Rides

            RidesScreen()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
