// ignore_for_file: unused_catch_stack, avoid_print, dead_code, unused_field, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, unused_import, curly_braces_in_flow_control_structures, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../screen/result-screen.dart';
import '../widgets/prompt-screen.dart';

class QuizServices extends ChangeNotifier {
  int currentQuestionIndex = 0;
  int seconds = 60;
  Timer? timer;
  int points = 0;
  List<String> optionsList = [];
  List<Color> optionsColor = [];
  int? selectedOptionIndex; // Tracks the selected option index

  final TextEditingController topicController = TextEditingController();
  final TextEditingController numberOfQuizzesController =
      TextEditingController();

  String _selectedDifficulty = 'medium';
  String _selectedCategory = 'Programming';
  String _selectedType = 'multiple';

  final List<String> _difficultyOptions = ['easy', 'medium', 'hard'];
  final List<String> _categoryOptions = ['Programming', 'Networking', 'Other'];
  final List<String> _typeOptions = ['boolean', 'multiple'];

  bool _isLoading = false;

  String get selectedDifficulty => _selectedDifficulty;
  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;
  List<String> get difficultOptions => _difficultyOptions;
  List<String> get categoryOptions => _categoryOptions;
  List<String> get typeOptions => _typeOptions;
  bool get isLoading => _isLoading;

  int totalMarks = 0;

  // Map to store the quiz response
  Map<String, dynamic> quizJson = {"results": []};

