import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';

import 'package:ridigo/ui/profile/views/saved_posts/saved_events.dart';
import 'package:ridigo/ui/profile/views/saved_posts/saved_rides.dart';

// ignore: must_be_immutable
class SavedPostsScreen extends StatefulWidget {
  SavedPostsScreen({super.key, required this.wishList});
  List<dynamic> wishList;
  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final postprovider = Provider.of<PostProvider>(context, listen: false);
      postprovider.eventWishList!.clear();
      postprovider.ridesWishList!.clear();
      postprovider.getWishListedEventRides(userWishList: widget.wishList);

      log('get post called');
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
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
          title: const Text(
            'Saved Posts',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: kBackgroundColor,
        ),
        body: TabBarView(
          children: [
            //events
            SavedEventsScreen(wishList: widget.wishList),

            //Rides

            SavedRidesScreen(wishList: widget.wishList)
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
  void deactivate() {
    Provider.of<PostProvider>(context, listen: false).eventList.clear();
    Provider.of<PostProvider>(context, listen: false).ridesList.clear();
    super.deactivate();
  }
}
