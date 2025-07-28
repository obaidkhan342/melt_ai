// ignore_for_file: unused_field, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../chat_with_gemini/hive/pref.dart';
import '../chat_with_gemini/themes/my_theme.dart';
import '../helper/global.dart';
import '../helper/pref_provider.dart';
import '../model/home_type.dart';
import '../widget/home_card.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pref = Provider.of<PrefProvider>(context, listen: false);
      pref.setOnBoarding(value: false);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('MELT AI',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        ),
        // centerTitle: true,
        actions: [
          Consumer<PrefProvider>(
            builder: (BuildContext context, value, child) {
              return IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {
                  value.toggleDarkMode(value: !value.isDarkMode);
                },
                icon: Icon(
                    value.isDarkMode
                        ? Icons.brightness_2_rounded
                        : Icons.brightness_5_rounded,
                    size: 26),
              );
            },
          ),
        IconButton(
          onPressed: () async{
            
                // Get.offAll(() => WelcomeScreen());
          },
          icon: Icon(Icons.logout),
        )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * .04,
          vertical: mq.height * .09,
        ),
        children: HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
      ),
      // bottomNavigationBar: MainScreen(),
    );
  }
}
