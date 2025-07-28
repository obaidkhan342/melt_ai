// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../helper/global.dart';
import '../helper/pref_provider.dart';
import '../widget/custom_loading.dart';
import 'home_screen.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnOnboarding();
  }

  void _navigateBasedOnOnboarding() async {
    // Wait for splash screen duration (e.g., 3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Access the provider to check if onboarding is needed
    final pref = Provider.of<PrefProvider>(context, listen: false);
    bool isOnBoarding = pref.isOnBoarding;

    if (isOnBoarding) {
      // Navigate to Onboarding Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
      // );
    } else {
      // Navigate to Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // logo
            Padding(
              padding: EdgeInsets.all(mq.width * 0.05),
              child: Image.asset(
                'assets/images/logo.png',
                width: mq.width * .4,
              ),
            ),

            //for adding some space
            const Spacer(),

            //lottie loading
            Center(
              child: Text(
                'MELT AI',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            //for adding some space
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
