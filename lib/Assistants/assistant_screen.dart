// ignore_for_file: prefer_const_constructors, unnecessary_import, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chat-with-ai-bot/screen/main_screen.dart';
import 'Generate-Papers/widgets/prompt-generate-paper.dart';
import 'MCQS/screens/correct_mcqs.dart';
import 'QuizWhiz/screen/quiz_app.dart';
import 'QuizWhiz/widgets/prompt-screen.dart';
import 'translator/screen/translator_feature.dart';
import 'widgets/assistant-screen-item.dart';
import 'widgets/assistant-widget.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          // Navigate to HomePage and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AssistantScreen()),
            (route) => false, // This removes all previous routes
          );
          return false; // Prevent default back behavior
        },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                    Center(
                        child: Text("AI ASSISTANT",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ))),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                AssistantCard(
                    title: "QuizWhiz",
                    description:
                        "Challenge yourself with smart MCQs and get instant results",
                    icon: Icons.quiz_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizPromptScreen()));
                    }),
                    const SizedBox(
                    height: 7,
                ),
                     AssistantCard(
                    title: "LinguaLift",
                    description:
                        "Translate academic text effortlessly & break the language barrier in just one tap.",
                    icon: Icons.translate_outlined,
                    onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TranslatorFeature()));
                    }),
                    const SizedBox(
                    height: 7,
                ),
                     AssistantCard(
                    title: "PaperGenie",
                    description:
                        "Craft professional mid and final term papers in seconds — just enter your topic and let the magic begin.",
                    icon:  Icons.description_outlined,
                    onTap: 
                         () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromptGeneratePaper()));
                    }),
                      const SizedBox(
                    height: 7,
                ),
                     AssistantCard(
                    title: "AnswerLens",
                    description:
                        "Snap your MCQ sheet and extract correct answers instantly — no more checking hassles!",
                    icon:  Icons.description_outlined,
                    onTap:  () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CorrectOptionList()));
                    }),
                // GridView(
                //   shrinkWrap: true,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     mainAxisSpacing: 10,
                //     crossAxisSpacing: 10,
                //     mainAxisExtent: 130,
                //   ),
                //   children: [
                //     AssistantScreenItem(
                //         title: 'MCQS',
                //         icon: Icons.description_outlined,
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => CorrectOptionList()));
                //         }),
                //     AssistantScreenItem(
                //         title: 'TRANSLATOR',
                //         icon: Icons.translate_outlined,
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => TranslatorFeature()));
                        // }),
                //     AssistantScreenItem(
                //         title: 'QUIZ TEST',
                //         icon: Icons.quiz_outlined,
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => QuizPromptScreen()));
                //         }),
                //     AssistantScreenItem(
                //       title: 'Generate Paper',
                //       icon: Icons.description_outlined,
                //       // icon :  Icons,
                      // onPressed: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => PromptGeneratePaper()));
                //       },
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
