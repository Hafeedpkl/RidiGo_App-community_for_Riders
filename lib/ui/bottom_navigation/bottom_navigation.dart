import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/bottom_navigation/provider/bottom_nav_provider.dart';
import 'package:ridigo/ui/community_chat/views/chat_groups.dart';
import 'package:ridigo/ui/home/views/home_page.dart';
import 'package:ridigo/ui/map/view/map_screen.dart';
import 'package:ridigo/ui/profile/profile_screen.dart';

import '../../common/api_base_url.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final pages = [
    const HomeScreen(),
    const MapScreen(),
    const ChatGroups(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    dbLogin(user);
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    final bottomNavProvider = Provider.of<BottomNavProvider>(context);
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: pages[bottomNavProvider.selectedIndex],
        bottomNavigationBar: FlashyTabBar(
          selectedIndex: bottomNavProvider.selectedIndex,
          showElevation: true,
          onItemSelected: (index) => bottomNavProvider.bottomChanger(index),
          items: [
            FlashyTabBarItem(
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Home',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            FlashyTabBarItem(
              icon: const Icon(
                Icons.location_on_outlined,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Map',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            FlashyTabBarItem(
              icon: const Icon(
                CupertinoIcons.chat_bubble_2,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Chat',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            FlashyTabBarItem(
              icon: const Icon(
                CupertinoIcons.profile_circled,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Profile',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future dbLogin(user) async {
    Dio dio = Dio();
    try {
      final url = Uri.parse("${kBaseUrl}profile/addNew");
      final response = await dio.post(url.toString(),
          data: {"email": "${user.email}", "uid": user.uid.toString()});
      log(response.data.toString());
      log(response.statusCode.toString());
    } on DioError catch (e) {
      log(e.toString());
    }
  }
}
