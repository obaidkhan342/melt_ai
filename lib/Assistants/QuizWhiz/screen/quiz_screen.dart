// // ignore_for_file: prefer_const_constructors, unused_local_variable
// ignore_for_file: prefer_const_constructors, unused_local_variable, use_super_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../color.dart';
import '../image.dart';
import '../provider/quiz-provirder.dart';
import '../text_style.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizServices>(context, listen: false);
      quizProvider.loadQuestion(); // Load the first question
      quizProvider.startTimer(context); // Start the timer
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizServices>(context);
    var size = MediaQuery.of(context).size;
    var data = quizProvider.quizJson["results"];

    // Check if data is valid
    if (data == null || data is! List || data.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Error: No quiz data available or invalid data format.'),
        ),
      );
    }

    // Check if the current question is valid
    if (quizProvider.currentQuestionIndex >= data.length) {
      return Scaffold(
        body: Center(
          child: Text('Error: Invalid question index.'),
        ),
      );
    }

    var currentQuestion = data[quizProvider.currentQuestionIndex];
    if (currentQuestion == null || currentQuestion["question"] == null ||  currentQuestion["correct_answer"] == null || currentQuestion["incorrect_answers"] == null) {
      return Scaffold(
        body: Center(
          child: Text('Error: Invalid question data.'),
        ),
      );
    }


    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 207, 204, 204), Color.fromARGB(255, 73, 85, 175)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<QuizServices>(
                        builder: (context, quizProvider, child) {
                      return IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          quizProvider.quizJson.clear();
                          quizProvider.currentQuestionIndex = 0;
                        },
                        icon: const Icon(CupertinoIcons.xmark,
                            color: Colors.white, size: 28),
                      );
                    }),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        normalText(
                            color: Colors.white,
                            size: 24,
                            text: "${quizProvider.seconds}"),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: quizProvider.seconds / 60,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Image.asset(ideas, width: 200),
                const SizedBox(height: 10),
                normalText(
                  color: lightgrey,
                  size: 14,
                  text:
                      "Question ${quizProvider.currentQuestionIndex + 1} of ${data.length}",
                ),
                const SizedBox(height: 20),
                normalText(
                  color: Colors.white,
                  size: 20,
                  text: currentQuestion["question"],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: quizProvider.optionsList.length,
                  itemBuilder: (BuildContext context, int index) {
                     var answer = currentQuestion["correct_answer"];
                    return GestureDetector(
                      onTap:quizProvider.selectedOptionIndex == null // Allow selection only if no option is selected
          ? () {
              quizProvider.selectOption(index,context);
            }
          : null,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        width: size.width - 100,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: quizProvider.optionsColor[index],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: headingText(
                          color: blue,
                          size: 18,
                          text: quizProvider.optionsList[index].toString(),
                        ),
                      ),
                    );

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

