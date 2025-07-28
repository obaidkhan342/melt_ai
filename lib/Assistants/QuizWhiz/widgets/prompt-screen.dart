// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors, library_private_types_in_public_api, file_names, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../assistant_screen.dart';
import '../provider/quiz-provirder.dart';
import '../screen/quiz_app.dart';

class QuizPromptScreen extends StatefulWidget {
  @override
  _QuizPromptScreenState createState() => _QuizPromptScreenState();
}

class _QuizPromptScreenState extends State<QuizPromptScreen> {
  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizServices>(context, listen: false);

    return Consumer<QuizServices>(builder: (context, quizProvider, index) {
      return WillPopScope(
        onWillPop: () async {
          // Navigate to HomePage and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => QuizPromptScreen()),
            (route) => false, // This removes all previous routes
          );
          return false; // Prevent default back behavior
        },
        child: Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue.shade50,
              title: Text(
                'Quiz Generator',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssistantScreen()));
                  },
                  icon: Icon(Icons.arrow_back_ios))),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 59),
                  // Topic Input
                  TextField(
                    controller: quizProvider.topicController,
                    decoration: InputDecoration(
                      labelText: 'Enter Topic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: quizProvider.numberOfQuizzesController,
                    decoration: InputDecoration(
                      labelText: 'Number of Quizzes',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),

                  // Difficulty Dropdown
                  DropdownButtonFormField<String>(
                    // value: _selectedDifficulty,
                    value: quizProvider.selectedDifficulty,
                    decoration: InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                    ),
                    items: quizProvider.difficultOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      quizProvider.selectedDifficulty;
                      // setState(() {
                      //   _selectedDifficulty = newValue!;
                      // });
                    },
                  ),
                  SizedBox(height: 20),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: quizProvider.selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: quizProvider.categoryOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      quizProvider.selectedCategory = newValue!;
                    },
                  ),
                  SizedBox(height: 20),

                  // Type Dropdown
                  DropdownButtonFormField<String>(
                    value: quizProvider.selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: quizProvider.typeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      quizProvider.selectedType = newValue!;
                    },
                  ),
                  SizedBox(height: 30),

                  // Generate Btn
                  GestureDetector(
                    onTap: quizProvider.isLoading
                        ? null
                        : () => _generateQuiz(quizProvider: quizProvider),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade50,
                              Colors.white
                            ], // Subtle gradient background
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                              15), // Match card border radius
                        ),
                        child: quizProvider.isLoading
                            ? Container(
                                height: 40,
                                width: 40,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: const Color.fromARGB(
                                          255, 207, 204, 204)),
                                ),
                              )
                            : Center(
                                child: Text('Generate Quiz',
                                    style: TextStyle(color: Colors.black)),
                              ),
                        // style: ElevatedButton.styleFrom(
                        //   padding: EdgeInsets.symmetric(vertical: 15),
                        //   // backgroundColor: const Color.fromARGB(255, 214, 202, 202)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _generateQuiz({required QuizServices quizProvider}) async {
    // Get user inputs
    String topic = quizProvider.topicController.text.trim();
    String numberOfQuizzes = quizProvider.numberOfQuizzesController.text.trim();
    String difficulty = quizProvider.selectedDifficulty;
    String category = quizProvider.selectedCategory;
    String type = quizProvider.selectedType;

    // Validate inputs
    if (topic.isEmpty || numberOfQuizzes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return "";
    }

    // Start loading

    // Create the prompt
    String prompt = '''
Generate $numberOfQuizzes quiz questions in JSON format on the topic of "$topic". Each question should include the following fields:
- "type": "$type"
- "difficulty": "$difficulty"
- "category": "$category"
- "question": (the question text)
- "correct_answer": (the correct answer)
- "incorrect_answers": (a list of incorrect answers, 1 for boolean and 3 for multiple)

The response should be a **valid and complete JSON array** of objects, like this:

[
  {
    "type": "$type",
    "difficulty": "$difficulty",
    "category": "$category",
    "question": "Sample question?",
    "correct_answer": "Correct Answer",
    "incorrect_answers": ["Incorrect 1", "Incorrect 2", "Incorrect 3"]
  }
]

**Important**: Ensure the response is **only the JSON array** without any extra characters or formatting.
''';

    // Call the method to send the prompt and get the response
    try {
      String response = await quizProvider.sendMessageAndGetResponse(
        message: prompt,
        isTextOnly: true,
      );

      // Navigate to QuizApp Screen and pass quizJson
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => QuizApp()));

      // );
    } catch (e) {
      // Handle errors
      // setState(() {
      //   _isLoading = false;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating quiz: $e')),
      );
    }
  }
}
