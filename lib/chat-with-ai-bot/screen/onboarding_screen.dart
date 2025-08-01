// ignore_for_file: unused_local_variable, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../helper/global.dart';
import '../model/onboard.dart';
import 'package:get/route_manager.dart';

import '../widget/custom_btn.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PageController();
    mq = MediaQuery.of(context).size;

    final list = [
      //onboarding 1
      Onboard(
          title: 'Ask Me Anything',
          subtitle:
              'I can be you Best Friend & You can ask me anything & I will help you ! ',
          lottie: 'ai_ask_me'),
      //onboarding 2
      Onboard(
          title: 'Imagination to Reality',
          subtitle:
              'Just Imagine anything & let me know, I will create something wonderful for you ! ',
          lottie: 'ai_play'),
    ];

    return Scaffold(
      body: PageView.builder(
          controller: c,
          itemCount: list.length,
          itemBuilder: (ctx, ind) {
            final isLast = ind == list.length - 1;
            return Column(children: [
              Lottie.asset('assets/lottie/${list[ind].lottie}.json',
                  height: mq.height * .6, width: isLast ? mq.width * .7 : null),
              //title
              Text(
                list[ind].title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5),
              ),
              //some space
              SizedBox(height: mq.height * .015),
              // subtitle
              SizedBox(
                width: mq.width * .7,
                child: Text(
                  list[ind].subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    letterSpacing: .5,
                  ),
                ),
              ),
              const Spacer(),

              // dots
              Wrap(
                  spacing: 10,
                  children: List.generate(
                      list.length,
                      (i) => Container(
                            width: i == ind ? 15 : 10,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == ind ? Colors.blue : Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                          ))),
              const Spacer(),
              // button
              CustomBtn(
                  onTap: () {
                    if (isLast) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen() ));
                      // Get.off(() => );
                    } else {
                      c.nextPage(
                          duration: const Duration(microseconds: 600),
                          curve: Curves.ease);
                    }
                  },
                  text: isLast ? 'Finish' : 'Next'),

              const Spacer(flex: 2),
            ]);
          }),
    );
  }
}
