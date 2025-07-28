// ignore_for_file: file_names, unused_catch_stack, avoid_print, prefer_final_fields, unused_field

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneratePaper extends ChangeNotifier {
  Map<String, dynamic> paper = {"result": []};
  List<dynamic> get paperResults => paper["result"] ?? [];

  bool _isLoading = false;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  final List<String> _field = [
    'Computer Science',
    'Political Science',
    'Zoology',
    'Other',
  ];

  final List<String> _difficulty = ['easy', 'medium', 'hard'];
  final List<String> _term = ['midTerm', 'finalTerm'];
  List<String> get fieldOptions => _field;
  List<String> get difficultyOptions => _difficulty;
  List<String> get termOptions => _term;

  double mcqsMarks = 0;
  String _selectedDifficulty = 'medium';
  String _selectedTerm = 'midTerm';
  String _selectedField = 'Computer Science';
  bool _isPdfGenerating = false;
  bool get isPdfGenerating => _isPdfGenerating;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPdfGenerating(bool value) {
    _isPdfGenerating = value;
    notifyListeners();
  }

  String get selectedTerm => _selectedTerm;
  String get selectedField => _selectedField;
  String get selectedDifficulty => _selectedDifficulty;

  set selectedDifficulty(String value) {
    _selectedDifficulty = value;
    notifyListeners();
  }

  set selectedField(String value) {
    _selectedField = value;
    notifyListeners();
  }

  set selectedTerm(String value) {
    _selectedTerm = value;
    notifyListeners();
  }

  Future<String> sendPromtAndGetResponse({
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
        final rawContent =
            data["choices"][0]["message"]["content"]?.toString() ?? '';

        try {
          final parsed = jsonDecode(rawContent);
          if (parsed is List || parsed is Map) {
            paper = {"result": parsed};
            isLoading = false;
            notifyListeners();
            return rawContent;
          }
        } catch (_) {
          final extractedJson = _extractJsonArray(rawContent);
          if (extractedJson != null) {
            final parsed = jsonDecode(extractedJson);
            paper = {"result": parsed};
            isLoading = false;
            notifyListeners();
            return extractedJson;
          } else {
            throw Exception('Could not extract JSON array from response');
          }
        }
      } else {
        throw Exception('API error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      final errorMessage = 'Error: $e';
      paper['error'] = errorMessage;
      isLoading = false;
      notifyListeners();
      return errorMessage;
    }

    // Fallback: to satisfy Dart's type system
    throw Exception('Unhandled execution path in sendPromtAndGetResponse');
  }

  /// Helper function to extract a JSON array or object from a string
  String? _extractJsonArray(String text) {
    final regex = RegExp(
      r'(\[\s*{[\s\S]*?}\s*\])',
    ); // Matches [ { ... }, {...} ]
    final match = regex.firstMatch(text);
    return match?.group(1);
  }

  // Future<String> sendPromtAndGetResponse({
  //   required String message,
  //   bool isTextOnly = true,
  // }) async {
  //   isLoading = true;
  //   notifyListeners();

  //   const apiKey = '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';
  //   const url = 'https://openrouter.ai/api/v1/chat/completions';

  //   final headers = {
  //     'Authorization': 'Bearer $apiKey',
  //     'Content-Type': 'application/json',
  //   };

  //   final body = jsonEncode({
  //     "model": "google/gemini-flash-1.5",
  //     "messages": [
  //       {"role": "user", "content": message}
  //     ]
  //   });

  //   try {
  //     final response = await http.post(Uri.parse(url), headers: headers, body: body);
  //     log('Raw response: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final content = data["choices"][0]["message"]["content"];

  //       // Ensure it's a JSON array or convertable
  //       if (content.trim().startsWith('[') && content.trim().endsWith(']')) {
  //         final parsed = jsonDecode(content);
  //         paper = {"result": parsed};
  //         notifyListeners();
  //         isLoading = false;
  //         return content;
  //       } else {
  //         throw Exception('Response not in expected JSON list format');
  //       }
  //     } else {
  //       throw Exception('API error: ${response.statusCode} ${response.body}');
  //     }
  //   } catch (e) {
  //     final errorMessage = 'Error: $e';
  //     paper['error'] = errorMessage;
  //     isLoading = false;
  //     notifyListeners();
  //     return errorMessage;
  //   }
  // }
}

// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeneratePaper extends ChangeNotifier {
//   Map<String, dynamic> paper = {"result": []};
//   List<dynamic> get paperResults => paper["result"] ?? [];

//   bool _isLoading = false;
//   final TextEditingController subjectController = TextEditingController();
//   final TextEditingController contentController = TextEditingController();
//   final TextEditingController courseCodeController = TextEditingController();
//   final List<String> _field = [
//     'Computer Science',
//     'Political Science',
//     'Zoology',
//     'Other'
//   ];
//   final List<String> _difficulty = ['easy', 'medium', 'hard'];
//   final List<String> _term = ['midTerm', 'finalTerm'];
//   List<String> get fieldOptions => _field;
//   List<String> get difficultyOptions => _difficulty;
//   List<String> get termOptions => _term;

//   double mcqsMarks = 0;
//   String _selectedDifficulty = 'medium';
//   String _selectedTerm = 'midTerm';
//   String _selectedField = 'Computer Science';
//   bool _isPdfGenerating = false;
//   bool get isPdfGenerating => _isPdfGenerating;
//   bool get isLoading => _isLoading;
//   set isLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void setPdfGenerating(bool value) {
//     _isPdfGenerating = value;
//     notifyListeners();
//   }

//   String get selectedTerm => _selectedTerm;
//   String get selectedField => _selectedField;
//   String get selectedDifficulty => _selectedDifficulty;

//   set selectedDifficulty(String value) {
//     _selectedDifficulty = value;
//     notifyListeners();
//   }

//   set selectedField(String value) {
//     _selectedField = value;
//     notifyListeners();
//   }

//   set selectedTerm(String value) {
//     _selectedTerm = value;
//     notifyListeners();
//   }

//   Future<String> sendPromtAndGetResponse({
//     required String message,
//     bool isTextOnly = true,
//   }) async {
//     isLoading = true;
//     notifyListeners();
//     try {
//       final model = isTextOnly
//           ? GenerativeModel(
//               model: 'gemini-1.5-pro',
//               // model : 'gemini-pro',
//               apiKey: 'AIzaSyCujTTiOgfypSB3eGCUViont0LZngYHYag',
//               generationConfig: GenerationConfig(
//                 temperature: 0.4,
//                 topK: 32,
//                 topP: 1,
//                 maxOutputTokens: 4096,
//               ),
//               safetySettings: [
//                 SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
//                 SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
//               ],
//             )
//           : GenerativeModel(
//               model: 'gemini-1.5-flash',
//               apiKey: 'AIzaSyCujTTiOgfypSB3eGCUViont0LZngYHYag',
//               generationConfig: GenerationConfig(
//                 temperature: 0.4,
//                 topK: 32,
//                 topP: 1,
//                 maxOutputTokens: 4096,
//               ),
//               safetySettings: [
//                 SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
//                 SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
//               ],
//             );

//       // Create a chat session
//       final chatSession = model.startChat();

//       // Send the message and wait for the response
//       final response = await chatSession.sendMessage(Content.text(message));

//       // Extract the response text
//       final responseText = response.text ?? 'No response from the model.';
//       log('Response text: $responseText');

//       // Check if the response is a complete JSON array
//       if (!responseText.trim().startsWith('[') ||
//           !responseText.trim().endsWith(']')) {
//         log('Incomplete JSON response: $responseText');
//         throw Exception('Incomplete JSON response');
//       }

//       // Decode the response into a List or Map
//       final responseData = jsonDecode(responseText);
//       print('Response data: $responseData');

//       // Store the response in quizJson
//       // paper["result"] = responseData;
//       paper = {"result": responseData};
//       print('Quiz JSON updated: $paper');

//       notifyListeners();
//       isLoading = false;
//       return responseText;
//     } catch (e, stackTrace) {
//       final errorMessage = 'Error: $e';
//       paper['error'] = errorMessage;
//       isLoading = false;
//       notifyListeners();
//       return errorMessage;
//     }
//   }
// }
