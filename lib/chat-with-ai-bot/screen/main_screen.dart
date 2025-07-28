// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unused_import, deprecated_member_use

import 'package:flutter/material.dart';

import '../chat_with_gemini/screens/chat_screen.dart';
import '../chat_with_gemini/utility/custom-colors.dart';
import '../../Assistants/generate_image_by_ai/screen/image_feature.dart';
// import '../translator/screen/translator_feature.dart';
import '../../Assistants/assistant_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // const BottomNavigation({super.key});
  int currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ChatScreen(),
    AssistantScreen(),
    ImageFeature(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
          // Navigate to HomePage and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false, // This removes all previous routes
          );
          return false; // Prevent default back behavior
        },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.home, title: "Home"),
              TabItem(icon: Icons.chat, title: "Chat"),
              TabItem(icon: Icons.assistant, title: "Assistants"),
              TabItem(icon: Icons.art_track, title: "Art"),
            ],
            backgroundColor: const Color.fromARGB(255, 33, 34, 36),
            initialActiveIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index; // Update the active index
              });
            }),
      //       bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currentIndex, // Tracks the active index
      //   onTap: (index) {
        // setState(() {
        //   currentIndex = index; // Update the active index
        // }
        // );
      //   },
      //   selectedItemColor: Colors.black, // Color for the active item
      //   unselectedItemColor: Colors.grey, // Color for inactive items
      //   showSelectedLabels: true, // Show labels for selected items
      //   showUnselectedLabels: true, // Show labels for unselected items
      //   type: BottomNavigationBarType.fixed, // Use fixed type for consistent behavior
      //   items: const [
      //     BottomNavigationBarItem(
        // icon: Icon(Icons.chat),
        // label: 'HOME  ',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat),
      //       label: 'Chat Ai',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assistant),
      //       label: 'Assistants',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.brush),
      //       label: 'Ai Art',
      //     ),
      //   ],
      // ),
      ),
    );
  }
}
