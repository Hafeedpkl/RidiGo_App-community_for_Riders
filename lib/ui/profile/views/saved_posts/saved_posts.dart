import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';

import 'package:ridigo/ui/home/views/events.dart';
import 'package:ridigo/ui/home/views/rides.dart';

class SavedPostsScreen extends StatefulWidget {
   SavedPostsScreen({super.key,required this.wishList});
 List<dynamic> wishList;
  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final postprovider = Provider.of<PostProvider>(context, listen: false);
      postprovider.eventList.clear();
      postprovider.ridesList.clear();
      postprovider.getPosts();
      log('get post called');
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            'assets/images/newLogo.png',
            scale: 10,
          ),
          backgroundColor: kBackgroundColor,
        ),
        body:  TabBarView(
          children: [
            //events
        // Saved

            //Rides

            // RidesScreen()
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   shape: const CircleBorder(),
        //   onPressed: () {},
        //   child: const Icon(
        //     Icons.add,
        //   ),
        // ),
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<PostProvider>(context, listen: false).eventList.clear();
    Provider.of<PostProvider>(context, listen: false).ridesList.clear();
    super.dispose();
  }
}
