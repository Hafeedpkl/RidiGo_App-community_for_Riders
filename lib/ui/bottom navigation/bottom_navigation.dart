import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridigo/ui/community%20chat/community_chat.dart';
import 'package:ridigo/ui/home/home_page.dart';
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
    const ProfileScreen(),
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
            icon: const Icon(Icons.home_outlined),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.search),
            title: Text(
              'Search',
              style: GoogleFonts.poppins(),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble_2),
            title: Text(
              'Chat',
              style: GoogleFonts.poppins(),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(CupertinoIcons.profile_circled),
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