  set selectedDifficulty(String value) {
    _selectedDifficulty = value;
    notifyListeners();
  }

  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  set selectedType(String value) {
    _selectedType = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> sendMessageAndGetResponse({
    required String message,
    bool isTextOnly = true,
  }) async {
    isLoading = true;
    notifyListeners();

    const apiKey = '';
    const url = 'https://openrouter.ai/api/v1/chat/completions';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": "google/gemini-flash-1.5",
      "messages": [
        {"role": "user", "content": message},
      ],
      // You can add generation parameters here if needed, e.g. temperature, max_tokens, etc.
      "temperature": 0.4,
      "max_tokens": 4096,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      log('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data["choices"][0]["message"]["content"];

        // Check if response is JSON array string
        if (content.trim().startsWith('[') && content.trim().endsWith(']')) {
          final parsed = jsonDecode(content);
          quizJson['results'] = parsed;
          notifyListeners();
          isLoading = false;
          return content;
        } else {
          throw Exception('Response not in expected JSON list format');
        }
      } else {
        throw Exception('API error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      final errorMessage = 'Error: $e';
      quizJson['error'] = errorMessage;
      isLoading = false;
      notifyListeners();
      return errorMessage;
    }
  }

  // Future<String> sendMessageAndGetResponse({
  //   required String message,
  //   bool isTextOnly = true,
  // }) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     final model = isTextOnly
  //         ? GenerativeModel(
  //             model: 'gemini-1.5-pro',
  //             apiKey: 'AIzaSyCujTTiOgfypSB3eGCUViont0LZngYHYag',
  //             generationConfig: GenerationConfig(
  //               temperature: 0.4,
  //               topK: 32,
  //               topP: 1,
  //               maxOutputTokens: 4096,
  //             ),
  //             safetySettings: [
  //               SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
  //               SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
  //             ],
  //           )
  //         : GenerativeModel(
  //             model: 'gemini-1.5-flash',
  //             apiKey: 'AIzaSyCujTTiOgfypSB3eGCUViont0LZngYHYag',
  //             generationConfig: GenerationConfig(
  //               temperature: 0.4,
  //               topK: 32,
  //               topP: 1,
  //               maxOutputTokens: 4096,
  //             ),
  //             safetySettings: [
  //               SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
  //               SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
  //             ],
  //           );

  //     // Create a chat session
  //     final chatSession = model.startChat();

  //     // Send the message and wait for the response
  //     final response = await chatSession.sendMessage(Content.text(message));

  //     // Extract the response text
  //     final responseText = response.text ?? 'No response from the model.';
  //     log('Response text: $responseText');

  //     // Check if the response is a complete JSON array
  //     if (!responseText.trim().startsWith('[') ||
  //         !responseText.trim().endsWith(']')) {
  //       log('Incomplete JSON response: $responseText');
  //       throw Exception('Incomplete JSON response');
  //     }

  //     // Decode the response into a List or Map
  //     final responseData = jsonDecode(responseText);
  //     print('Response data: $responseData');

  //     // Store the response in quizJson
  //     quizJson['results'] = responseData;
  //     print('Quiz JSON updated: $quizJson');

  //     notifyListeners();
  //     isLoading = false;
  //     return responseText;
  //   } catch (e, stackTrace) {
  //     final errorMessage = 'Error: $e';
  //     quizJson['error'] = errorMessage;
  //     isLoading = false;
  //     notifyListeners();
  //     return errorMessage;
  //   }
  // }

  // Load the current question
  void loadQuestion() {
    var data = quizJson["results"];
    totalMarks = data.length * 2;
    if (data != null && data is List && data.isNotEmpty) {
      if (currentQuestionIndex >= data.length) {
        // Handle invalid question index
        return;
      }

      var currentQuestion = data[currentQuestionIndex];
      if (currentQuestion != null &&
          currentQuestion["incorrect_answers"] != null &&
          currentQuestion["correct_answer"] != null) {
        optionsList = List.from(currentQuestion["incorrect_answers"]);
        optionsList.add(currentQuestion["correct_answer"]);
        optionsList.shuffle();
        optionsColor = List.generate(
          optionsList.length,
          (index) => Colors.white,
        );
        selectedOptionIndex = null; // Reset selected option index
      }
    }
    notifyListeners();
  }

  // Reset the state
  void resetState() {
    currentQuestionIndex = 0;
    seconds = 60;
    points = 0;
    optionsList = [];
    optionsColor = [];
    selectedOptionIndex = null;
    quizJson = {"results": []};
    totalMarks = 0;
    notifyListeners();
  }

  // Show completion dialog
  showCompletionDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Result(marks: points, totalMarks: totalMarks),
      ),
    );
    notifyListeners();
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Quiz Completed'),
    //     content: Text('You have completed the quiz! Your score is $points.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context); // Close the dialog
    //           resetState(); // Reset the state
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) =>
    //                       QuizPromptScreen())); // Navigate back to the prompt screen
    //         },
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }

  // Start the timer
  void startTimer(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        gotoNextQuestion(context); // Pass the context here
      }
      notifyListeners();
    });
  }

  // Reset colors for options
  void resetColors() {
    optionsColor = List.generate(optionsList.length, (index) => Colors.white);
    notifyListeners();
  }

  // Go to the next question
  void gotoNextQuestion(BuildContext context) {
    var data = quizJson["results"];
    if (data != null && data is List) {
      if (currentQuestionIndex < data.length - 1) {
        // Move to the next question
        currentQuestionIndex++;
        loadQuestion(); // Load the next question
        resetColors(); // Reset colors for the new question
        timer?.cancel();
        seconds = 60;
        startTimer(context); // Restart the timer
      } else {
        // Last question completed
        timer?.cancel();
        showCompletionDialog(context); // Show the completion dialog
      }
    }
    notifyListeners();
  }

  // Handle option selection
  void selectOption(int index, BuildContext context) {
    var data = quizJson["results"];
    if (data == null || data is! List || data.isEmpty) return;

    var currentQuestion = data[currentQuestionIndex];
    if (currentQuestion == null ||
        currentQuestion["correct_answer"] == null ||
        currentQuestion["incorrect_answers"] == null)
      return;

    // Set the selected option index
    selectedOptionIndex = index;

    // Check if the selected option is correct
    var answer = currentQuestion["correct_answer"];
    optionsColor[index] = optionsList[index] == answer
        ? Colors.green
        : Colors.red;

    // Update points if the answer is correct
    if (optionsList[index] == answer) {
      points += 2;
    }

    // Disable all other options
    for (int i = 0; i < optionsList.length; i++) {
      if (i != index) {
        optionsColor[i] = const Color.fromARGB(
          255,
          189,
          188,
          188,
        ); // Disable other options
      }
    }

    // Notify listeners to update the UI
    notifyListeners();

    // Delay navigation to the next question
    Future.delayed(const Duration(seconds: 1), () {
      gotoNextQuestion(context); // Pass the context here
    });
  }

  // Dispose timer
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
