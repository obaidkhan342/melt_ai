// ignore_for_file: unused_field, unused_local_variable, file_names

import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../chat-with-ai-bot/apis/apis.dart';
import '../../../chat-with-ai-bot/helper/global.dart';

class GenerateAiImageprovider extends ChangeNotifier {
  final TextEditingController imageController = TextEditingController();
  Image? _generatedImage;
  Status _status = Status.none;

  void displayAiGeneratedImage() async {
    setStatus = Status.loading;
    final imageBytes = await APIS.fetchImageBytes(imageController.text);
    try {
      if (imageBytes != null) {
        setGeneratedImage = Image.memory(imageBytes);
        setStatus = Status.complete;
      } else {
        log('Failed to load Image');
      }
      notifyListeners();
    } catch (e) {
      log('error : $e');
    }
  }

  Image? get generatedImage => _generatedImage;
  Status get status => _status;
  set setStatus(Status value) {
    _status = value;
    notifyListeners();
  }

  set setGeneratedImage(Image value) {
    _generatedImage = value;
    notifyListeners();
  }
}
