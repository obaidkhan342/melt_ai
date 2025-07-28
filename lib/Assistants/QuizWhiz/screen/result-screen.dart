// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_brace_in_string_interps, sort_child_properties_last, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/quiz-provirder.dart';
import '../widgets/prompt-screen.dart';

class Result extends StatelessWidget {
  int marks;
  int totalMarks;

  Result({
    required this.marks,
    required this.totalMarks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 204, 204),
              Color.fromARGB(255, 73, 85, 175)
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("You have got ${marks} out of ${totalMarks}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              Consumer<QuizServices>(builder: (context, quizProvider, child) {
                return TextButton(
                  child: Text('Restart Quiz!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    quizProvider.resetState();
                    quizProvider.quizJson.clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizPromptScreen()
                            ),
                            
                            );
                  },
                );
              })
            ],
          )),
    );
  }
}
