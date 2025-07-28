// ignore_for_file: unused_import, unused_local_variable, body_might_complete_normally_nullable, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:translator_plus/translator_plus.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../helper/global.dart';

class APIS {
  static Future<Uint8List?> fetchImageBytes(String prompt) async {
    final url = Uri.parse(
        'https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev');
    final headers = {
      'Authorization': 'Bearer $fluxKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"inputs": prompt});

    try {
      final res = await post(url, headers: headers, body: body);
      if (res.statusCode == 200) {
        return res.bodyBytes;
      } else {
        log('Failed to fetch image : ${res.statusCode}');
      }
    } catch (e) {
      log('Error : $e');
      return null;
    }
  }
  


 static Future<String> generateTextFromFreeAPI({
    required String prompt,
    List<String> base64Images = const [],
  }) async {
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    // Build message content with both text and images
    final List<Map<String, dynamic>> contentParts = [];

    // Add the text part
    contentParts.add({
      "type": "text",
      "text": prompt,
    });

    // Add image parts (base64-encoded)
    for (var base64 in base64Images) {
      contentParts.add({
        "type": "image_url",
        "image_url": {
          "url": "data:image/jpeg;base64,$base64",
        },
      }
    );
    }

    final response = await http.post(
      url,
      headers: {
        // 'Authorization': 'Bearer apikey',
        'Authorization': 'Bearer apikey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://meltai.app',
        'X-Title': 'Melt AI Chat',
      },
      body: jsonEncode({
        'model': 'google/gemini-flash-1.5',
        'messages': [
          {
            'role': 'user',
            'content': contentParts,
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['choices'][0]['message']['content'] ?? 'No response';
    } else {
      throw Exception('Failed with status ${response.statusCode}: ${response.body}');
    }
  }

  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final res = await GoogleTranslator().translate(text, from: from, to: to);
      return res.text;
    } catch (e) {
      log('Google Translate : $e');
      return 'Something went Wrong!';
    }
  }
}
