import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridigo/ui/community_chat/community_chat.dart';
import 'package:ridigo/ui/home/views/home_page.dart';
import 'package:ridigo/ui/map/map_screen.dart';
import 'package:ridigo/ui/profile/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  final pages = [
    const HomeScreen(),
    const MapScreen(),
    const ChatScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
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
