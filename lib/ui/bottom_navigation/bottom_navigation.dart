import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/bottom_navigation/provider/bottom_nav_provider.dart';
import 'package:ridigo/ui/community_chat/views/chat_groups.dart';
import 'package:ridigo/ui/home/views/home_page.dart';
import 'package:ridigo/ui/map/map_screen.dart';
import 'package:ridigo/ui/profile/profile_screen.dart';

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
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);
    return Scaffold(
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
    );
  }
}
